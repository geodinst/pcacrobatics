apt install -y bison debhelper-compat dh-python doxygen fakeroot flex graphviz \
   libblas-dev libbz2-dev libcairo2-dev libfftw3-dev libfreetype6-dev \
   libgdal-dev libgeos-dev libgl1-mesa-dev libglu1-mesa-dev libjpeg-dev liblapack-dev libmotif-dev \
   default-libmysqlclient-dev libncurses5-dev libnetcdf-dev libpng-dev libpq-dev \
   libproj-dev libreadline-dev libsqlite3-dev libtiff-dev libxmu-dev libzstd-dev \
   netcdf-bin pkg-config proj-bin python3 python3-dev python3-numpy python3-pil python3-ply \
   python3-six python3-wxgtk4.0 wget unixodbc-dev zlib1g-dev liblapacke-dev libopenblas-dev pkg-config

cd /opt
git clone https://github.com/OSGeo/grass.git
cd grass

export CFLAGS="-Wall -Werror-implicit-function-declaration -fno-common -Wextra -Wunused"
export CXXFLAGS="-Wall"

./configure   --prefix=/usr/local   --with-gdal   --with-proj-share=/usr/share/proj --with-nls --with-readline   --with-cxx --enable-largefile   --with-freetype --with-freetype-includes=/usr/include/freetype2   --with-sqlite --with-cairo --with-geos   --with-netcdf --with-odbc=yes   --with-openmp=yes --with-pthread=no   --with-blas=yes   --with-lapack=yes --with-includes=/usr/include   --with-libs=/usr/lib   --with-pdal   --with-postgres=yes --with-postgres-includes="/usr/include/postgresql"

make -j$(nproc)
make install

cd /opt
rm -rf grass