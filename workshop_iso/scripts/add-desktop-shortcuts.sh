#!/bin/bash
# install-desktop-shortcuts.sh

# Directory for the shortcuts
cat << EOF > /usr/share/desktop-directories/foss4g-workshop.directory
[Desktop Entry]
Name=FOSS4G Workshop
Comment=Custom apps installed for FOSS4G training
Icon=applications-education
Type=Directory
EOF
chmod +x /usr/share/desktop-directories/foss4g-workshop.directory

# Paths
CLOUDCOMPARE_BIN="CloudCompare"
GRASS_BIN="grass"
CLOUDCOMPARE_ICON="/usr/share/icons/hicolor/48x48/apps/cloudcompare.png"
GRASS_ICON="/usr/share/icons/hicolor/48x48/apps/grass.png"

# Desktop entry for CloudCompare
cat << EOF > /usr/share/applications/cloudcompare.desktop
[Desktop Entry]
Name=CloudCompare
Comment=3D point cloud and mesh processing software
Exec=$CLOUDCOMPARE_BIN
Icon=cloudcompare
Terminal=false
Type=Application
Categories=foss4g-workshop;
EOF

chmod +x /usr/share/applications/cloudcompare.desktop

# Desktop entry for GRASS GIS
cat << EOF > /usr/share/applications/grass.desktop
[Desktop Entry]
Name=GRASS GIS
Comment=Geospatial data management and analysis
Exec=$GRASS_BIN
Icon=grass
Terminal=false
Type=Application
Categories=foss4g-workshop;
EOF

chmod +x /usr/share/applications/grass.desktop

# Desktop entry for VSCodium
cat << EOF > /usr/share/applications/vscodium.desktop
[Desktop Entry]
Name=VSCodium
Comment=VSCodium is a community-driven, freely-licensed binary distribution of Microsoft’s editor VS Code.
Exec=/opt/VSCodium/codium --no-sandbox
Icon=codium
Terminal=false
Type=Application
Categories=foss4g-workshop;
EOF

chmod +x /usr/share/applications/vscodium.desktop

install -Dm644 /home/lubuntu/micromamba/envs/geo_env/share/icons/hicolor/scalable/apps/qgis.svg /usr/share/icons/hicolor/scalable/apps/qgis.svg

# Desktop entry for QGIS
cat << EOF > /usr/share/applications/qgis.desktop
[Desktop Entry]
Name=QGIS
Exec=sh -c 'micromamba run -n geo_env qgis'
Icon=qgis
Terminal=false
Type=Application
Categories=foss4g-workshop;
EOF

chmod +x /usr/share/applications/qgis.desktop
