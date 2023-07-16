{config, pkgs, ...}:

let
  sway-config = ''
    set $mod Mod4
    set $left h
    set $down j
    set $up k
    set $right l
    set $term alacritty
    set $menu fuzzel

    default_border pixel 2

    #output * bg '/home/user/Pictures/background.png' fill
    output * bg #000000 solid_color

    input "1:1:AT_Translated_Set_2_keyboard" {
      xkb_layout local
    }

    bindsym $mod+Return exec $term
    bindsym $mod+Shift+q kill
    bindsym $mod+d exec $menu
    floating_modifier $mod normal
    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'

    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right

    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right

    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10

    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10

    bindsym $mod+b splith
    bindsym $mod+v splitv

    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    bindsym $mod+f fullscreen

    bindsym $mod+Shift+space floating toggle
    bindsym $mod+space focus mode_toggle
    bindsym $mod+a focus parent

    bindsym $mod+Shift+minus move scratchpad
    bindsym $mod+minus scratchpad show

    bindsym XF86MonBrightnessUp exec "brightnessctl s 10%+"
    bindsym XF86MonBrightnessDown exec "brightnessctl s 10%-"
    bindsym XF86AudioLowerVolume exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    bindsym XF86AudioRaiseVolume exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    bindsym XF86AudioMute exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    bindsym XF86Sleep exec "sysmtemctl suspend"

    mode "resize" {
      bindsym $left resize shrink width 10px
      bindsym $down resize grow height 10px
      bindsym $up resize shrink height 10px
      bindsym $right resize grow width 10px

      bindsym Return mode "default"
      bindsym Escape mode "default"
    }
    bindsym $mod+r mode "resize"

    set $bg #2C363C
    set $fg #F0EDEC
    set $br #88507D

    client.focused          $br     $br     $fg     $bg       $br
    client.focused_inactive $bg     $bg     $fg     $bg       $bg
    client.unfocused        $bg     $bg     $fg     $bg       $bg
    client.background $bg

    gaps inner 5
    #gaps outer 5

    #client.focused          $base05 $base0D $base00 $base0D $base0D
    #client.focused_inactive $base01 $base01 $base05 $base03 $base01
    #client.unfocused        $base01 $base00 $base05 $base01 $base01
    #client.urgent           $base08 $base08 $base00 $base08 $base08
    #client.placeholder      $base00 $base00 $base05 $base00 $base00
    #client.background       $base07

    bar {
      position top

      status_command while date +'%Y-%m-%d %I:%M:%S %p'; do sleep 1; done

      colors {
        statusline $fg
        background #000000
        focused_workspace $br #000000 $fg
        active_workspace  #000000 #000000 $fg
        urgent_workspace  #000000 #A8334C $fg
        inactive_workspace #000000 #000000 $fg
      }
    }

    exec "systemctl --user import-environment WAYLAND_DISPLAY"
  '';
in
{
  security.polkit.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
	  enable = true;
    alsa.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      wl-clipboard
      dmenu
      waybar
      brightnessctl
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland-egl
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
  };

  environment.etc."sway/config".source = pkgs.writeText "sway-config" sway-config;
}

/* vim: set et ts=2 sts=2 sw=2: */
