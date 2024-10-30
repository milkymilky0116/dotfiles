{ config, pkgs, ... }:

{
  # home = "/Users/leesungjin";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.hello
    pkgs.oh-my-posh
    pkgs.kitty-themes
  ];

  home.file = { };

  home.sessionVariables = { };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 24;
    };
    themeFile = "Dracula";
    extraConfig = ''
      background_opacity 0.9
      window_padding_width 4
    '';
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
    };
    shellAliases = {
      fpn = "nvim $(fzf --preview='bat --color=always {}')";
    };
    initExtra = ''
      eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"
      if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
        eval "$(oh-my-posh init zsh)"
      fi
    '';
  };
  programs.oh-my-posh.enable = true;
  programs.git = {
    enable = true;
    userName = "milkymilky0116";
    userEmail = "sjlee990129@gmail.com";
  };
  programs.btop =
    {
      enable = true;
      settings = {
        color_theme = "TTY";
        vim_keys = true;
      };
    };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
