{
  description = "GNOME Next: bleeding-edge GNOME package overrides for NixOS, ethically sourced";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };

        overriddenPackages = [
          "gsettings-desktop-schemas"
          "gnome-desktop"
          "mutter"
          "gnome-session"
          "gnome-settings-daemon"
          "gnome-backgrounds"
          "gnome-disk-utility"
          "gnome-shell"
          "nautilus"
          "glib"
          "glibmm"
          "libxmlxx3"
        ];
      in {
        packages =
          nixpkgs.lib.genAttrs overriddenPackages (name: pkgs.${name})
          // {default = pkgs.gnome-shell;};

        checks = self.packages.${system};
      }
    )
    // {
      overlays.default = import ./overlay.nix;

      nixosModules = rec {
        gnome-next = import ./modules/gnome-next.nix;
        default = gnome-next;
      };
    };
}
