cd /opt
wget https://github.com/PDAL/PDAL/releases/download/2.8.4/PDAL-2.8.4-src.tar.gz
apt install -y     build-essential     cmake     g++     git     libboost-all-dev     libgdal-dev     libgeos-dev     libproj-dev     libtiff-dev     libcurl4-openssl-dev
tar xvf PDAL-2.8.4-src.tar.gz 
cd PDAL-2.8.4-src
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
make -j$(nproc)
make install

cd /opt
rm -rf PDAL-2.8.4-src.tar.gz