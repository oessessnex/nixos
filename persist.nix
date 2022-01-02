{config, pkgs, lib, utils, ... }:

with lib;
let
  cfg = config.local.persist;

  ensure = target:
    let escaped = utils.escapeSystemdPath target; in
    {
      name = "${escaped}";
      value = {
        description = "Ensure ${target} exists before mounting.";
        serviceConfig.Type = "oneshot";
        before = ["${escaped}.mount"];
        wantedBy = ["multi-user.target"];

        script = ''
          touch '${target}'
        '';
      };
    };

  bind = target: {
    description = "Bind mount ${target}.";
    what = "/persist/${target}";
    where = "${target}";
    options = "bind";
    wantedBy = ["multi-user.target"];
  };
in
{
  options.local.persist = {
    enable = mkEnableOption "persist";
    directories = mkOption {
      type = with types; listOf string;
      default = [];
    };
    files = mkOption {
      type = with types; listOf string;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    systemd.services = listToAttrs (map ensure cfg.files);
    systemd.mounts = map bind (cfg.directories ++ cfg.files);
  };
}
