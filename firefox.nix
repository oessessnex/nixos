{pkgs, ...}:

let
ff = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
  extraPolicies = {
    CaptivePortal = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFirefoxAccounts = true;
    FirefoxHome = {
      Pocket = false;
      Snippets = false;
    };
  };
};
in
{
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  environment.systemPackages = [ff];
}
/* vim: set et ts=2 sts=2 sw=2: */

