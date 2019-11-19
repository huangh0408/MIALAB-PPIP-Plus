#!/bin/sh
home_dir=`pwd`
rm -r workspace
rm -r result_contact_matrix
rm -r true_contact_matrix
rm -r output_result
rm -r features_by_pair_new
rm -r distance_flag
rm -r chain
rm pdb_list
mkdir workspace
mkdir result_contact_matrix
mkdir true_contact_matrix
mkdir output_result
mkdir features_by_pair_new
mkdir distance_flag
mkdir chain
bash extract_chain_4_10.sh
cd $home_dir
#matlab -nosplash -nodesktop -r delete_unuseful_col_row_4_10
matlab -nosplash -nodesktop -r delete_unuseful_col_row_8_25
#python concatenate_matrix_4_10.py
cd $home_dir
python matrix2list.py
cd $home_dir
bash add_distance_flag.sh
cd $home_dir
bash choose_pdb.sh
