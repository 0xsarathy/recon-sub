#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./recon.sh example.com"
  exit 1
fi

DOMAIN=$1
OUT="output/$DOMAIN"
mkdir -p $OUT

echo "[+] Running Subfinder..."
subfinder -d $DOMAIN -silent > $OUT/subfinder.txt

echo "[+] Running Assetfinder..."
assetfinder --subs-only $DOMAIN > $OUT/assetfinder.txt

echo "[+] Running Sublist3r..."
sublist3r -d $DOMAIN -o $OUT/sublist3r.txt >/dev/null 2>&1

echo "[+] Running Amass (passive)..."
amass enum -passive -d $DOMAIN -o $OUT/amass.txt

echo "[+] Fetching Certificate Transparency logs..."
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" \
| jq -r '.[].name_value' \
| sed 's/\*\.//' \
| sort -u > $OUT/crtsh.txt

echo "[+] Combining & deduplicating subdomains..."
cat $OUT/*.txt | sort -u > $OUT/all_subdomains.txt

echo "[+] Running AlterX permutations..."
cat $OUT/all_subdomains.txt | alterx > $OUT/alterx.txt

echo "[+] Running Wayback URLs..."
cat $OUT/all_subdomains.txt | waybackurls > $OUT/wayback.txt

echo "[+] Recon completed!"
echo "[+] Results saved in: $OUT/"
