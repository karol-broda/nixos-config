{pkgs, ...}: let
  # winboat v0.8.7 appimage (type 2)
  winboatAppImage = pkgs.fetchurl {
    url = "https://github.com/TibixDev/winboat/releases/download/v0.8.7/winboat-0.8.7-x86_64.AppImage";
    sha256 = "7c32a6b8aa0cb02d1aad609332aedd37bb34a1ad525105349477535880669fcd";
  };

  # use wrapType2 and provide pname + version explicitly
  winboat = pkgs.appimageTools.wrapType2 {
    pname = "winboat";
    version = "0.8.7";
    src = winboatAppImage;

    # add libs only if runtime complains; keep minimal for readability and perf
    extraPkgs = pkgs: [
      pkgs.zlib
      pkgs.fuse
    ];
  };
in {
  environment.systemPackages = with pkgs; [
    winboat
    freerdp
    iptables
    nftables
    qemu_kvm
    libvirt
    virt-manager
  ];

  boot.kernelModules = [
    "kvm"
    "kvm_amd"
    "iptable_nat"
  ];

  users.extraGroups.vboxusers.members = ["karolbroda"];
  users.extraGroups.libvirtd.members = ["karolbroda"];
}
