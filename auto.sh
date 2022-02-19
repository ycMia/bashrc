#!/bin/bash

rm -f ./.bashrc
cp ~/.bashrc ./.bashrc
datreq=`date`
git add .
git commit -m "Edited $datreq"
git push github master

