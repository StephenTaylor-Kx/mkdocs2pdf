#!/bin/bash
# Title: Make PDFs from Markdown source for code.kx.com whitepapers
# Author: stephen@kx.com

# Java API
# ./whitepaper.sh -o java-api java/index.md
QHOME=~/q; 

$QHOME/m64/q filtr.q java-api java/index.md
./whitepaper.sh java/java-api.md

# Migrating a kdb+ HDB to AWS/EC2
# ./whitepaper.sh -o aws \
$QHOME/m64/q filtr.q aws-ec2 aws/index.md \
  aws/in-house-vs-ec2.md \
  aws/historical-data-layouts.md \
  aws/data-locality.md \
  aws/getting-data-in.md \
  aws/security.md \
  aws/getting-data-out.md \
  aws/storing-hdb-in-s3.md \
  aws/disaster-recovery.md \
  aws/licensing.md \
  aws/encryption.md \
  aws/benchmarking.md \
  aws/observations.md \
  aws/network-configuration.md \
  aws/app-a-ebs.md \
  aws/app-b-efs-nfs.md \
  aws/app-c-asg.md \
  aws/app-d-mapr.md \
  aws/app-e-goofys.md \
  aws/app-f-s3fs.md \
  aws/app-g-s3ql.md \
  aws/app-h-objectivefs.md \
  aws/app-i-wekaio-matrix.md \
  aws/app-j-quobyte.md 
./whitepaper.sh aws/aws-ec2.md

# Websockets
# ./whitepaper.sh -o websockets websockets/index.md
$QHOME/m64/q filtr.q websockets websockets/index.md
./whitepaper.sh websockets/websockets.md
