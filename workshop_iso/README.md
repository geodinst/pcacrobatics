Live ISO was prepared with Cubic (https://github.com/PJ-Singh-001/Cubic) from the Lubuntu 24.04.2 LTS (https://lubuntu.me/downloads/) ISO image.

The following was built/installed:

- [PDAL](./scripts/build_and_install_pdal.sh) 
     https://github.com/PDAL/PDAL
- [CloudCompare](./scripts/build_and_install_cloud_compare.sh) 
     https://github.com/CloudCompare/CloudCompare
- [GRASS](./scripts/build_and_install_grass.sh) 
     https://github.com/OSGeo/grass
- [Micromamba](./scripts/install_micromamba.sh) 
     https://github.com/mamba-org/micromamba-releases
  - QGIS was installed in micromamba environment

- [VSCodium](./scripts/install_vscodium.sh) 
     https://github.com/VSCodium/vscodium
  - extensions were installed in refernce environment and copied manually: `cp -r ../.vscode-oss /home/lubuntu`
- [Menu entries](./scripts/add-foss4g-menu.sh)
- [Menu application launchers](./scripts/add-desktop-shortcuts.sh)
- [Whitebox tools](./scripts/download_and_unpack_whitebox_tools.sh) 
     https://github.com/jblindsay/whitebox-tools
- [Turn off autoupdates](./scripts/turn_off_auto_updates.sh) - this is not really working, auto updates are still pending

Additionally, also some stuff to ease access to exFat drive was added:

```
apt update -y
#some stuff that might help with mounting external drives
apt install -y exfatprogs exfat-fuse dosfstools ntfs-3g
```

and (I don't really know why - it might come in handy) also `nodejs` and `npm` from official repo.

And a nice AI generated desktop image was merged to the default lubuntu wallpaper







