{config, pkgs, ...}:

let 
  alacritty-config = ''
    window:
      padding:
        x: 5
        y: 5

    colors:
      primary:
        foreground: '#2C363C'
        background: '#F0EDEC'
      cursor:
        cursor: '#2C363C'
        text: '#F0EDEC'
      normal:
        black:   '#F0EDEC'
        red:     '#A8334C'
        green:   '#4F6C31'
        yellow:  '#944927'
        blue:    '#286486'
        magenta: '#88507D'
        cyan:    '#3B8992'
        white:   '#2C363C'
      bright:
        black:   '#CFC1BA'
        red:     '#94253E'
        green:   '#3F5A22'
        yellow:  '#803D1C'
        blue:    '#1D5573'
        magenta: '#7B3B70'
        cyan:    '#2B747C'
        white:   '#4F5E68'
    '';
in
{
  environment.etc = {
    "xdg/alacritty/alacritty.yml".source = pkgs.writeText "alacirtty-config" alacritty-config;
  };
}

