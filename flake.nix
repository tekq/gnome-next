{
  description = "GNOME Next: bleeding-edge (51.beta) GNOME package overrides for NixOS, built from source";

  inputs = {
    # Deliberately nixos-unstable, not nixpkgs/master: the unstable *channel*
    # only advances once Hydra has finished building it, so every package we
    # DON'T override (gjs, cairo, libgudev, and whatever it is that drags
    # webkit along for the ride - see overlay.nix) is already sitting on
    # cache.nixos.org instead of needing a from-source rebuild in CI.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        # Every attribute name this flake actually overrides. Kept as a
        # single list so the flake outputs and the CI matrix
        # (.github/workflows/build-gnome-next.yml) can't silently drift
        # apart from what overlay.nix actually touches.
        overriddenPackages = [
          "gsettings-desktop-schemas"
          "gnome-desktop"
          "mutter"
          "gnome-session"
          "gnome-settings-daemon"
          "gnome-backgrounds"
          "gnome-shell"
        ];
      in {
        packages = nixpkgs.lib.genAttrs overriddenPackages (name: pkgs.${name})
          // { default = pkgs.gnome-shell; };

        # `nix flake check` builds the same set CI does.
        checks = self.packages.${system};
      }
    ) // {
      overlays.default = import ./overlay.nix;

      nixosModules = rec {
        gnome-next = import ./modules/gnome-next.nix;
        default = gnome-next;
      };
    };
}
