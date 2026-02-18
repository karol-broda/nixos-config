local loaded, sbar_module = pcall(require, "sketchybar")
if not loaded then
  print("Failed to load sketchybar module.")
  print("Ensure sbarlua is installed: nix-env -iA nixpkgs.lua54Packages.sbarlua")
  os.exit(1)
end

sbar = sbar_module

function trim(s)
  return s:match("^%s*(.-)%s*$")
end

function split(str, delimiter)
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

function round(num, decimals)
  local mult = 10 ^ (decimals or 0)
  return math.floor(num * mult + 0.5) / mult
end

function clamp(value, min, max)
  return math.max(min, math.min(max, value))
end

print("SketchyBar Lua helpers loaded")
