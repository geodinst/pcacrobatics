cd /opt

wget https://www.whiteboxgeo.com/WBT_Linux/WhiteboxTools_linux_amd64.zip
wget https://www.whiteboxgeo.com/GTE_Linux/GeneralToolsetExtension_linux_musl.zip

unzip WhiteboxTools_linux_amd64.zip
mv WhiteboxTools_linux_amd64/WBT /opt
unzip GeneralToolsetExtension_linux_musl.zip

rm /opt/WhiteboxTools_linux_amd64.zip
rm /opt/GeneralToolsetExtension_linux_musl.zip