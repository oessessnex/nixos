{config, pkgs, ...}:

let
  keymap = pkgs.runCommandLocal "keymap" {} ''
   '${pkgs.ckbcomp}/bin/ckbcomp' \
   '-I${config.environment.sessionVariables.XKB_CONFIG_EXTRA_PATH}' \
   -layout local > "$out"
  '';
in
{
  environment.sessionVariables.XKB_CONFIG_EXTRA_PATH = "${./xkb}";
  console.keyMap = keymap;
}
