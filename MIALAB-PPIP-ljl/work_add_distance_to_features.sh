#!/bin/sh
HOME_DIR=`pwd`
rm -r bad_data
rm -r workspace
rm -r results
bash extract_features.sh
cd $HOME_DIR
cd add_feature_workspace
bash work_9_27.sh
cd $HOME_DIR
cp -r ./add_feature_workspace/features_by_pair_new ./results
cp ./add_feature_workspace/pdb_list ./

