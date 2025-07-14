apt install -y make cmake g++ build-essential
useradd -m -s /bin/bash lubuntu
su - lubuntu

curl -L micro.mamba.pm/install.sh | bash -s -- -b

source .bashrc

micromamba create -n geo_env python=3.11 numpy geopandas pdal python-pdal laspy tiledb-py pyarrow wxpython ipykernel jupyterlab notebook matplotlib scikit-learn scikit-image lonboard whitebox -c conda-forge -y
micromamba run -n geo_env pip install pybabylonjs
micromamba run -n geo_env pip install whitebox-workflows

micromamba run -n geo_env pip install pypotree

micromamba activate geo_env

micromamba install qgis=3.42.3 # we didn't use 3.44 because some pdal packages we initially installed were incompatible

python -m ipykernel install --user --name geo_env --display-name "Python FOSS4G Workshop (geo_env)"

cat << EOF >> /home/lubuntu/.bashrc
micromamba activate geo_env
EOF

micromamba activate

exit
