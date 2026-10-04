let
  gnomeVersion = "51.0";
in
# final: prev: {
#   gnome-shell = prev.gnome-shell.overrideAttrs (old: {

#       patches = old.patches ++ [
# (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/233c760cfe7b557f1cb351316d229de586fd2b9f.patch";
#           hash = "sha256-uOrntaCOoHcka4EIE0D2wffAq1eSoiPlJ3rv1eP7sCc=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/4c2b2978c8aeb17989bc5f17a7dfe88f1a2da0e0.patch";
#           hash = "sha256-gYqnsUf7jAPANTgs3l4Zs5pt7mdXsblGMfUCMMIwfmc=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/648ffa0894b6ef15e49e4626d24f64b1166093be.patch";
#           hash = "sha256-gI8pGfLpkYzP3ymFG06+4VGBviDUIN8HJfNC+mEtgg4=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/c163b25ec11e066cccf13173b7640becb3c9000a.patch";
#           hash = "sha256-z4VO9l8id2m0+viFySnS/42vzpV1tMBHpSZsH0MF9A0=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/3aaffc26cb3382707c9d2d1e82af3cc13958e126.patch";
#           hash = "sha256-LS//6ocgolMO+GweWtdd87OFy2UBSMa9HX0XU2uU7KA=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/71dc1a36afc8f377db5b753358f9d7ce6f461e26.patch";
#           hash = "sha256-aGg0dISwf/5ZRS93eoJhSE8/2mnCqo6eAxixxYSEJbA=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/b22f754b6a7f879e2982cf1a049c1f1909404f11.patch";
#           hash = "sha256-bGTeqEpyeyFtTVYwPkC6LxtVwd4rt0FK+f3VlSMdQHA=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/a8eb665f9dbb575ebb640fc7d6a61c0d83701eca.patch";
#           hash = "sha256-eHgSa+SLv+fZsm6kVjHsRuTnt0gj/VeCS4+UNDxPUR4=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/e20768205d111dae0dc4f8805c8e4f1a94b7ba13.patch";
#           hash = "sha256-4SgupXetnJBU4V9wRRk87HHTmpos6MENTLHGcSVLpoU=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/5fd7ca22a7a77ab4d630e39cd206e8b96a4080a5.patch";
#           hash = "sha256-zVQLX6gtWUJxGtLUve9HMtOeriGTkVjf58bCzrd1Lic=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/db710eff6d2679e5fffa75db812b0c2804b970e4.patch";
#           hash = "sha256-pYEIE1EFiNJKnRboVe/bDLzuyBb6EnkM9TozMqbbXUs=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/88ab6a9d3f204214c13c781a29d39b33eda95238.patch";
#           hash = "sha256-sm3dWJ5/zFx3Ha8z7B6xXOTtP1Xm5eSJOI2hn9e6Lq0=";
#         })

#         (final.fetchpatch {
#           url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/cf90e2eb4e35426aff103caaae9b50504fec1bfd.patch";
#           hash = "sha256-Uq7yfTBU7QsP3xOWD1X7i5A687ewfeNPIPI4jcW+PHs=";
#         })
#       ];
#     });
  }
