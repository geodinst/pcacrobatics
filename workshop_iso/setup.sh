apt update -y
#some stuff that might help with mounting external drives
apt install -y exfatprogs exfat-fuse dosfstools ntfs-3g
./scripts/build_and_install_pdal.sh 
./scripts/build_and_install_grass.sh
./scripts/build_and_install_cloud_compare.sh
./scripts/install_micromamba.sh 
./scripts/install_vscodium.sh
./scripts/add-foss4g-menu.sh 
./scripts/add-desktop-shortcuts.sh
./scripts/download_and_unpack_whitebox_tools.sh
./scripts/turn_off_auto_updates.sh
