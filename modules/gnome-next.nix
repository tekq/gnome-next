{
  config,
  lib,
  ...
}: let
  cfg = config.gnome-next;
in {
  options.gnome-next = {
    enable = lib.mkEnableOption "GNOME Next (51.beta) package overrides";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [(import ../overlay.nix)];
  };
}
