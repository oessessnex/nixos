{config, pkgs, utils, ... }:

let
   keymap = pkgs.runCommandLocal "keymap" {} ''
    '${pkgs.ckbcomp}/bin/ckbcomp' \
    '-I${config.environment.sessionVariables.XKB_CONFIG_EXTRA_PATH}' \
    -layout local > "$out"
   '';

in
with (import ./secrets/variables.nix);
{
  imports =
    [
      <home-manager/nixos>
      ./secrets/wireless-networks.nix
      ./window-manager.nix
      ./persist.nix
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e09809442";

  time.timeZone = "Europe/Ljubljana";

  networking.hostName = "nixos";
  networking.wireless.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      wl-clipboard
      dmenu
    ];
  };

  environment.etc = {
    "sway/config".source = pkgs.writeText "sway-config" (import ./sway.nix);
  };

  networking.useDHCP = false;
  networking.interfaces.enp14s0.useDHCP = true;
  networking.interfaces.wlp13s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    XKB_CONFIG_EXTRA_PATH = "${./xkb}";
    EDITOR = "nvim";
  };

  console.keyMap = keymap;

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.etc."machine-id".source = "/persist/etc/machine-id";

  fileSystems."/" = {
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/persist" = {
    neededForBoot = true;
  };

  local.persist = {
    enable = true;

    directories = [
      "/home/${user}/.mozilla"
      "/home/${user}/Documents"
      "/home/${user}/Downloads"
      "/home/${user}/Development"
      "/home/${user}/Music"
      "/home/${user}/Pictures"
      "/home/${user}/Public"
      "/home/${user}/Templates"
      "/home/${user}/Videos"
    ];
    files = [
      "/home/${user}/.bash_history"
    ];
  };

  users.mutableUsers = false;
  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "default";
  };
  home-manager.users."${user}" = {

  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
  # ];

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
