apt install -y build-essential cmake git libgdal-dev \
                 libeigen3-dev libpng-dev \
                 libsqlite3-dev libboost-all-dev \
                 qt5-qmake qtbase5-dev qtchooser \
                 libproj-dev libz-dev libxerces-c-dev \
                 libassimp-dev libsqlite3-dev \
                 libfreetype6-dev liblaszip-dev \
                 libqt5svg5-dev libqt5opengl5-dev qttools5-dev qttools5-dev-tools libqt5websockets5-dev


cd /opt
git clone --recursive https://github.com/cloudcompare/CloudCompare.git
cd CloudCompare

git checkout v2.13.2
git submodule update --init --recursive

mkdir build && cd build

# make with GDAL support and LAZ/LAS file support
cmake .. -DOPTION_USE_GDAL=ON -DCMAKE_BUILD_TYPE=Release -DPLUGIN_IO_QLAS=ON -DPLUGIN_STANDARD_QCSF=ON
cmake --build . --parallel $(nproc)

make install

install -Dm644 /opt/CloudCompare/qCC/images/icon/cc_icon.svg /usr/share/icons/hicolor/scalable/apps/cloudcompare.svg

cd /opt
rm -rf CloudCompare