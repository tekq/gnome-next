# The GNOME Next overlay: bleeding-edge (51.beta/rc) builds of the core
# session packages, built from upstream release tarballs against the
# current nixpkgs toolchain.
#
# Deliberately NOT overridden here - left in place as comments below so
# they're easy to revisit, not deleted, since these were reverted for now
# rather than ruled out for good:
#   - gdm                    -> 51.beta causes constant login issues, and
#                                breaks the lock screen and crashes sessions
#   - gnome-control-center    -> build fails because of patches (TODO: fix)
#   - gtk4, glib              -> only pulled in for gnome-control-center above,
#                                 same patch/path problems
#
# WARNING: do not touch gnome-shell's `patches` or `postPatch` on a whim.
# Changing them changes gnome-shell's derivation hash, which can force a
# full from-source rebuild of everything downstream of it - including,
# somehow, webkit. If you need to touch it, expect a very long CI run and
# budget for it (see the workflow's per-job timeout).
let
  gnomeVersion = "51.beta";
in
final: prev: {
  gsettings-desktop-schemas = prev.gsettings-desktop-schemas.overrideAttrs (old: {
    version = gnomeVersion;
    src = final.fetchurl {
      url = "mirror://gnome/sources/gsettings-desktop-schemas/51/gsettings-desktop-schemas-${gnomeVersion}.tar.xz";
      hash = "sha256-S41IfDEu00VUN3ipLZdK/Pzot8wskIgI8ltyW5FSiRQ=";
    };
  });

  gnome-desktop = prev.gnome-desktop.overrideAttrs (old: {
    version = gnomeVersion;
    src = final.fetchurl {
      url = "mirror://gnome/sources/gnome-desktop/51/gnome-desktop-51.alpha.tar.xz";
      hash = "sha256-ik0JYY/siP/xVJ5bgKxBd276zLjWXbP7dzRbU5SBmTI=";
    };
  });

  mutter = prev.mutter.overrideAttrs (old: {
    version = gnomeVersion;
    src = final.fetchurl {
      url = "mirror://gnome/sources/mutter/51/mutter-${gnomeVersion}.tar.xz";
      hash = "sha256-pV0W+s6FIyLCpt0/1KjZIJVPY2LKkbWBeJqTA4Rsx1Q=";
    };
    outputs = [ "out" "dev" "man" ];
    mesonFlags = final.lib.filter
      (flag: !(final.lib.hasPrefix "-Degl_device=" flag || final.lib.hasPrefix "-Dwayland_eglstream=" flag))
      old.mesonFlags;
  });

  # gdm = prev.gdm.overrideAttrs (old: {
  #   version = gnomeVersion;
  #   src = final.fetchurl {
  #     url = "mirror://gnome/sources/gdm/51/gdm-${gnomeVersion}.tar.xz";
  #     hash = "sha256-omXuGFbL+X9Q2uPwh68iRMvbbWGW7NqjgsHOa4MNM7Y=";
  #   };
  # });

  gnome-session = prev.gnome-session.overrideAttrs (old: {
    version = gnomeVersion;
    src = final.fetchurl {
      url = "mirror://gnome/sources/gnome-session/51/gnome-session-${gnomeVersion}.tar.xz";
      hash = "sha256-Lj47baIMl0Z0F1Dfm9cautArKoyGAuTZfFzH+DWcjQQ=";
    };
  });

  gnome-settings-daemon = prev.gnome-settings-daemon.overrideAttrs (old: {
    version = "51.rc";
    src = final.fetchurl {
      url = "mirror://gnome/sources/gnome-settings-daemon/51/gnome-settings-daemon-51.rc.tar.xz";
      hash = "sha256-RZNEiHZ9Tjz9FLFVf+2POoPLVPb/TUyyCY2d+Eanyxw=";
    };
  });

  gnome-backgrounds = prev.gnome-backgrounds.overrideAttrs (old: {
    version = gnomeVersion;
    src = final.fetchurl {
      url = "mirror://gnome/sources/gnome-backgrounds/51/gnome-backgrounds-${gnomeVersion}.tar.xz";
      hash = "sha256-trvTwNwZyWhJeb9Al9SM2Xs8SALIra/6LoLCBI8xVs8=";
    };
  });

  # build fails because of patches
  # TODO: fix build
  # gnome-control-center = prev.gnome-control-center.overrideAttrs (old: {
  #   version = "51.rc.1";
  #   src = final.fetchurl {
  #     url = "mirror://gnome/sources/gnome-control-center/51/gnome-control-center-51.rc.1.tar.xz";
  #     hash = "sha256-Bd2wWpu7vD2AM2sEkh5VoPnU3TZ5fvjcDIHRjt58edc=";
  #   };
  #   patches = [ ];
  # });

  # dep of gnome-control-center, also fails because of patches
  # gtk4 = prev.gtk4.overrideAttrs (old: {
  #   version = "4.23.4";
  #   src = final.fetchurl {
  #     url = "mirror://gnome/sources/gtk/4.23/gtk-4.23.4.tar.xz";
  #     hash = "sha256-Wd9xJEzyBgG0JdGhOyp+gFuFTTteEa0l9/mOYTz8W60=";
  #   };
  #   patches = [ ];
  # });

  # dep of gnome-control-center, likely fails because of unfixed paths
  # glib = prev.glib.overrideAttrs (old: {
  #   version = "2.89.4";
  #   src = final.fetchurl {
  #     url = "mirror://gnome/sources/glib/2.89/glib-2.89.4.tar.xz";
  #     hash = "sha256-HNu3mfVYgy5vFLgze1/VmcaRirFEl3tV4F4ApeLoSiw=";
  #   };
  # });

  # WARNING: see the note at the top of this file before touching anything
  # in this derivation - it's the one that (transitively) drags webkit into
  # the build.
  gnome-shell = prev.gnome-shell.overrideAttrs (old: {
    version = gnomeVersion;
    src = final.fetchurl {
      url = "mirror://gnome/sources/gnome-shell/51/gnome-shell-${gnomeVersion}.tar.xz";
      hash = "sha256-m5TCYSAliXKsVJSywRtYN1X4pUEdKf4oUPQm2AT/uyY=";
    };
    buildInputs = old.buildInputs ++ [ final.cairo final.libgudev ];
    env.NIX_CFLAGS_COMPILE = (old.env.NIX_CFLAGS_COMPILE or "") + " -I${final.cairo.dev}/include/cairo";

    # HACK: only the first 3 of upstream nixpkgs' patches apply cleanly
    # against ${gnomeVersion} - the rest fail outright. Worth re-checking
    # against nixpkgs' patch list whenever this version is bumped.
    patches = final.lib.take 3 old.patches;

    postPatch = ''
      patchShebangs build-aux/generate-app-list.py || true
      rm -f man/gnome-shell.1
      rm -f data/theme/gnome-shell-light.css data/theme/gnome-shell-dark.css

      substituteInPlace meson.build \
        --replace-fail "gjs = find_program('gjs')" "gjs = find_program('${final.lib.getExe final.gjs}')"

      # 51.beta regression fixes for GDM (see scripts/ for what and why).
      # Each script hard-fails if its expected text isn't found, instead of
      # silently no-op'ing - so if a nixpkgs bump breaks one, CI tells you.
      python3 ${./scripts/fix-gdm-login-dialog.py}
      python3 ${./scripts/fix-gdm-auth-services-legacy.py}
    '';
  });
}
