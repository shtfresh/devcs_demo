#!/bin/bash

echo ">>>Start psm version...<<<"
psm -v
echo ">>>End psm version...<<<"


echo -e "cloud.admin\ngReEDy@1Blow\ngReEDy@1Blow\ngse00002265\nemea\nshort" | psm setup
psm update

echo ">>>Start psm version...<<<"
psm -v
echo ">>>End psm version...<<<"