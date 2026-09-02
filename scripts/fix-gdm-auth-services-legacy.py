#!/usr/bin/env python3
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
