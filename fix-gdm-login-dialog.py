#!/usr/bin/env python3
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

