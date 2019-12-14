#!/bin/bash -e

echo "################################"
echo "Installing Shipyard to /usr/loca/bin"
echo ""
echo "Please note: You may be prompted for your password"
echo ""

# detect the OS version
os=$(uname)
binary="yard-darwin"
version="v0.0.0.alpha.1"
repo="https://github.com/shipyard-run/cli/releases/download/$version"

if [[ $os == "Linux" ]]; then
  binary="yard-linux"
fi

echo "Downloading $repo/$binary"
curl -L -s -o /tmp/yard "$repo/$binary"
sudo mv /tmp/yard /usr/local/bin
sudo chmod +x /usr/local/bin/yard