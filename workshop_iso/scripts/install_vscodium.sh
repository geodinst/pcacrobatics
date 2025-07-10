cd /opt
mkdir VSCodium
cd VSCodium
wget https://github.com/VSCodium/vscodium/releases/download/1.101.14098/VSCodium-linux-x64-1.101.14098.tar.gz
tar xvf VSCodium-linux-x64-1.101.14098.tar.gz
rm VSCodium-linux-x64-1.101.14098.tar.gz

chown root:root /opt/VSCodium/chrome-sandbox
chmod 4755 /opt/VSCodium/chrome-sandbox

#cp -r ../.vscode-oss /home/lubuntu

mkdir -p /home/lubuntu/.config/VSCodium/User

cat << EOF > /home/lubuntu/.config/VSCodium/User/settings.json
{
  "python.defaultInterpreterPath": "/home/lubuntu/.local/bin/micromamba",
  "editor.minimap.enabled": false,
  "editor.stickyScroll.enabled": false,
  "security.workspace.trust.untrustedFiles": "open"
}
EOF

install -Dm644 /opt/VSCodium/resources/app/out/media/code-icon.svg /usr/share/icons/hicolor/scalable/apps/codium.svg