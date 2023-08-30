go install github.com/ffuf/ffuf@latest
apt-get install shc
shc -f inside403.sh   
mv inside403.sh inside403
cp inside403 /usr/local/bin
cp inside403 /usr/bin
