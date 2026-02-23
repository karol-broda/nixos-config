package main

import (
	"crypto/md5"
	_ "embed"
	"encoding/hex"
	"fmt"
	"io/fs"
	"log/slog"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"sync"
	"time"

	"al.essio.dev/pkg/shellescape"
	"github.com/abenz1267/elephant/v2/internal/util"
	"github.com/abenz1267/elephant/v2/pkg/common"
	"github.com/abenz1267/elephant/v2/pkg/pb/pb"
)

//go:embed readme.md
var readme string

var (
	Name       = "wallpaper"
	NamePretty = "Wallpaper"
)

type Config struct {
	common.Config `koanf:",squash"`
	Directory     string   `koanf:"directory" desc:"wallpaper directory path" default:"~/Pictures/Wallpapers"`
	Extensions    []string `koanf:"extensions" desc:"supported image file extensions"`
	SetCommand    string   `koanf:"set_command" desc:"shell command to set wallpaper, use %FILE% as placeholder" default:"hyprctl hyprpaper wallpaper ',%FILE%'"`
	Recursive     bool     `koanf:"recursive" desc:"search directory recursively" default:"true"`
}

type wallpaperItem struct {
	path       string
	name       string
	identifier string
}

var (
	config *Config
	items  []wallpaperItem
	mu     sync.Mutex
)

const (
	ActionSet      = "set"
	ActionCopyPath = "copy_path"
	ActionRefresh  = "refresh"
)

func Setup() {
	start := time.Now()

	config = &Config{
		Config: common.Config{
			Icon:     "image-x-generic",
			MinScore: 30,
		},
		Directory:  "~/Pictures/Wallpapers",
		Extensions: []string{".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"},
		SetCommand: "hyprctl hyprpaper wallpaper ',%FILE%'",
		Recursive:  true,
	}

	common.LoadConfig(Name, config)

	if config.NamePretty != "" {
		NamePretty = config.NamePretty
	}

	if len(config.Extensions) == 0 {
		config.Extensions = []string{".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"}
	}

	scanWallpapers()

	slog.Info(Name, "wallpapers", len(items), "time", time.Since(start))
}

func Available() bool {
	return true
}

func expandHome(path string) string {
	if strings.HasPrefix(path, "~/") {
		home, err := os.UserHomeDir()
		if err != nil {
			return path
		}

		return filepath.Join(home, path[2:])
	}

	return path
}

func scanWallpapers() {
	dir := expandHome(config.Directory)

	resolved, err := filepath.EvalSymlinks(dir)
	if err == nil {
		dir = resolved
	}

	var scanned []wallpaperItem

	walkFn := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return nil
		}

		if d.IsDir() {
			if strings.HasPrefix(d.Name(), ".") && path != dir {
				return filepath.SkipDir
			}

			if !config.Recursive && path != dir {
				return filepath.SkipDir
			}

			return nil
		}

		if strings.HasPrefix(d.Name(), ".") {
			return nil
		}

		ext := strings.ToLower(filepath.Ext(path))
		if !slices.Contains(config.Extensions, ext) {
			return nil
		}

		name := strings.TrimSuffix(d.Name(), filepath.Ext(d.Name()))
		name = strings.ReplaceAll(name, "-", " ")
		name = strings.ReplaceAll(name, "_", " ")

		hash := md5.Sum([]byte(path))
		identifier := hex.EncodeToString(hash[:])

		scanned = append(scanned, wallpaperItem{
			path:       path,
			name:       name,
			identifier: identifier,
		})

		return nil
	}

	filepath.WalkDir(dir, walkFn)

	slices.SortFunc(scanned, func(a, b wallpaperItem) int {
		return strings.Compare(strings.ToLower(a.name), strings.ToLower(b.name))
	})

	mu.Lock()
	items = scanned
	mu.Unlock()
}

func findItem(identifier string) *wallpaperItem {
	mu.Lock()
	defer mu.Unlock()

	for i := range items {
		if items[i].identifier == identifier {
			return &items[i]
		}
	}

	return nil
}

func Activate(single bool, identifier, action, query, args string, format uint8, conn net.Conn) {
	if action == "" {
		action = ActionSet
	}

	switch action {
	case ActionSet:
		wallpaper := findItem(identifier)
		if wallpaper == nil {
			slog.Error(Name, "activate", "wallpaper not found", "identifier", identifier)
			return
		}

		toRun := strings.ReplaceAll(config.SetCommand, "%FILE%", shellescape.Quote(wallpaper.path))

		cmd := exec.Command("sh", "-c", toRun)
		err := cmd.Start()
		if err != nil {
			slog.Error(Name, "activate", err)
			return
		}

		go func() {
			cmd.Wait()
		}()

	case ActionCopyPath:
		wallpaper := findItem(identifier)
		if wallpaper == nil {
			return
		}

		cmd := exec.Command("wl-copy", "--", wallpaper.path)
		err := cmd.Start()
		if err != nil {
			slog.Error(Name, "activate", err)
			return
		}

		go func() {
			cmd.Wait()
		}()

	case ActionRefresh:
		scanWallpapers()
		slog.Info(Name, "refresh", len(items))

	default:
		slog.Error(Name, "activate", fmt.Sprintf("unknown action: %s", action))
	}
}

func Query(conn net.Conn, query string, single bool, exact bool, _ uint8) []*pb.QueryResponse_Item {
	mu.Lock()
	snapshot := make([]wallpaperItem, len(items))
	copy(snapshot, items)
	mu.Unlock()

	entries := []*pb.QueryResponse_Item{}

	for _, v := range snapshot {
		e := &pb.QueryResponse_Item{
			Identifier:  v.identifier,
			Text:        v.name,
			Subtext:     v.path,
			Icon:        config.Icon,
			Provider:    Name,
			Score:       0,
			Actions:     []string{ActionSet, ActionCopyPath},
			Preview:     v.path,
			PreviewType: util.PreviewTypeFile,
			Type:        pb.QueryResponse_REGULAR,
		}

		if query != "" {
			score, positions, start := common.FuzzyScore(query, v.name, exact)
			pathScore, pathPos, pathStart := common.FuzzyScore(query, filepath.Base(v.path), exact)

			if pathScore > score {
				score = pathScore
				positions = pathPos
				start = pathStart
			}

			e.Score = score
			e.Fuzzyinfo = &pb.QueryResponse_Item_FuzzyInfo{
				Field:     "text",
				Positions: positions,
				Start:     start,
			}

			if e.Score > config.MinScore {
				entries = append(entries, e)
			}
		} else {
			e.Score = int32(10000 - len(entries))
			entries = append(entries, e)
		}
	}

	return entries
}

func Icon() string {
	return config.Icon
}

func HideFromProviderlist() bool {
	return config.HideFromProviderlist
}

func PrintDoc() {
	fmt.Println(readme)
	fmt.Println()
	util.PrintConfig(Config{}, Name)
}

func State(provider string) *pb.ProviderStateResponse {
	return &pb.ProviderStateResponse{
		Actions: []string{ActionRefresh},
	}
}
