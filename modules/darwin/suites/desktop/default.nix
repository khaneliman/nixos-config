{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.suites.desktop;
in
{
  options.khanelinix.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    khanelinix = {
      desktop = {
        addons = {
          wallpapers = enabled;
        };
      };

      apps = {
        _1password = enabled;
        firefox = enabled;
        pocketcasts = enabled;
        vlc = enabled;
      };
    };
  };
}
