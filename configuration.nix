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
    hostName = "aya";
    networkmanager.enable = true;

  };

  services = {

    openssh.enable = true;

    redshift = {
      enable = true;
      latitude = "35";
      longitude = "139";
    };

    ntp.enable = true;
    nscd.enable = false;

    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      layout = "us";

      xkbOptions = "compose:caps";
      xkbVariant = "dvp";

      synaptics.enable = true;

      windowManager.xmonad.enable = true;
      windowManager.xmonad.extraPackages = self: [ self.xmonad-contrib ];
      windowManager.xmonad.haskellPackages = pkgs.haskell.packages.ghc822;
      windowManager.default = "xmonad";
      desktopManager.default = "none";

      displayManager.lightdm = {
        enable = true;
        extraSeatDefaults = ''
          greeter-show-manual-login=true
          greeter-hide-users=true
          allow-guest=false
        '';
      };

      displayManager.sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xscreensaver}/bin/xscreensaver -no-splash &
      '';
    };
  };

  users.extraGroups.vboxusers.members = [ "shana" ];

  programs.ssh.startAgent = true;
  programs.bash.enableCompletion = true;

  # Don't blind me
  systemd.services.redshift.restartIfChanged = false;

  time.timeZone = "Asia/Tokyo";

  nixpkgs.system = "x86_64-linux";
  nixpkgs.config = {
    virtualbox.enableExtensionPack = true;
    pulseaudio = true;
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

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      inconsolata
      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
      ubuntu_font_family
    ];
  };

  security.sudo.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    trustedBinaryCaches = [
      "http://cache.nixos.org"
    ];

    binaryCaches = [
      "http://cache.nixos.org"
    ];

    gc.automatic = false;
    maxJobs = pkgs.stdenv.lib.mkForce 6;
  };
}