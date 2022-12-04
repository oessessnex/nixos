{config, pkgs, ...}:

{
  users.mutableUsers = false;

  users.users.user = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      neovim
    ];
    passwordFile = "/nix/secrets/passwd";
  };

  environment.persistence."/persist" = {
    users.user = {
      directories = [
        "Documents"
        "Downloads"
        "Development"
        "Music"
        "Pictures"
        "Public"
        "Templates"
        "Videos"
        ".mozilla"
        ".config/nvim"
      ];

      files = [
        ".bash_history"
      ];
    };
  };
}

/* vim: set et ts=2 sts=2 sw=2: */
