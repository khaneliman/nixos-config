{ pkgs
, lib
, ...
}:
with lib;
with lib.internal; {

  khanelinix = {
    nix = enabled;

    suites = {
      common = enabled;
      development = enabled;
    };

    services = {
      nix-daemon = enabled;
    };
  };

  system.stateVersion = "4";
}
