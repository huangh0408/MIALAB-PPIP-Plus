#!/bin/sh

#for i in $(cat pdb_list_3);do
#	cp ../pdb_3_4_5/${i}* ../data_3_jiale
#done
for l in $(ls ./features_by_pair_new);do
        pdb_name=`echo $l|cut -d '_' -f 1`
	echo $pdb_name >>pdb_list
done

