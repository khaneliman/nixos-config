{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.suites.common;
in
{
  options.khanelinix.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    khanelinix = {
      nix = enabled;

      cli-apps = {
        btop = enabled;
        fastfetch = enabled;
        feh = enabled;
        flake = enabled;
        glow = enabled;
        ranger = enabled;
      };

      tools = {
        atool = enabled;
        bat = enabled;
        bottom = enabled;
        comma = enabled;
        direnv = enabled;
        exa = enabled;
        fup-repl = enabled;
        git = enabled;
        lsd = enabled;
        misc = enabled;
        nix-ld = enabled;
        oh-my-posh = enabled;
        socat = enabled;
        spicetify-cli = enabled;
        toilet = enabled;
        topgrade = enabled;
        xclip = enabled;
      };

      hardware = {
        storage = enabled;
      };

      services = {
        nix-daemon = enabled;
      };

      security = {
        gpg = enabled;
      };

      system = {
        fonts = enabled;
      };
    };
  };
}
