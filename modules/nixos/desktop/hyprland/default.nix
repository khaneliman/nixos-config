{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.hyprland;
  hyprBasePath = inputs.dotfiles.outPath + "/dots/linux/hyprland/home/.config/hypr/";
  programs = lib.makeBinPath [config.programs.hyprland.package];
  datadir = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
in {
  options.khanelinix.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
    wallpaper = mkOpt (nullOr package) null "The wallpaper to display.";
    customConfigFiles = mkOpt attrs {} "Custom configuration files that can be used to override the default files.";
    customFiles = mkOpt attrs {} "Custom files that can be used to override the default files.";
  };

  config =
    mkIf cfg.enable
    {
      khanelinix = {
        apps = {
          partitionmanager = enabled;
          gamemode = {
            startscript = ''
              ${pkgs.libnotify}/bin/notify-send 'GameMode started'
              export PATH=$PATH:${programs}
              export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
              hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:no_vfr 1'
            '';

            endscript = ''
              ${pkgs.libnotify}/bin/notify-send 'GameMode stopped'
              export PATH=$PATH:${programs}
              export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
              hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:no_vfr 0'
            '';
          };
        };

        # Desktop additions
        desktop.addons = {
          # eww = enabled;
          gtk = enabled;
          kanshi = enabled;
          keyring = enabled;
          kitty = enabled;
          nautilus = enabled;
          qt = enabled;
          rofi = enabled;
          thunar = enabled;
          xdg-portal = enabled;
        };

        display-managers.gdm = {
          enable = true;
          defaultSession = "hyprland";
        };

        home = {
          configFile = with inputs;
            {
              "hypr/assets/square.png".source = hyprBasePath + "assets/square.png";
              "hypr/assets/diamond.png".source = hyprBasePath + "assets/diamond.png";
              "hypr/binds.conf".source = hyprBasePath + "binds.conf";
              "hypr/environment.conf".text = ''
                # ░█▀█░▀█▀░█░█░█▀█░█▀▀
                # ░█░█░░█░░▄▀▄░█░█░▀▀█
                # ░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀

                env = XDG_DATA_DIRS,${datadir}:$XDG_DATA_DIRS
              '';
              "hypr/hyprland.conf".source = hyprBasePath + "hyprland.conf";
              "hypr/hyprpaper.conf".source = hyprBasePath + "hyprpaper.conf";
              "hypr/variables.conf".source = hyprBasePath + "variables.conf";
              "hypr/windowrules.conf".source = hyprBasePath + "windowrules.conf";
            }
            // cfg.customConfigFiles;

          file = with inputs;
            {
              ".local/bin/hyprland_setup_dual_monitors.sh".source = dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/hyprland_setup_dual_monitors.sh";
              ".local/bin/hyprland_cleanup_after_startup.sh".source = dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/hyprland_cleanup_after_startup.sh";
              ".local/bin/hyprland_handle_monitor_connect.sh".source = dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/hyprland_handle_monitor_connect.sh";
              ".local/bin/record_screen".source = dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/record_screen";
            }
            // cfg.customFiles;
        };

        suites = {
          wlroots = enabled;
        };
      };

      programs.hyprland = {
        enable = true;
      };

      environment.sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        # GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
        WLR_RENDERER = "vulkan";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONEREPARENTING = "1";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
        ASAN_OPTIONS = "log_path=~/asan.log";
        HYPRLAND_LOG_WLR = "1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };

      environment.systemPackages = with pkgs; [
        hyprpaper
        hyprpicker
        inputs.hyprland-contrib.packages.${pkgs.hostPlatform.system}.grimblast
      ];
    };
}
