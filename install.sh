#!/bin/bash

echo "[+] Installing Go tools..."

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/alterx/cmd/alterx@latest
go install github.com/owasp-amass/amass/v4/...@master

echo "[+] Done. Add Go bin to PATH"
