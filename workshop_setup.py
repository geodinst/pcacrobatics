"""Reusable setup for Point-Cloud Acrobatics workshop notebooks."""

from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache
import importlib
from pathlib import Path
import shutil
import subprocess
import sys
from typing import Any


SOURCE_NAMES = (
    "GKOT_461_100.laz",
    "GKOT_462_100.laz",
    "GKOT_461_101.laz",
    "GKOT_462_101.laz",
)


@dataclass(frozen=True)
class Workshop:
    project_root: Path
    data_dir: Path
    results_dir: Path
    copc_dir: Path
    source_laz_files: tuple[Path, ...]
    copc_files: tuple[Path, ...]
    grass_project: Path
    permanent_mapset: Path
    grass_executable: str
    gs: Any
    gj: Any
    session: Any
    tools: Any


@lru_cache(maxsize=1)
def get_workshop() -> Workshop:
    """Initialize paths and reconnect to the cached workshop GRASS session."""
    project_root = Path(__file__).resolve().parent
    data_dir = project_root / "data"
    results_dir = project_root / "results"
    copc_dir = results_dir / "copc"
    results_dir.mkdir(parents=True, exist_ok=True)
    copc_dir.mkdir(parents=True, exist_ok=True)

    source_laz_files = tuple(data_dir / name for name in SOURCE_NAMES)
    missing_inputs = [path for path in source_laz_files if not path.is_file()]
    if missing_inputs:
        raise FileNotFoundError(f"Missing workshop inputs: {missing_inputs}")

    grass_executable = shutil.which("grass")
    if not grass_executable:
        raise RuntimeError("GRASS was not found in the selected notebook environment")

    grass_python_path = subprocess.check_output(
        [grass_executable, "--config", "python_path"], text=True
    ).strip()
    if grass_python_path not in sys.path:
        sys.path.insert(0, grass_python_path)

    gs = importlib.import_module("grass.script")
    gj = importlib.import_module("grass.jupyter")
    tools_class = importlib.import_module("grass.tools").Tools

    grass_project = results_dir / "point_cloud_action"
    permanent_mapset = grass_project / "PERMANENT"
    if grass_project.exists() and not (permanent_mapset / "DEFAULT_WIND").is_file():
        raise RuntimeError(f"Existing path is not a valid GRASS project: {grass_project}")
    if not grass_project.exists():
        gs.create_project(path=grass_project, crs="EPSG:3794")

    # Reuse an already active GRASS runtime instead of initializing it again.
    # On Windows, a second setup.init() currently produces a duplicated GISBASE.
    if gs.setup.runtime_env_is_active():
        session = None
        tools = tools_class(overwrite=True)
    else:
        session = gs.setup.init(permanent_mapset)
        tools = tools_class(session=session, overwrite=True)

    copc_files = tuple(copc_dir / f"{path.stem}.copc.laz" for path in source_laz_files)

    return Workshop(
        project_root=project_root,
        data_dir=data_dir,
        results_dir=results_dir,
        copc_dir=copc_dir,
        source_laz_files=source_laz_files,
        copc_files=copc_files,
        grass_project=grass_project,
        permanent_mapset=permanent_mapset,
        grass_executable=grass_executable,
        gs=gs,
        gj=gj,
        session=session,
        tools=tools,
    )
