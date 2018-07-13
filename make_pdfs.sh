#!/bin/bash
# Title: Make PDFs from Markdown source for code.kx.com whitepapers
# Author: stephen@kx.com
# Version: 2018.07.13

# Java API
# ./whitepaper.sh -o java-api java/index.md
QHOME=~/q; 

# Query Routing: A kdb+ framework for a scalable, load balanced system
SRC=~/Projects/kx/code/q/docs/wp/query-routing;
$QHOME/m64/q filtr.q query-routing $SRC/index.md;
./whitepaper.sh $SRC/query-routing.md;

# Market Fragmentation
SRC=~/Projects/kx/code/q/docs/wp/market-fragmentation;
$QHOME/m64/q filtr.q market-fragmentation $SRC/index.md;
./whitepaper.sh $SRC/market-fragmentation.md;

# An introduction to graphical interfaces for kdb+ using C#
SRC=~/Projects/kx/code/q/docs/wp/gui;
$QHOME/m64/q filtr.q csharp-gui $SRC/index.md;
./whitepaper.sh $SRC/csharp-gui.md;

# Migrating a kdb+ HDB to AWS/EC2
SRC=~/Projects/kx/code/q/docs/cloud/aws;
$QHOME/m64/q filtr.q aws-ec2 $SRC/index.md \
  $SRC/in-house-vs-ec2.md \
  $SRC/historical-data-layouts.md \
  $SRC/data-locality.md \
  $SRC/getting-data-in.md \
  $SRC/security.md \
  $SRC/getting-data-out.md \
  $SRC/storing-hdb-in-s3.md \
  $SRC/disaster-recovery.md \
  $SRC/licensing.md \
  $SRC/encryption.md \
  $SRC/benchmarking.md \
  $SRC/observations.md \
  $SRC/network-configuration.md \
  $SRC/app-a-ebs.md \
  $SRC/app-b-efs-nfs.md \
  $SRC/app-c-asg.md \
  $SRC/app-d-mapr.md \
  $SRC/app-e-goofys.md \
  $SRC/app-f-s3fs.md \
  $SRC/app-g-s3ql.md \
  $SRC/app-h-objectivefs.md \
  $SRC/app-i-wekaio-matrix.md \
  $SRC/app-j-quobyte.md;
./whitepaper.sh $SRC/aws-ec2.md;

# Java API
SRC=~/Projects/kx/code/q/docs/wp/java-api;
$QHOME/m64/q filtr.q java-api $SRC/index.md \
	$SRC/api.md \
	$SRC/models.md \
	$SRC/examples.md \
	$SRC/connecting.md \
	$SRC/extracting-data.md \
	$SRC/data-objects.md \
	$SRC/reconnect.md \
	$SRC/tickerplant-overview.md \
	$SRC/tickerplant-subscribe.md \
	$SRC/tickerplant-publish.md \
	$SRC/connect-from-kdb.md \
	$SRC/conclusion.md;
./whitepaper.sh $SRC/java-api.md;

# Websockets
SRC=~/Projects/kx/code/q/docs/wp/websockets;
$QHOME/m64/q filtr.q websockets $SRC/index.md;
./whitepaper.sh $SRC/websockets.md;

# NLP Toolkit
SRC=~/Projects/kx/code/q/docs/ml/nlp;
$QHOME/m64/q filtr.q nlp-toolkit $SRC/index.md \
$SRC/feature-vectors.md \
$SRC/comparisons.md \
$SRC/clustering.md \
$SRC/finding-outliers.md \
$SRC/explaining-similarities.md \
$SRC/sentiment-analysis.md \
$SRC/mbox.md \
$SRC/parsing-emails.md \
$SRC/useful-functions.md;
./whitepaper.sh $SRC/nlp-toolkit.md;
