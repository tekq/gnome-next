self: {
  config,
  lib,
  ...
}: let
  cfg = config.gnome-next;
in {
  options.gnome-next = {
    enable = lib.mkEnableOption "GNOME Next";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = lib.mkBefore [self.overlays.default];
  };
}
