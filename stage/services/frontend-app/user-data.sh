#!/bin/bash 
echo "Hostname: `hostname`" > index.html 
nohup busybox httpd -f -p "${server_port}" & 
EOF


