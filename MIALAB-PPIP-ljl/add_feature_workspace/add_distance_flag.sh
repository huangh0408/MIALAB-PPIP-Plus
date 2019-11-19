#!/bin/sh
#mkdir distance_flag
for l in $(ls ../results/features_by_pair);do
	pdb_name=`echo $l|cut -d '_' -f 1`
        for i in $(cat ./chain/${pdb_name}_chain.txt);do
                for j in $(cat ./chain/${pdb_name}_chain.txt);do
                        if [[ "$i" < "$j" ]];then
                                cat ./output_result/${pdb_name}_${i}_${j}_temp.txt >>./distance_flag/${pdb_name}_flag.txt
                        fi
                done
        done
	a=$(awk 'END{print NR}' ../results/features_by_pair/$l)
	b=$(awk 'END{print NR}' ./distance_flag/${pdb_name}_flag.txt)
	if [[ $a -eq $b ]];then
		paste ../results/features_by_pair/$l ./distance_flag/${pdb_name}_flag.txt >./features_by_pair_new/$l
	fi
done

