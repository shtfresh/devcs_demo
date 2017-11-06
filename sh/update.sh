#!/bin/bash

echo ">>>Start psm help...<<<"
psm help
echo ">>>End psm help...<<<"

echo ">>>Start psm version...<<<"
psm -v
echo ">>>End psm version...<<<"

echo ">>>Start psm setup1...<<<"
echo "cloud.admin\ngReEDy@1Blow\ngReEDy@1Blow\ngse00002265\nemea\nshort" | psm setup
echo ">>>Start psm setup2...<<<"
echo -e "cloud.admin\ngReEDy@1Blow\ngReEDy@1Blow\ngse00002265\nemea\nshort" | psm setup
echo ">>>Start psm setup3...<<<"

echo ">>>Start psm setup4...<<<"

echo ">>>End psm setup...<<<"

echo ">>>Start psm update...<<<"
psm update
echo ">>>End psm update...<<<"

echo ">>>Start psm help...<<<"
psm help
echo ">>>End psm help...<<<"

echo ">>>Start psm version...<<<"
psm -v
echo ">>>End psm version...<<<"