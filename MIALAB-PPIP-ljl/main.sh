#!/bin/sh
main_dir=`pwd`
nohup bash extract_features.sh &
cd $main_dir
nohup bash classify_features_by_chain.sh &
cd $main_dir
nohup bash extract_surface.sh &
cd $main_dir
nohup bash classify_surface_by_chain.sh
