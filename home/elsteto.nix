{pkgs, ...}: {
  home = {
    username = "elsteto";
    homeDirectory = "/home/elsteto";
    stateVersion = "24.11";
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Catppuccin Mocha";
        style = "numbers,changes";
        italic-text = "always";
      };
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = true;
      layout = "tree";
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      previewCommand = "cat {}";
      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      history = {
        path = "$HOME/.cache/zsh/history";
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
      };
      initExtra = ''
        # aliases
        alias ll='eza -la --icons --group-directories-first'
        alias la='eza -la --icons'
        alias l='eza --icons'
        alias ls='eza --icons'
        alias cat='bat'
        alias grep='grep --color=auto'
        alias df='df -h'
        alias free='free -h'
        alias top='btop'
        
        # nix
        alias nrs='sudo nixos-rebuild switch'
        alias nrb='sudo nixos-rebuild boot'
        
        # git
        alias gs='git status'
        alias ga='git add'
        alias gc='git commit'
        alias gp='git push'
        alias gl='git log --oneline --graph --decorate'
        alias gd='git diff'
        
        # navigation
        alias ..='cd ..'
        alias ...='cd ../..'
      '';
      plugins = [
        {
          name = "zsh-nix-shell";
          src = pkgs.zsh-nix-shell;
        }
      ];
    };

    git = {
      enable = true;
      userName = "Elseto";
      userEmail = "faabiioo05@gmail.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = false;
        };
        push = {
          default = "simple";
        };
        core = {
          editor = "vim";
        };
        color = {
          ui = true;
        };
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        package = {
          symbol = "📦 ";
        };
        nix-shell = {
          symbol = "❄ ";
        };
      };
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin-mocha";
      };
    };
  };
}
