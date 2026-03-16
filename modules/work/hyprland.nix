{inputs, pkgs, ...}: {
  services = {
    xserver = {
      displayManager = {
        gdm.enable = false;
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };
      desktopManager = {
        hyprland.enable = true;
        xterm.enable = false;
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    hyprland
    alacritty
    rofi-wayland
    rofi-theme-icons
    wofi
    waybar
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    brightnessctl
    playerctl
    networkmanagerapplet
    pamixer
    blueman
    thunar
    thunar-archive-plugin
    thunar-volman
    ffmpegthumbnailer
    libgsf
    dconf-editor
    lxappearance
    qt5ct
    kvantum
    xdotool
    wtype
  ];

  home-manager.users.elsteto = {pkgs, ...}: {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          env = {TERM = "xterm-256color";};
          window = {
            opacity = 0.95;
            padding = {x = 10; y = 10;};
            dynamic_padding = true;
          };
          font = {
            size = 11;
            normal = {family = "JetBrainsMono Nerd Font";};
          };
          colors = {
            primary = {
              background = "#0f0f14";
              foreground = "#cdd6f4";
              dim_foreground = "#7f849c";
              bright_foreground = "#cdd6f4";
            };
            cursor = {
              text = "#0f0f14";
              cursor = "#f5e0dc";
            };
            selection = {
              text = "#f5e0dc";
              background = "#9399b2";
            };
            normal = {
              black = "#45475a";
              red = "#f38ba8";
              green = "#a6e3a1";
              yellow = "#f9e2af";
              blue = "#89b4fa";
              magenta = "#f5c2e7";
              cyan = "#94e2d5";
              white = "#bac2de";
            };
            bright = {
              black = "#585b70";
              red = "#f38ba8";
              green = "#a6e3a1";
              yellow = "#f9e2af";
              blue = "#89b4fa";
              magenta = "#f5c2e7";
              cyan = "#94e2d5";
              white = "#a6adc8";
            };
          };
          scrolling = {history = 10000;};
          cursor = {
            style = {"Blocky" = true;};
            no_blinking = true;
          };
        };
      };

      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 34;
            spacing = 4;
            modules-left = ["hyprland/workspaces" "hyprland/window"];
            modules-center = ["clock"];
            modules-right = ["pulseaudio" "network" "battery" "tray" "idle_inhibitor"];
            clock = {
              format = "󰥔 {:%H:%M}";
              format-alt = "󰥔 {:%a, %b %d}";
              format-tooltip = "{:%H:%M}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{:%H:%M:%S}</small></tt>";
              interval = 1;
              time = 1;
              calendar = {
                mode = "month";
                mode-mon = true;
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  months = "<span color='#89b4fa'><b>{}</b></span>";
                  days = "<span color='#cdd6f4'><b>{}</b></span>";
                  weeks = "<span color='#a6e3a1'><b>W{}</b></span>";
                  weekdays = "<span color='#f9e2af'><b>{}</b></span>";
                  today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-left = "shift";
                on-click-right = "mode";
                on-scroll-up = "shift";
                on-scroll-down = "shift";
              };
            };
            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = " {icon} {capacity}%";
              format-charging = " 󰂄 {capacity}%";
              format-plugged = " 󰂄 {capacity}%";
              format-alt = "{icon} {time}";
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };
            network = {
              format-wifi = "󰤨 {signalStrength}%";
              format-ethernet = "󰈀";
              format-disconnected = "󰤭";
              format-alt = "{ifname}: {ipaddr}";
              interval = 5;
              tooltip-format = "{ifname}: {ipaddr}\n{gwaddr}";
            };
            pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "{icon} {volume}%";
              format-bluetooth-muted = "󰝟";
              format-muted = "󰝟";
              format-source = "󰿭 {volume}%";
              format-source-muted = "󰝟";
              format-icons = {
                default = ["󰕿" "󰖀" "󰕾"];
                bluetooth = ["󰌝" "󰌝" "󰌝"];
              };
              on-click = "pavucontrol";
              on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              tooltip-format = "{desc}, {volume}%";
            };
            tray = {
              spacing = 10;
              icon-size = 16;
            };
            idle_inhibitor = {
              format = "{icon}";
              format-active = "延迟";
              format-inactive = "󰦮";
              icons = {
                activated = "󰍾";
                deactivated = "󰍽";
              };
            };
            hyprland/workspaces = {
              disable-scroll = false;
              persistent-workspaces = {
                "*" = 5;
              };
              format = "{icon}";
              format-icons = {
                "1" = "一";
                "2" = "二";
                "3" = "三";
                "4" = "四";
                "5" = "五";
                "6" = "六";
                "7" = "七";
                "8" = "八";
                "9" = "九";
                "10" = "十";
              };
              tooltip-format = "{windows}: {class}";
            };
            hyprland/window = {
              format = "{title}";
              format-max-length = 50;
              separate-outputs = true;
              tooltip-format = "{class}: {title}";
            };
          };
        };
        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 13px;
            min-height: 0;
          }
          window#waybar {
            background: rgba(15, 15, 20, 0.95);
            color: #cdd6f4;
            transition-property: background-color;
            transition-duration: .5s;
          }
          button {
            box-shadow: inset 0 -3px transparent;
            border: none;
            border-radius: 0;
          }
          button:hover {
            background: inherit;
            box-shadow: inset 0 -3px #89b4fa;
          }
          #workspaces button {
            padding: 0 5px;
            color: #cdd6f4;
          }
          #workspaces button.active {
            background: #89b4fa;
            color: #0f0f14;
          }
          #workspaces button.urgent {
            background: #f38ba8;
            color: #0f0f14;
          }
          #clock, #battery, #network, #pulseaudio, #tray, #mode, #idle_inhibitor {
            padding: 0 15px;
            color: #cdd6f4;
          }
          #window, #workspaces {
            padding: 0 10px;
          }
          #workspaces {
            background: rgba(15, 15, 20, 0.95);
          }
          #battery.charging {
            color: #a6e3a1;
            text-shadow: 0 0 5px #a6e3a1;
          }
          #battery.warning:not(.charging) {
            background: #f9e2af;
            color: #0f0f14;
            text-shadow: 0 0 5px #f9e2af;
          }
          #battery.critical:not(.charging) {
            background: #f38ba8;
            color: #0f0f14;
            text-shadow: 0 0 5px #f38ba8;
            animation: blink 0.5s linear infinite alternate;
          }
          @keyframes blink {
            to { background-color: #f38ba8; color: #0f0f14; }
          }
          #network.disconnected {
            color: #f38ba8;
          }
          #pulseaudio.muted {
            color: #7f849c;
          }
          #tray {
            background: rgba(15, 15, 20, 0.95);
          }
          #tray > .passive {
            -gtk-icon-effect: dim;
          }
          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #f38ba8;
          }
          #idle_inhibitor.activated {
            color: #89b4fa;
          }
        '';
      };

      wofi = {
        enable = true;
        settings = {
          width = 500;
          height = 400;
          show = "drun";
          prompt = "Search...";
          allow_images = true;
          image_size = 32;
        };
        style = ''
          window {
            background-color: rgba(15, 15, 20, 0.95);
            border: 1px solid rgba(137, 180, 250, 0.3);
            border-radius: 12px;
          }
          #input {
            background-color: #1e1e2e;
            border: none;
            border-bottom: 2px solid #89b4fa;
            color: #cdd6f4;
            padding: 12px;
            margin: 8px;
            border-radius: 8px;
            font-size: 14px;
          }
          #input:focus {
            border-bottom: 2px solid #cba6f7;
          }
          #entry:selected {
            background-color: #89b4fa;
            color: #0f0f14;
          }
          #text {
            color: #cdd6f4;
          }
          #text:selected {
            color: #0f0f14;
          }
        '';
      };

      firefox = {
        enable = true;
        package = pkgs.firefox;
        settings = {
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "https://github.com";
        };
      };

      thunar = {
        enable = true;
        settings = {
          ThunarDetailsView::date-format = "%Y-%m-%d %H:%M";
          ThunarIconView::item-spacing = 6;
          ThunarIconView::thumbnail-size = 48;
          ThunarWindow::last-view = "ThunarIconView";
          ThunarWindow::last-width = 896;
          ThunarWindow::last-height = 612;
          ThunarShortcutsView::icon-size = 16;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        "$menu" = "wofi --show drun";
        "$browser" = "firefox";
        "$fileManager" = "thunar";

        monitor = ",preferred,auto,1";

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(89b4faee) rgba(f5c2e7ee) 45deg";
          "col.inactive_border" = "rgba(45475aaa)";
          layout = "dwind";
          resize_on_border = true;
        };

        decoration = {
          rounding = 8;
          active_opacity = 1.0;
          inactive_opacity = 0.95;
          fullscreen_opacity = 1.0;
          drop_shadow = true;
          shadow_range = 15;
          shadow_render_power = 3;
          shadow_offset = "0 5";
          col.shadow = "rgba(1a1a2eee)";
          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            new_optimizations = true;
            xray = false;
            noise = 0.0117;
            contrast = 0.8916;
            brightness = 0.0;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier,0.05,0.9,0.1,1.05";
          animation = [
            "windows,1,7,myBezier"
            "windowsOut,1,7,default,popin 75%"
            "fade,1,7,myBezier"
            "workspaces,1,6,default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          no_gaps_when_only = false;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
          };
        };

        Gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, $menu"
          "$mod, B, exec, $browser"
          "$mod, E, exec, $fileManager"
          "$mod, F, fullscreen"
          "$mod, Space, togglefloating"
          "$mod, P, pseudo"
          "$mod, J, togglesplit"
          ", print, exec, grim -g \"$(slurp)\" - | wl-copy"
          "SHIFT, print, exec, grim - | wl-copy"
          "$mod, L, exec, swaylock -f"
          "$mod, Q, killactive"
          "$mod, M, exit"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];

        bindl = [
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        windowrulev2 = [
          "float,class:^(pavucontrol)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(blueman-manager)$"
          "float,class:^(yad)$"
          "float,title:^(Open File)$"
          "float,title:^(Save File)$"
          "float,title:^(Picture-in-Picture)$"
          "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
          "float,class:^(Rofi)$"
          "float,class:^(io.github.alexhagen.fwh)$"
        ];
      };

      extraConfig = ''
        # Autostart
        exec-once = waybar
        exec-once = wl-paste --type text --watch cliphist store
        exec-once = wl-paste --type image --watch cliphist store
        exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        # Idle
        exec-once = swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
      '';
    };
  };
}
