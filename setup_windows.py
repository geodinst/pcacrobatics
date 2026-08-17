#!/usr/bin/env python3
"""Apply the Windows runtime compatibility step needed by GRASS 8.6-dev."""

from __future__ import annotations

from pathlib import Path
import shutil
import sys


def main() -> int:
    if sys.platform != "win32":
        print("[SKIP] Windows runtime setup is only needed on Windows.")
        return 0

    bin_dir = Path(sys.prefix) / "Library" / "bin"
    libomp = bin_dir / "libomp.dll"
    libomp_alias = bin_dir / "libomp140.x86_64.dll"
    openblas = bin_dir / "openblas.dll"

    missing = [path for path in (libomp, openblas) if not path.is_file()]
    if missing:
        print("Windows runtime setup failed. Missing required file(s):", file=sys.stderr)
        for path in missing:
            print(f"- {path}", file=sys.stderr)
        print(
            "Recreate the environment from environment-windows.yml before retrying.",
            file=sys.stderr,
        )
        return 1

    if libomp_alias.is_file():
        print(f"[OK] OpenMP compatibility DLL already exists: {libomp_alias}")
    else:
        shutil.copy2(libomp, libomp_alias)
        print(f"[OK] Created OpenMP compatibility DLL: {libomp_alias}")

    print(f"[OK] OpenBLAS runtime: {openblas}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
