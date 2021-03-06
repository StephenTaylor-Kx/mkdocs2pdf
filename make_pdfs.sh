#!/bin/bash
# Title: Make PDFs from Markdown source for code.kx.com whitepapers
# Author: stephen@kx.com
# Version: 2019.03.09

QHOME=~/q;

# Lightning tickerplants
SRC=~/Projects/kx/code/v2/docs/wp/lightning-tickerplants;
$QHOME/m64/q filtr.q lightning $SRC/index.md;
./whitepaper.sh $SRC/lightning.md;

# # Working with sym files
# SRC=~/Projects/kx/code/v2/docs/wp/symfiles;
# $QHOME/m32/q filtr.q symfiles $SRC/index.md;
# ./whitepaper.sh $SRC/symfiles.md;

# Exoplanets
# SRC=~/Projects/kx/code/v1/docs/wp/exoplanets;
# $QHOME/m32/q filtr.q exoplanets $SRC/index.md;
# ./whitepaper.sh $SRC/exoplanets.md;

# # Bitcoin blockchains
# SRC=~/Projects/kx/code/v1/docs/wp/blockchain;
# $QHOME/m32/q filtr.q blockchain $SRC/index.md;
# ./whitepaper.sh $SRC/blockchain.md;

# SRC=~/Projects/kx/code/v1/docs/wp/space-weather;
# $QHOME/m32/q filtr.q space-weather $SRC/index.md;
# ./whitepaper.sh $SRC/space-weather.md;

# # embedPy and LASSO
# SRC=~/Projects/kx/code/q/docs/wp/embedpy-lasso;
# $QHOME/m64/q filtr.q embedpy-lasso $SRC/index.md \
#   $SRC/basics.md \
#   $SRC/lasso.md \
#   $SRC/clean.md \
#   $SRC/analysis.md \
#   $SRC/conclusion.md;
# ./whitepaper.sh $SRC/embedpy-lasso.md;

# # Neural networkss
# # FIXME problems with math notation
# SRC=~/Projects/kx/code/q/docs/wp/neural-networks;
# $QHOME/m64/q filtr.q neural-networks $SRC/index.md;
# ./whitepaper.sh $SRC/neural-networks.md;

# Signal processing
# SRC=~/Projects/kx/code/v2/docs//wp/signal-processing;
# $QHOME/m64/q filtr.q signal-processing $SRC/index.md;
# ./whitepaper.sh $SRC/signal-processing.md;

# Efficient use of unary operators
# SRC=~/Projects/kx/code/q/docs/wp/efficient-operators;
# $QHOME/m64/q filtr.q efficient-operators $SRC/index.md \
#   $SRC/distribution.md \
#   $SRC/progression.md \
#   $SRC/combinations.md \
#   $SRC/iteration.md \
#   $SRC/nested-columns.md \
#   $SRC/conclusion.md;
# ./whitepaper.sh $SRC/efficient-operators.md;

# # Multi-partitioned DBs
# SRC=~/Projects/kx/code/q/docs/wp/multi-partitioned-dbs;
# $QHOME/m64/q filtr.q multi-partitioned-dbs $SRC/index.md;
# ./whitepaper.sh $SRC/multi-partitioned-dbs.md;

# # Disaster recovery
# SRC=~/Projects/kx/code/q/docs/wp/disaster-recovery;
# $QHOME/m64/q filtr.q disaster-recovery $SRC/index.md;
# ./whitepaper.sh $SRC/disaster-recovery.md;

# # Data visualization
# SRC=~/Projects/kx/code/q/docs/wp/data-visualization;
# $QHOME/m64/q filtr.q data-visualization $SRC/index.md;
# ./whitepaper.sh $SRC/data-visualization.md;

# # An introduction to graphical interfaces for kdb+ using C#
# SRC=~/Projects/kx/code/q/docs/wp/gui;
# $QHOME/m64/q filtr.q csharp-gui $SRC/index.md;
# ./whitepaper.sh $SRC/csharp-gui.md;

# # Java API
# SRC=~/Projects/kx/code/q/docs/wp/java-api;
# $QHOME/m64/q filtr.q java-api $SRC/index.md \
#   $SRC/api.md \
#   $SRC/models.md \
#   $SRC/examples.md \
#   $SRC/connecting.md \
#   $SRC/extracting-data.md \
#   $SRC/data-objects.md \
#   $SRC/reconnect.md \
#   $SRC/tickerplant-overview.md \
#   $SRC/tickerplant-subscribe.md \
#   $SRC/tickerplant-publish.md \
#   $SRC/connect-from-kdb.md \
#   $SRC/conclusion.md;
# ./whitepaper.sh $SRC/java-api.md;

# # Market Fragmentation
# SRC=~/Projects/kx/code/q/docs/wp/market-fragmentation;
# $QHOME/m64/q filtr.q market-fragmentation $SRC/index.md;
# ./whitepaper.sh $SRC/market-fragmentation.md;

# # Migrating a kdb+ HDB to AWS/EC2
# SRC=~/Projects/kx/code/q/docs/cloud/aws;
# $QHOME/m64/q filtr.q aws-ec2 $SRC/index.md \
#   $SRC/in-house-vs-ec2.md \
#   $SRC/historical-data-layouts.md \
#   $SRC/data-locality.md \
#   $SRC/getting-data-in.md \
#   $SRC/security.md \
#   $SRC/getting-data-out.md \
#   $SRC/storing-hdb-in-s3.md \
#   $SRC/disaster-recovery.md \
#   $SRC/licensing.md \
#   $SRC/encryption.md \
#   $SRC/benchmarking.md \
#   $SRC/observations.md \
#   $SRC/network-configuration.md \
#   $SRC/app-a-ebs.md \
#   $SRC/app-b-efs-nfs.md \
#   $SRC/app-c-asg.md \
#   $SRC/app-d-mapr.md \
#   $SRC/app-e-goofys.md \
#   $SRC/app-f-s3fs.md \
#   $SRC/app-g-s3ql.md \
#   $SRC/app-h-objectivefs.md \
#   $SRC/app-i-wekaio-matrix.md \
#   $SRC/app-j-quobyte.md;
# ./whitepaper.sh $SRC/aws-ec2.md;

# # NLP Toolkit
# # SRC=~/Projects/kx/code/q/docs/ml/nlp;
# # $QHOME/m64/q filtr.q nlp-toolkit $SRC/index.md \
# # $SRC/feature-vectors.md \
# # $SRC/comparisons.md \
# # $SRC/clustering.md \
# # $SRC/finding-outliers.md \
# # $SRC/explaining-similarities.md \
# # $SRC/sentiment-analysis.md \
# # $SRC/mbox.md \
# # $SRC/parsing-emails.md \
# # $SRC/useful-functions.md;
# # ./whitepaper.sh $SRC/nlp-toolkit.md;

# # Query Routing: A kdb+ framework for a scalable, load balanced system
# SRC=~/Projects/kx/code/q/docs/wp/query-routing;
# $QHOME/m64/q filtr.q query-routing $SRC/index.md;
# ./whitepaper.sh $SRC/query-routing.md;

# # Websockets
# SRC=~/Projects/kx/code/q/docs/wp/websockets;
# $QHOME/m64/q filtr.q websockets $SRC/index.md;
# ./whitepaper.sh $SRC/websockets.md;

