{config, pkgs, ...}:

{
  users.mutableUsers = false;

  users.users.user = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      neovim
      fuzzel
      lua-language-server
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
        "Self"
        ".mozilla"
	".opam"
        ".config/nvim"
        ".config/fuzzel"
        ".local/share/Steam"
        ".ssh"
      ];

      files = [
        ".bash_history"
      ];
    };
  };
}

/* vim: set et ts=2 sts=2 sw=2: */
