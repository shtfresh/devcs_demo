#!/bin/bash

echo ">>>Start psm version...<<<"
psm -v
echo ">>>End psm version...<<<"


sudo -s
echo ">>>Start who am i ...<<<"
who
echo ">>>End who am i ...<<<"


echo -e "cloud.admin\ngReEDy@1Blow\ngReEDy@1Blow\ngse00002265\nemea\nshort" | psm setup

psm update

echo ">>>Start psm version...<<<"
psm -v
echo ">>>End psm version...<<<"