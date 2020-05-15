#!/bin/sh
main_directory=`pwd`

rm -rvf ./results
bash extract_features.sh
cd $main_directory
rm -rvf bad_data
rm -rvf workspace
rm -rvf ./data/chain ./data/propka ./data/res_surface ./data/rsa
rm -rvf ./results/features_by_pair

