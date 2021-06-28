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

  environment.systemPackages = [
 ];

  system.stateVersion = 4;

  environment.variables = {
    NIX_REMOTE = "daemon";
    TMUXP_CONFIGDIR = "$HOME/.tmuxp";
    WEZTERM_CONFIG_FILE = "$HOME/.config/wezterm/config.lua";
  };

  # shell config
  environment.shells = [ "/run/current-system/sw/bin/zsh" ];

  environment.shellAliases.start = "sh ~/.tmuxp/start.sh";

  environment.interactiveShellInit = ''
            eval "$(direnv hook zsh)"
          '';

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [ nerdfonts ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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
    trustedBinaryCaches = [ "https://cache.nixos.org" ];
    buildCores = 0;
    gc.automatic = true;
    gc.user = "hugosum";
    useSandbox = true;
    sandboxPaths = [ "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];
  };

}
