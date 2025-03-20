{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/d06cf700ee589527fde4bd9b91f899e7137c05a6";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix/monthly";
    templFlake.url = "github:a-h/templ";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, nix-homebrew, fenix, templFlake }:
    let
      configuration = { pkgs, config, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget

        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          fenix.overlays.default
          templFlake.overlays.default
        ];
        environment.systemPackages =
          with pkgs; [
            (fenix.packages.${system}.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
            ])
            neovim
            obsidian
            alacritty
            mkalias
            ripgrep
            go
            rust-analyzer-nightly
            tmux
            fzf
            bat
            pnpm
            bun
            neofetch
            btop
            lazydocker
            lazygit
            python312
            docker
            httpie
            minikube
            sqlc
            goose
            eza
            poetry
            templ
            air
            dotnet-sdk_8
            direnv
            argocd
            jetbrains.idea-community
            gradle
            protoc-gen-go
            protoc-gen-go-grpc
            protobuf
            grpcurl
            postman
            wire
            zip
            usql
            zoom-us
            flyctl
            railway
            oapi-codegen
            lua
            exercism
            google-chrome
            poetry
            ffmpeg
            act
            tmux-sessionizer
            redis
            yazi
            chafa
            bacon
            sqlx-cli
            badger
            less
            gnupg
            b2sum
          ];
        fonts.packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          nerd-fonts.iosevka
          pretendard
        ];

        homebrew = {
          enable = true;
          taps = [ "cerbos/tap" "nikitabobko/tap" ];
          brews = [
            "mas"
            "deno"
            "cerbos"
            "libomp"
            "llvm"
            "node"
          ];
          casks = [
            "arc"
            "slack"
            "figma"
            "orbstack"
            "discord"
            "notion"
            "aerospace"
            "unity-hub"
            "microsoft-word"
            "postico"
            "termius"
            "microsoft-teams"
            "zed"
            "ghostty"
            "love"
            "firefox"
            "tiled"
            "musescore"
            "zen-browser"
            "windsurf"
            "balenaetcher"
          ];
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
          masApps = {
            "bear" = 1091189122;
            "kakaotalk" = 869223134;
            "logic pro" = 634148309;
          };
        };
        system.activationScripts.applications.text =
          let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            };
          in
          pkgs.lib.mkForce ''
                    echo "setting up /Applications..." >&2
            	rm -rf /Applications/Nix\ Apps
            	mkdir -p /Applications/Nix\ Apps
            	find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            	while read -r src; do
            	 app_name=$(basename "$src")
            	 echo "copying $src" >&2
            	 ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            	done
            	'';
        system.defaults = {
          dock.autohide = true;
          dock.persistent-apps = [
            "/Applications/Ghostty.app"
            "/Applications/Zen Browser.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
          ];
          dock.show-recents = false;

          finder.FXPreferredViewStyle = "clmv";
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.KeyRepeat = 2;
          CustomUserPreferences = {
            "com.apple.screencapture" = {
              location = "~/Documents/Capture";
              type = "png";
            };
          };
        };

        launchd.agents.rectangle.serviceConfig.KeepAlive = true;
        # Auto upgrade nix package and the daemon service.
        # services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "x86_64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "leesungjin";
            };
          }
          {
            users.users.leesungjin = {
              home = "/Users/leesungjin";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.leesungjin = import ./home.nix;
          }
        ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."macbook".pkgs;
    };
}
