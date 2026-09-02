#!/usr/bin/env python3
"""51.beta regression fix for the GDM login logo.

Upstream 51.beta renders the login-screen logo at its "natural" size
(-1, -1) instead of a fixed height, which makes it render oversized.
Pin the height to 48px instead.

Run from the gnome-shell source root - this is invoked from
overlay.nix's postPatch, not meant to be run standalone.
"""
import sys

PATH = "js/gdm/loginDialog.js"


def must_replace(text: str, old: str, new: str) -> str:
    updated = text.replace(old, new)
    if updated == text:
        sys.exit(
            f"fix-gdm-login-dialog.py: expected pattern not found in {PATH}.\n"
            "Upstream source has likely changed - this patch needs updating."
        )
    return updated


def main() -> None:
    with open(PATH) as f:
        contents = f.read()

    contents = must_replace(
        contents,
        "this._logoFile,\n                -1, -1,",
        "this._logoFile,\n                -1, 48,",
    )

    with open(PATH, "w") as f:
        f.write(contents)


if __name__ == "__main__":
    main()
