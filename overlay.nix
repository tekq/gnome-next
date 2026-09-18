let
  gnomeVersion = "51.0";
in
  final: prev: let
    glib_2_90 = prev.glib.overrideAttrs (old: {
      version = "2.90.0";
      src = final.fetchurl {
        url = "mirror://gnome/sources/glib/2.90/glib-2.90.0.tar.xz";
        hash = "sha256-F9FcrCr4CjMnESdAjgq8J0jrKXxZXComQJ6B4U59G48=";
      };
    });

    pango_1_58 = prev.pango.overrideAttrs (old: {
      version = "1.58.2";
      src = final.fetchurl {
        url = "mirror://gnome/sources/pango/1.58/pango-1.58.2.tar.xz";
        hash = "sha256-NCOFtso7fHNFXXyAoTt9vkSJ4AvDvUxb1u1NzkIeN0o=";
      };
    });

    gtk_4_24 = (prev.gtk4.override {
    }).overrideAttrs (old: {
      version = "4.24.0";
      src = final.fetchurl {
        url = "mirror://gnome/sources/gtk/4.24/gtk-4.24.0.tar.xz";
        hash = "sha256-KLpKwcBPhurAm3mhY8sWOkwrVEQtn37MwEZ5BipYEEQ=";
      };
      buildInputs = [glib_2_90 pango_1_58 final.cmake] ++ old.buildInputs;
      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev] ++ old.nativeBuildInputs;

      patches = []; # drop VK patch

      postInstall = builtins.replaceStrings [
        ''
          # TODO: patch glib directly
          for f in $dev/bin/gtk4-encode-symbolic-svg; do
            wrapProgram $f --prefix XDG_DATA_DIRS : "${final.shared-mime-info}/share"
          done
        ''
      ] [ "" ] old.postInstall;
    });
  in {
    gsettings-desktop-schemas = prev.gsettings-desktop-schemas.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gsettings-desktop-schemas/51/gsettings-desktop-schemas-${gnomeVersion}.tar.xz";
        hash = "sha256-HiQZpfIdJsMksorhwA4p6Rdei1lv/zhaBMIXKzZlIiY=";
      };
    });

    gnome-desktop = prev.gnome-desktop.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-desktop/51/gnome-desktop-${gnomeVersion}.tar.xz";
        hash = "sha256-nr658XadPDEMrq3ZIas0yPJkuSk3dAUYs7yFmleaaRI=";
      };
    });

#    ibus = prev.ibus.overrideAttrs (old: {
#      buildInputs = [glib_2_90 pango_1_58 gtk_4_24] ++ old.buildInputs;
#      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev gtk_4_24.dev] ++ old.nativeBuildInputs;
#    });

    mutter = prev.mutter.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/mutter/51/mutter-${gnomeVersion}.tar.xz";
        hash = "sha256-XSjzriJWkkKPyvuWUA1nPzQyi2mLhpYMnBRg0LHZg7M=";
      };
      outputs = ["out" "dev" "man"];
      patches = [];
      mesonFlags =
        final.lib.filter
        (flag: !(final.lib.hasPrefix "-Degl_device=" flag || final.lib.hasPrefix "-Dwayland_eglstream=" flag))
        old.mesonFlags;
    });

#    gdm = prev.gdm.overrideAttrs (old: {
#      version = gnomeVersion;
#      src = final.fetchurl {
#        url = "mirror://gnome/sources/gdm/51/gdm-${gnomeVersion}.tar.xz";
#        hash = "sha256-LOWs9aQ4uPbcHRT9d3qRG+XusvermnxGABZiBbFdZTY=";
#      };
#    });

    gnome-session = prev.gnome-session.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-session/51/gnome-session-${gnomeVersion}.tar.xz";
        hash = "sha256-UZXE9gVCqVOrbr0ojzeFuOd0YpLYwWfgyZ01NDihhNE=";
      };
    });

    gnome-settings-daemon = prev.gnome-settings-daemon.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-settings-daemon/51/gnome-settings-daemon-${gnomeVersion}.tar.xz";
        hash = "sha256-fGJJEY3f/8S7NNaz7aqGs+oCoa0rdxHXlIB0mQZ2dmU=";
      };
    });

    gnome-backgrounds = prev.gnome-backgrounds.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-backgrounds/51/gnome-backgrounds-${gnomeVersion}.tar.xz";
        hash = "sha256-WBHSQRjXj0G2bGFu+xCUwgUHy1RuSE3KSWP+c4pLp9s=";
      };
    });

    gnome-disk-utility = prev.gnome-disk-utility.overrideAttrs (old: {
      version = "51.beta";
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-disk-utility/51/gnome-disk-utility-51.beta.tar.xz";
        hash = "sha256-8YHXk/BoTzmb920pfA43FoScePpnKSt2Xb2ew9+lyAA=";
      };
      buildInputs = old.buildInputs ++ [final.rustc final.cargo final.gtk4 final.libadwaita final.blueprint-compiler];
    });

#    nautilus = prev.nautilus.overrideAttrs (old: {
#      version = "51.0.1";
#      src = final.fetchurl {
#        url = "mirror://gnome/sources/nautilus/51/nautilus-51.0.1.tar.xz";
#        hash = "sha256-oA25CP1lAmy9XcY04S0YnejrorA/EF0kJTQXaKXukvs=";
#      };
#      buildInputs = [glib_2_90 pango_1_58 gtk_4_24] ++ old.buildInputs;
#      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev gtk_4_24.dev] ++ old.nativeBuildInputs;
#    });

#    gnome-control-center = prev.gnome-control-center.overrideAttrs (old: {
#      version = gnomeVersion;
#      src = final.fetchurl {
#        url = "mirror://gnome/sources/gnome-control-center/51/gnome-control-center-${gnomeVersion}.tar.xz";
#        hash = "sha256-yMpbagrkT9DWSqxao7eag8JEUJWxWanRPRycwXKsT7k=";
#      };
#
#      patches = [ ];
#
#      buildInputs = [glib_2_90 pango_1_58 gtk_4_24] ++ old.buildInputs;
#      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev gtk_4_24.dev] ++ old.nativeBuildInputs;
#    });

    gnome-shell = prev.gnome-shell.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-shell/51/gnome-shell-${gnomeVersion}.tar.xz";
        hash = "sha256-IXm6sTrzU0JwZQlq+L89MNp7huDFFuW6hqFJmK+VdfY=";
      };
      buildInputs = old.buildInputs ++ [final.cairo final.libgudev final.libglycin];
      env.NIX_CFLAGS_COMPILE = (old.env.NIX_CFLAGS_COMPILE or "") + " -I${final.cairo.dev}/include/cairo";

      patches = final.lib.take 3 old.patches ++ [
(final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/233c760cfe7b557f1cb351316d229de586fd2b9f.patch";
          hash = "sha256-uOrntaCOoHcka4EIE0D2wffAq1eSoiPlJ3rv1eP7sCc=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/4c2b2978c8aeb17989bc5f17a7dfe88f1a2da0e0.patch";
          hash = "sha256-gYqnsUf7jAPANTgs3l4Zs5pt7mdXsblGMfUCMMIwfmc=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/648ffa0894b6ef15e49e4626d24f64b1166093be.patch";
          hash = "sha256-gI8pGfLpkYzP3ymFG06+4VGBviDUIN8HJfNC+mEtgg4=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/c163b25ec11e066cccf13173b7640becb3c9000a.patch";
          hash = "sha256-z4VO9l8id2m0+viFySnS/42vzpV1tMBHpSZsH0MF9A0=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/3aaffc26cb3382707c9d2d1e82af3cc13958e126.patch";
          hash = "sha256-LS//6ocgolMO+GweWtdd87OFy2UBSMa9HX0XU2uU7KA=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/71dc1a36afc8f377db5b753358f9d7ce6f461e26.patch";
          hash = "sha256-aGg0dISwf/5ZRS93eoJhSE8/2mnCqo6eAxixxYSEJbA=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/b22f754b6a7f879e2982cf1a049c1f1909404f11.patch";
          hash = "sha256-bGTeqEpyeyFtTVYwPkC6LxtVwd4rt0FK+f3VlSMdQHA=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/a8eb665f9dbb575ebb640fc7d6a61c0d83701eca.patch";
          hash = "sha256-eHgSa+SLv+fZsm6kVjHsRuTnt0gj/VeCS4+UNDxPUR4=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/e20768205d111dae0dc4f8805c8e4f1a94b7ba13.patch";
          hash = "sha256-4SgupXetnJBU4V9wRRk87HHTmpos6MENTLHGcSVLpoU=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/5fd7ca22a7a77ab4d630e39cd206e8b96a4080a5.patch";
          hash = "sha256-zVQLX6gtWUJxGtLUve9HMtOeriGTkVjf58bCzrd1Lic=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/db710eff6d2679e5fffa75db812b0c2804b970e4.patch";
          hash = "sha256-pYEIE1EFiNJKnRboVe/bDLzuyBb6EnkM9TozMqbbXUs=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/88ab6a9d3f204214c13c781a29d39b33eda95238.patch";
          hash = "sha256-sm3dWJ5/zFx3Ha8z7B6xXOTtP1Xm5eSJOI2hn9e6Lq0=";
        })

        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/cf90e2eb4e35426aff103caaae9b50504fec1bfd.patch";
          hash = "sha256-Uq7yfTBU7QsP3xOWD1X7i5A687ewfeNPIPI4jcW+PHs=";
        })
      ];


      postPatch = ''
        patchShebangs build-aux/generate-app-list.py || true
        rm -f man/gnome-shell.1
        rm -f data/theme/gnome-shell-light.css data/theme/gnome-shell-dark.css

        substituteInPlace meson.build \
          --replace-fail "gjs = find_program('gjs')" "gjs = find_program('${final.lib.getExe final.gjs}')"

        python3 ${./scripts/fix-gdm-login-dialog.py}
        python3 ${./scripts/fix-gdm-auth-services-legacy.py}
      '';
    });
  }
