apt update -y && apt upgrade -y
DEBIAN_FRONTEND=noninteractive apt install -y ca-certificates curl software-properties-common xfce4 xfce4-goodies tightvncserver

# Docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update -y
apt install docker-ce -y


# Bitbucket install
git clone https://github.com/stephen-snyk/snyk-box.git /tmp/snyk-box
cd /tmp/snyk-box/
docker build bitbucket/ -t bitbucket:ssl
docker run --name="bitbucket" -d -p 443:443 bitbucket:ssl

docker run -d --restart=always \
           -p 8000:8000 \
           -e BROKER_TOKEN="${snyk_broker_token}" \
           -e BITBUCKET_USERNAME="${bitbucket_username}" \
           -e BITBUCKET_PASSWORD="${bitbucket_password}" \
           -e BITBUCKET=${pub_ip}:443 \
           -e BITBUCKET_API=`hostname -i`:443/rest/api/1.0 \
           -e PORT=8000 \
           -e BROKER_CLIENT_URL=http://localhost:8000 \
           -e ACCEPT_IAC=tf,yaml,yml,json,tpl \
           -e ACCEPT_CODE=true \
           -e NODE_TLS_REJECT_UNAUTHORIZED=0 \
       snyk/broker:bitbucket-server
EOF

# Cloudflared install
wget -O /root/cloudflared-linux-amd64.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i /root/cloudflared-linux-amd64.deb
mkdir ~/.cloudflared
touch ~/.cloudflared/cert.json
touch ~/.cloudflared/config.yml
cat > ~/.cloudflared/cert.json << "EOF"
{
    "AccountTag"   : "${account}",
    "TunnelID"     : "${tunnel_id}",
    "TunnelName"   : "${tunnel_name}",
    "TunnelSecret" : "${secret}"
}
EOF
cat > ~/.cloudflared/config.yml << "EOF"
tunnel: ${tunnel_id}
credentials-file: /etc/cloudflared/cert.json
logfile: /var/log/cloudflared.log
loglevel: info
EOF

cat > ~/.vnc/xstartup << "EOF"
startxfce4
EOF

sudo cloudflared service install
sudo cp -via ~/.cloudflared/cert.json /etc/cloudflared/
cd /tmp
sudo service cloudflared start
sudo vncserver
