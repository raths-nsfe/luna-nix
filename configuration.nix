{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "luna";
    networkmanager.enable = true;

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