# Point-Cloud Acrobatics: From Raw LiDAR to Stunning 3D Visuals
We want this workshop to be live and updated, so feel free to contribute if better options rise up, new standards get published and errors or typos are recognized.

## Workshop Outline  
The workshop begins by exploring the [ASPRS standard](https://community.asprs.org/leadership-restricted/leadership-content/public-documents/standards), helping you understand essential concepts like point classifications, return numbers, and other fundamental attributes that define LiDAR data. You’ll learn how to correctly interpret these attributes, assess data quality, and leverage them for more insightful analysis.

Moving beyond the basics, we’ll dig into powerful open-source workflows with [PDAL](https://pdal.io/), [GRASS](https://grass.osgeo.org/), [WhiteboxTools](https://www.whiteboxgeo.com/) for data reading, manipulation and  spatial processing, and with tools like [QGIS](https://www.qgis.org/), [Potree](https://potree.github.io/) and [pybabylonjs](https://github.com/TileDB-Inc/TileDB-PyBabylonJS) for dynamic 3D rendering. We’ll also introduce [TileDB](https://docs.tiledb.com/main) as a robust storage option to manage point-clouds as massive dataframes. Along the way, we’ll tackle real-world tasks like gridding, interpolation, vectorization, and classification, highlighting  effective approaches to manage and visualize large-scale point clouds in a reproducible manner.

By integrating Python scripts with these specialized tools, you’ll discover how to automate complex processing chains and generate stunning outputs that bring your LiDAR data to life. While basic Python knowledge is helpful, it’s not mandatory — anyone eager to learn new techniques can follow along. By the end of this hands-on workshop, you’ll not only grasp the core concepts behind LiDAR data but also have the practical skills to handle and present it in exciting, visually compelling ways.

The workshop follows four stages:

1. We begin with point-cloud and LiDAR theory.
2. We explore and visualize the workshop data in CloudCompare and QGIS.
3. We move to coding and reproducible processing with Python, PDAL, GRASS, WhiteboxTools, and TileDB.
4. We finish with web point-cloud visualization using Potree.

## Get Ready

### 1. Get the workshop

Clone the repository and enter its directory:

```bash
git clone https://github.com/geodinst/pcacrobatics.git
cd pcacrobatics
```

Alternatively, download the repository as a ZIP from [GitHub](https://github.com/geodinst/pcacrobatics), extract it, and open a terminal in the extracted `pcacrobatics` directory. Keep the repository structure unchanged because the notebooks use paths relative to this directory.

### 2. Add the data

Download the [prepared workshop data](https://app.gis.si/point-cloud-acrobatics/data.zip) and extract these four source tiles directly into `data/`:

- `GKOT_461_100.laz`
- `GKOT_462_100.laz`
- `GKOT_461_101.laz`
- `GKOT_462_101.laz`

The first notebook converts them to COPC under `results/copc/`. Point-cloud files and generated results are intentionally excluded from Git. The same expected layout is documented in `data/README.md`.

### 3. Create the Python environment

The YAML files work with [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/), preferably through [Miniforge](https://github.com/conda-forge/miniforge), [Mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html), and [Micromamba](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html). Micromamba is recommended. The workshop environment is always named `pcl`.

Linux x86-64 uses `environment.yml`:

```bash
micromamba create --channel-priority strict -f environment.yml
micromamba activate pcl
```

Windows x86-64 uses `environment-windows.yml` and one post-install compatibility step for the current GRASS 8.6 development build:

```powershell
micromamba create --channel-priority strict -f environment-windows.yml
micromamba activate pcl
python setup_windows.py
```

The Windows environment includes `llvm-openmp` and `libopenblas`, which are required by native modules in the current `grass-dev` build. `setup_windows.py` creates `libomp140.x86_64.dll` from Conda's `libomp.dll` when that compatibility DLL is missing. The script is safe to run again and does nothing when the compatibility DLL already exists. The workshop does not use `g.extension`, so a C compiler is not required.

macOS on Intel or Apple Silicon uses `environment-macos.yml` for processing:

```bash
micromamba create --channel-priority strict -f environment-macos.yml
micromamba activate pcl
```

Conda users can replace `micromamba create --channel-priority strict` with `conda env create` in these commands.

Linux and Windows install QGIS with point-cloud support in `pcl`. On macOS, QGIS requires a separate environment because its available packages use an older native stack:

```bash
micromamba create --channel-priority strict -f environment-macos-qgis.yml
micromamba run -n pcl-qgis qgis
```

`whitebox-workflows` is included on Apple Silicon (`M1` and newer). Its current PyPI wheel is unavailable for Intel macOS.

### Storage requirements

Keep at least **15 GB of free disk space** for the workshop; **20 GB is recommended** while creating the environment because Conda and Micromamba retain downloaded packages in a cache.

Measured on the complete Linux workshop run:

- `pcl` environment: approximately **6.4 GB**
- Four source LAZ files in `data/`: approximately **0.8 GB**
- Four generated COPCs: approximately **0.6 GB**
- TileDB array containing all **78,587,620 points**: approximately **1.5 GB**
- GRASS project and other generated outputs: approximately **0.1 GB**
- Repository data and generated results together: approximately **3 GB**

Package-download caches require additional temporary space and vary by platform. They can be cleaned with the package manager after the environment has been created successfully.

### 4. Verify the environment

From the activated `pcl` environment, run:

```bash
python test_env.py
```

Do not continue until this check passes. It verifies the workshop imports, GRASS Python packages and native GRASS modules, PDAL plugin loading, the required point-cloud drivers, and QGIS when it is part of the platform environment.

### 5. Choose your notebook interface

Both options use the same `pcl` environment and workshop files. Choose one and test the notebook there. A browser-based Jupyter interface is the quickest route; VSCodium provides a larger development environment with better project navigation, editing, debugging, and source-control tools.

#### Option A: Jupyter in your browser

On **Windows**, launch JupyterLab directly from the activated `pcl` environment in the repository directory:

```powershell
jupyter lab PointCloudAcrobatics.ipynb
```

Use the `pcl` kernel if JupyterLab asks you to select one. The notebook initializes the GRASS project through `workshop_setup.py`; the GRASS GUI's integrated Jupyter launcher is not required on Windows.

On **Linux and macOS**, you can also initialize the workshop project and launch GRASS 8.6 from the repository directory:

```bash
python -c "from workshop_setup import get_workshop; get_workshop()"
grass results/point_cloud_action/PERMANENT
```

In GRASS:

1. Click **Jupyter Notebook** in the toolbar.
2. Choose the repository as the custom notebook directory.
3. Click **Open Notebook in Browser**.
4. Open `PointCloudAcrobatics.ipynb`.

GRASS starts Jupyter with the active workshop environment and project.

#### Option B: VSCodium

Choose this option for a more powerful coding workspace with a few additional setup steps.

1. Install [VSCodium](https://vscodium.com/#install).
2. Open the Extensions view and install [Python](https://open-vsx.org/extension/ms-python/python) (`ms-python.python`) and [Jupyter](https://open-vsx.org/extension/ms-toolsai/jupyter) (`ms-toolsai.jupyter`) from Open VSX.
3. Open the command palette and run `Preferences: Open User Settings (JSON)`.
4. Add the applicable settings below while preserving your existing settings.

Linux or macOS with a standard Micromamba installation:

```json
{
  "python.defaultInterpreterPath": "${env:HOME}/micromamba/envs/pcl/bin/python",
  "python.condaPath": "${env:HOME}/micromamba/bin/micromamba",
  "python.terminal.activateEnvironment": true
}
```

Windows with a standard Micromamba installation:

```json
{
  "python.defaultInterpreterPath": "${env:USERPROFILE}\\micromamba\\envs\\pcl\\python.exe",
  "python.condaPath": "${env:USERPROFILE}\\micromamba\\micromamba.exe",
  "python.terminal.activateEnvironment": true
}
```

Adjust the paths if Micromamba is installed elsewhere. Conda or Miniforge users should point `python.defaultInterpreterPath` to the `pcl` Python executable and `python.condaPath` to their `conda` executable.

Open this repository in VSCodium, run `Python: Select Interpreter`, and select `pcl`. Open `PointCloudAcrobatics.ipynb`, click `Select Kernel`, and select the same `pcl` environment.

### 6. Test your chosen interface

Open `PointCloudAcrobatics.ipynb` in your preferred interface and run its workshop-context cell:

```python
from workshop_setup import get_workshop

workshop = get_workshop()
tools = workshop.tools
```

`workshop_setup.py` keeps the notebook code simple. It finds the repository paths, loads GRASS from `pcl`, creates or reconnects to the project under `results/`, and provides the active session and `Tools`. After a kernel restart, calling it again restores this lightweight setup and reuses existing results without rerunning expensive processing.

Trying the other interface is optional.

### Mandatory checklist

Before the workshop, confirm that:

- The repository is cloned or extracted with its directory structure intact.
- The four required LAZ files are in `data/`.
- The correct platform YAML created the `pcl` environment.
- On Windows, `python setup_windows.py` completed successfully.
- `python test_env.py` passes.
- `PointCloudAcrobatics.ipynb` opens and the context cell runs in your chosen interface.
- CloudCompare is installed separately as described below.
- On macOS, `pcl-qgis` is created when QGIS is needed.

## Mandatory CloudCompare installation

Install the latest official stable [CloudCompare](https://www.cloudcompare.org/release/) separately from the Conda environment. At the time of writing, this is CloudCompare 2.13.2. CloudCompare is mandatory for the workshop and is not distributed by conda-forge.

- Windows: use the official 64-bit installer.
- Linux: install the official [Flathub package](https://flathub.org/apps/org.cloudcompare.CloudCompare).
- macOS: use the official download linked from the CloudCompare release page for Intel or Apple Silicon.

Do not substitute an unofficial Conda build because its GUI plugins and point-cloud format support may differ from the official desktop release.

## Notebooks
- **PointCloudAcrobatics.ipynb**: Notebook used for the first part of the tutorial, focused on theory, data processing, and local point cloud visualization.
- **WebPointCloudAcrobatics.ipynb**: Notebook deals with some commonly used libraries for Web based point cloud visualization.

The workshop data originated from the [CLSS portal](https://www.clss.si), which provides LiDAR data for Slovenia. The required filenames and installation location are listed in **Get Ready** and `data/README.md`.

## Optional Potree installation

Installing standalone Potree/PotreeConverter is not mandatory. The workshop is designed to demonstrate this part without requiring participants to install it, but participants who want to follow it interactively can install Potree/PotreeConverter separately. [Potree installation instructions placeholder](https://example.org/point-cloud-acrobatics/potree-setup).

## QGIS outside the Conda environment

The supported Linux `environment.yml` and Windows `environment-windows.yml` already install QGIS with PDAL point-cloud support, and macOS has the separate `pcl-qgis` environment described above. For systems not supported by these YAML files, install a current QGIS desktop build separately and confirm that it can open LAS/LAZ or COPC point clouds before the workshop.

- Linux: the [QGIS Flatpak](https://flathub.org/apps/org.qgis.qgis) is the simplest isolated installation with point-cloud support.
- Windows: use the current 64-bit standalone or OSGeo4W installer from the [official QGIS download page](https://qgis.org/download/).
- macOS: use the current signed installer from the [official QGIS download page](https://qgis.org/download/). This external QGIS application remains separate from the `pcl` GRASS environment.
