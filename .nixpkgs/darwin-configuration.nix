{ config, pkgs, ... }:

{

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  environment.systemPackages = with pkgs; [
    # Essential
    zoxide
    htop
    ripgrep
    exa
    neovim
    git
    tmux
    tmuxp
    # Isolated dev environment
    lorri
    direnv
    # Linter and LSP
    # Go packages to be built

    (buildGoModule rec {
      pname = "sqls";
      version = "0.2.18";
      src = fetchFromGitHub {
        owner = "lighttiger2505";
        repo = "sqls";
        rev = "v${version}";
        sha256 = "13837v27avdp2nls3vyy7ml12nj7rxragchwf92adn10ffp4aj6c";
      };
      vendorSha256 = "1rrnvvpx07q49kshib413b5y5l3icb3na4vmccb4arf5awck14db";
    })

    (buildGoModule rec {
      pname = "dockfmt";
      version = "0.3.4";
      src = fetchFromGitHub {
        owner = "jessfraz";
        repo = "dockfmt";
        rev = "1455059b8bb53ab4723ef41946c43160583a8333";
        sha256 = "1y3abi1bxn0lfcwjd761lfkjw5algyy2vvmy66z7n4sw8f8bsh60";
      };
      vendorSha256 = null;
    })

    (buildGoModule rec {
      pname = "efm-langserver";
      version = "0.0.31";
      src = fetchFromGitHub {
        owner = "mattn";
        repo = "efm-langserver";
        rev = "v${version}";
        sha256 = "183vm65wb7byijy9i9ng48ky4ajk9czlz5zsfk4sg5igdkwl7mz0";
      };
      vendorSha256 = "1whifjmdl72kkcb22h9b1zadsrc80prrjiyvyba2n5vb4kavximm";
    })

    (buildGoModule rec {
      pname = "sqlfmt";
      version = "0.1.0";
      src = fetchFromGitHub {
        owner = "kanmu";
        repo = "go-sqlfmt";
        rev = "d1e63e2ee5eb36cbbc28c9d9471ab05786b5dae7";
        sha256 = "183vm65wb7byijy9i9ng48ky4ajk9czlz5zsfk4sg5igdkwl7mz0";
      };
      vendorSha256 = "1whifjmdl72kkcb22h9b1zadsrc80prrjiyvyba2n5vb4kavximm";
    })
    # metals
    # ktlint
    # cmake-language-server
    rust-analyzer
    # checkmake
    nixfmt
    gopls
    golint
    goimports
    # hadolint
    # shellcheck
    rnix-lsp
    ccls
    haskell-language-server
    # python39Packages.black
    # python39Packages.flake8
    # python39Packages.yamllint
    # cpplint
    stylua
    rustfmt
    clippy
    beamPackages.elixir_ls
    nodePackages.eslint_d
    nodePackages.purescript-language-server
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.yaml-language-server
    nodePackages.vls
    nodePackages.vim-language-server
    nodePackages.typescript-language-server
    # nodePackages.pyright
    nodePackages.svelte-language-server
    nodePackages.purty
    nodePackages.prettier
    haskellPackages.hindent
    haskellPackages.dhall-lsp-server
  ];

  # programs.fish = {
  # enable = true;
  # };

  system.stateVersion = 4;

  environment.variables = {
    NIX_REMOTE = "daemon";
    TMUXP_CONFIGDIR = "$HOME/.tmuxp";
    WEZTERM_CONFIG_FILE = "$HOME/.config/wezterm/config.lua";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # shell config
  environment.shells = [ "/run/current-system/sw/bin/zsh" ];

  environment.shellAliases = {
    start = "sh ~/.tmuxp/start.sh";
    top = "htop";
    ls = "exa --icons";
    vi = "nvim";
    vim = "nvim";
    dotfiles = "$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
  };

  environment.interactiveShellInit = ''
    eval "$(direnv hook zsh)"
  '';

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [ nerdfonts ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # services.lorri = {
  # enable = true;
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    # promptInit = "prompt off";
    promptInit = "";
  };

  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    finder = {
      QuitMenuItem = true;
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };
    trackpad = {
      ActuationStrength = 1;
      Clicking = false;
      TrackpadThreeFingerDrag = false;
    };
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  nix = {
    useDaemon = true;
    binaryCaches = [ "https://cache.nixos.org" ];
    trustedBinaryCaches = [ "http://cache.nixos.org" "http://hydra.nixos.org" ];
    buildCores = 0;
    gc.automatic = true;
    gc.user = "hugosum";
    # useSandbox = true;
    # sandboxPaths = [ "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];
  };

}
