{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.suites.games;
  apps = {
    steam = enabled;
  };
  cli-apps = { };
in
{
  options.khanelinix.suites.games = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common games configuration.";
  };

  config = mkIf cfg.enable { khanelinix = { inherit apps cli-apps; }; };
}
