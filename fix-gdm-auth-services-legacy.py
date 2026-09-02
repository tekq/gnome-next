#!/usr/bin/env python3
"""51.beta regression fixes for GDM re-authentication (e.g. unlocking the
screen). Upstream tightened a couple of reset/username guards in a way
that stops soft resets and mechanism auto-selection from firing outside
the dedicated re-auth path - relax them so they still fire whenever
there's a known user.

Run from the gnome-shell source root - this is invoked from
overlay.nix's postPatch, not meant to be run standalone.
"""
import sys

PATH = "js/gdm/authServicesLegacy.js"


def must_replace(text: str, old: str, new: str) -> str:
    updated = text.replace(old, new)
    if updated == text:
        sys.exit(
            f"fix-gdm-auth-services-legacy.py: expected pattern not found in {PATH}.\n"
            "Upstream source has likely changed - this patch needs updating."
        )
    return updated


def main() -> None:
    with open(PATH) as f:
        contents = f.read()

    contents = must_replace(
        contents,
        "if (!this._reauthOnly)\n            return;\n\n        this._fingerprintManager",
        "this._fingerprintManager",
    )

    contents = must_replace(
        contents,
        "if (this._selectedMechanism)\n            this.emit('reset', {softReset: true});",
        "if (this._selectedMechanism && (this._reauthOnly || this._userName))\n            this.emit('reset', {softReset: true});",
    )

    contents = must_replace(
        contents,
        "this._updateEnabledMechanisms();\n        this.emit('reset', {softReset: true, reuseEntryText: true});",
        "this._updateEnabledMechanisms();\n        if (this._reauthOnly || this._userName)\n            this.emit('reset', {softReset: true, reuseEntryText: true});",
    )

    with open(PATH, "w") as f:
        f.write(contents)


if __name__ == "__main__":
    main()
