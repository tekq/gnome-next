{
  description = "GNOME Next";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS/nixpkgs#559510
    nixpkgs-gnome.url = "github:theCapypara/nixpkgs/gnome51";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-gnome,
    flake-utils,
  }: let
    inherit (nixpkgs) lib;

    overriddenPackages = [
      "gsettings-desktop-schemas"
      "gnome-desktop"
      "mutter"
      "gnome-session"
      "gnome-settings-daemon"
      "gnome-backgrounds"
      "gnome-disk-utility"
      "gnome-shell"
      "gdm"
      "gnome-control-center"
      "nautilus"
    ];

    gnomePrOverlay = final: prev: let
      prPkgs = nixpkgs-gnome.legacyPackages.${prev.stdenv.hostPlatform.system};
    in
      {inherit (prPkgs) gnome;}
      // lib.genAttrs overriddenPackages (name: prPkgs.${name});

    extraOverlay = import ./overlay.nix;
  in
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
      in {
        packages =
          lib.genAttrs overriddenPackages (name: pkgs.${name})
          // {default = pkgs.gnome-shell;};

        checks = self.packages.${system};
      }
    )
    // {
      overlays = {
        gnome-pr = gnomePrOverlay;
        default = lib.composeManyExtensions [gnomePrOverlay extraOverlay];
      };

      nixosModules = rec {
        gnome-next = import ./modules/gnome-next.nix self;
        default = gnome-next;
      };
    };
}
