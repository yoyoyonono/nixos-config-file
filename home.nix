{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yoyo";
  home.homeDirectory = "/home/yoyo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    aerc
    android-studio
    android-tools
    audacity
    cargo-flamegraph
    corrscope
    dig
    dopewars
    ente-auth
    evcxr
    ffmpeg
    firefox-bin
    flutter
    furnace
    fzf
    ghostty
    gitkraken
    google-chrome
    hyfetch
    hyperfine
    itch
    kdePackages.kasts
    kdePackages.kmines
    kdePackages.kpat
    kdePackages.krdc
    kicad
    krita
    libreoffice-qt6
    mangohud
    nicotine-plus
    nix-search-cli
    octaveFull
    osu-lazer-bin
    parsec-bin
    python3
    qbittorrent
    qpwgraph
    ryubing
    steam
    stremio
    thunderbird
    traceroute
    transgui
    usbutils
    vesktop
    wechat-uos
    weechat
    winbox
    yt-dlp
    zsh
    zsh-powerlevel10k
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".vim_runtime/" = {
      source =  builtins.fetchGit {
        url = "https://github.com/amix/vimrc";
        rev = "46294d589d15d2e7308cf76c58f2df49bbec31e8";
      };
      recursive = true;
    };

    ".config/ghostty/config".source = dotfiles/ghostty/config;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yoyo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    NIXOS_OZONE_WL = "1";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "romkatv/powerlevel10k";
          tags = [as:theme depth:1];
        }
      ];
    };
    initContent = lib.mkOrder 550 ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      eval "$(zoxide init zsh)"
      eval "$(direnv hook zsh)"
    '';
    shellAliases = {
      corrscope = "corr";
    };
  };
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      waveform
      obs-multi-rtmp
    ];
  };

  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
      joystick
    ]);

  };
  
  programs.vim = {
    enable = true;
    extraConfig = ''
    " for amix/vimrc
    set runtimepath+=~/.vim_runtime

    source ~/.vim_runtime/vimrcs/basic.vim
    source ~/.vim_runtime/vimrcs/filetypes.vim
    source ~/.vim_runtime/vimrcs/plugins_config.vim
    source ~/.vim_runtime/vimrcs/extended.vim

    " actual config

    set noswapfile
    set number
    set textwidth=0
    '';
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
      };
    };
  };

}
