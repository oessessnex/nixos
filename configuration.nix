{config, pkgs, utils, lib, ... }:

{
  imports =
    [
      ./user.nix
      ./sway.nix
      ./alacritty.nix
      ./keyboard.nix
      ./firefox.nix
      ./hardware-configuration.nix
    ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e09809442";

  fonts.fonts = with pkgs; [
    lmodern
    (nerdfonts.override { fonts = ["DroidSansMono"]; })
  ];

  time.timeZone = "Europe/Ljubljana";

  networking.hostName = "nixos";

  networking.useDHCP = false;
  networking.interfaces.enp14s0.useDHCP = true;
  networking.interfaces.wlp13s0.useDHCP = true;

  networking.wireless.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
      "/etc/wpa_supplicant.conf"
    ];
  };

  environment.systemPackages = with pkgs; [];

  fileSystems."/" = {
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/persist" = {
    neededForBoot = true;
  };

  services.printing.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-run"
    "steam-original"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "21.11";
}

/* vim: set et ts=2 sts=2 sw=2: */
