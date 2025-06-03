{ config, pkgs, ... }:

{
  #bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "dev/sda";
  boot.loader.grub.useOSProber = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "luna";
  };

  programs.ssh.startAgent = true;
  programs.bash.enableCompletion = true;

  # Don't blind me
  systemd.services.redshift.restartIfChanged = false;

  time.timeZone = "Australia/Melbourne";

  nixpkgs.system = "x86_64-linux";
  nixpkgs.config = {
    virtualbox.enableExtensionPack = true;
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs;
    [ 
        pkgs.neovim
        pkgs.lf
        pkgs.go
        pkgs.docker
        pkgs.nakama
    ];
}