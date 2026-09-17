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

    ibus = prev.ibus.overrideAttrs (old: {
      buildInputs = [glib_2_90 pango_1_58 gtk_4_24] ++ old.buildInputs;
      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev gtk_4_24.dev] ++ old.nativeBuildInputs;
    });

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

    gdm = prev.gdm.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gdm/51/gdm-${gnomeVersion}.tar.xz";
        hash = "sha256-omXuGFbL+X9Q2uPwh68iRMvbbWGW7NqjgsHOa4MNM7Y=";
      };
    });

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

    nautilus = prev.nautilus.overrideAttrs (old: {
      version = "51.0.1";
      src = final.fetchurl {
        url = "mirror://gnome/sources/nautilus/51/nautilus-51.0.1.tar.xz";
        hash = "sha256-oA25CP1lAmy9XcY04S0YnejrorA/EF0kJTQXaKXukvs=";
      };
      buildInputs = [glib_2_90 pango_1_58 gtk_4_24] ++ old.buildInputs;
      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev gtk_4_24.dev] ++ old.nativeBuildInputs;
    });

    gnome-control-center = prev.gnome-control-center.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-control-center/51/gnome-control-center-${gnomeVersion}.tar.xz";
        hash = "sha256-yMpbagrkT9DWSqxao7eag8JEUJWxWanRPRycwXKsT7k=";
      };

     patches = [ ];

      buildInputs = [glib_2_90 pango_1_58 gtk_4_24] ++ old.buildInputs;
      nativeBuildInputs = [glib_2_90.dev pango_1_58.dev gtk_4_24.dev] ++ old.nativeBuildInputs;
    });

    gnome-shell = prev.gnome-shell.overrideAttrs (old: {
      version = gnomeVersion;
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-shell/51/gnome-shell-${gnomeVersion}.tar.xz";
        hash = "sha256-IXm6sTrzU0JwZQlq+L89MNp7huDFFuW6hqFJmK+VdfY=";
      };
      buildInputs = old.buildInputs ++ [final.cairo final.libgudev final.libglycin];
      env.NIX_CFLAGS_COMPILE = (old.env.NIX_CFLAGS_COMPILE or "") + " -I${final.cairo.dev}/include/cairo";

      patches = final.lib.take 3 old.patches;

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
