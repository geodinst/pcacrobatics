#!/usr/bin/env python3
"""Check that the Point-Cloud Acrobatics workshop environment is usable."""

from __future__ import annotations

import importlib
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys


REQUIRED_PDAL_DRIVERS = {
    "readers.copc",
    "readers.las",
    "writers.copc",
    "writers.gdal",
    "writers.tiledb",
}

REQUIRED_IMPORTS = {
    "geopandas": "geopandas",
    "IPython": "ipython",
    "laspy": "laspy",
    "matplotlib": "matplotlib",
    "numpy": "numpy",
    "pandas": "pandas",
    "pdal": "python-pdal",
    "pyarrow": "pyarrow",
    "pybabylonjs": "pybabylonjs",
    "scipy": "scipy",
    "sklearn": "scikit-learn",
    "skimage": "scikit-image",
    "tifffile": "tifffile",
    "tiledb": "tiledb-py",
    "whitebox": "whitebox",
}

if not (sys.platform == "darwin" and platform.machine() == "x86_64"):
    REQUIRED_IMPORTS["whitebox_workflows"] = "whitebox-workflows"


def check_import(module_name: str, package_name: str) -> str | None:
    try:
        importlib.import_module(module_name)
    except Exception as error:  # Report binary-loader failures as well as ImportError.
        return f"{package_name}: {type(error).__name__}: {error}"
    print(f"[OK] import {module_name}")
    return None


def check_command(command: str, arguments: list[str]) -> str | None:
    executable = shutil.which(command)
    if executable is None:
        return f"command not found: {command}"

    try:
        result = subprocess.run(
            [executable, *arguments],
            check=True,
            capture_output=True,
            text=True,
            timeout=30,
        )
    except (OSError, subprocess.SubprocessError) as error:
        return f"{command}: {type(error).__name__}: {error}"

    version = (result.stdout or result.stderr).strip().splitlines()[0]
    print(f"[OK] {command}: {version}")
    return None


def check_pdal_drivers() -> str | None:
    executable = shutil.which("pdal")
    if executable is None:
        return "command not found: pdal"

    try:
        result = subprocess.run(
            [executable, "--drivers"],
            check=True,
            capture_output=True,
            text=True,
            timeout=30,
        )
    except (OSError, subprocess.SubprocessError) as error:
        return f"pdal --drivers: {type(error).__name__}: {error}"

    if result.stderr.strip():
        return f"pdal plugin loader reported errors:\n{result.stderr.strip()}"

    missing = sorted(
        driver for driver in REQUIRED_PDAL_DRIVERS if driver not in result.stdout
    )
    if missing:
        return f"PDAL drivers not found: {', '.join(missing)}"

    print(f"[OK] PDAL drivers: {', '.join(sorted(REQUIRED_PDAL_DRIVERS))}")
    return None


def check_grass_python() -> str | None:
    try:
        environment_root = Path(sys.prefix).resolve()
        python_paths = sorted(
            path
            for library_dir in (
                environment_root / "lib",
                environment_root / "Library" / "lib",
            )
            for path in library_dir.glob("grass*/etc/python")
            if (path / "grass" / "__init__.py").is_file()
        )
        if not python_paths:
            return f"GRASS Python packages not found under {environment_root}"

        python_path = python_paths[-1]
        if str(python_path) not in sys.path:
            sys.path.insert(0, str(python_path))
        importlib.import_module("grass.script")
        importlib.import_module("grass.jupyter")
    except Exception as error:
        return f"GRASS Python: {type(error).__name__}: {error}"

    print(f"[OK] GRASS Python: {python_path}")
    return None


def main() -> int:
    print(f"Python: {sys.version.split()[0]}")
    print(f"Environment: {os.environ.get('CONDA_PREFIX', 'not detected')}")

    failures = [
        failure
        for module_name, package_name in REQUIRED_IMPORTS.items()
        if (failure := check_import(module_name, package_name)) is not None
    ]

    for command, arguments in (("pdal", ["--version"]), ("grass", ["--version"])):
        failure = check_command(command, arguments)
        if failure:
            failures.append(failure)

    pdal_failure = check_pdal_drivers()
    if pdal_failure:
        failures.append(pdal_failure)

    grass_failure = check_grass_python()
    if grass_failure:
        failures.append(grass_failure)

    qgis = shutil.which("qgis")
    if qgis:
        qgis_failure = check_command("qgis", ["--version"])
        if qgis_failure:
            failures.append(qgis_failure)
    else:
        print("[SKIP] QGIS is installed separately for this platform")

    if failures:
        print("\nEnvironment check failed:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print("\nAll required environment checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
