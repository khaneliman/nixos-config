{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.nix;
in {
  options.khanelinix.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nixUnstable "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      khanelinix.nixos-revision
      deploy-rs
      alejandra
      nix-index
      nix-prefetch-git
      cachix
    ];

    nix = let
      users = ["root" config.khanelinix.user.name];
    in {
      inherit (cfg) package;

      settings =
        {
          experimental-features = "nix-command flakes";
          http-connections = 50;
          warn-dirty = false;
          log-lines = 50;
          sandbox = "relaxed";
          auto-optimise-store = true;
          trusted-users = users;
          allowed-users = users;
        }
        // (lib.optionalAttrs config.khanelinix.tools.direnv.enable {
          keep-outputs = true;
          keep-derivations = true;
        });

      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
