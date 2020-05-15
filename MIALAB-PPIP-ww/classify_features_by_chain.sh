#!/bin/sh
main_dir=`pwd`
for i in $(ls data/chain);do
	sum=$(awk 'END{print NR}' data/chain/$i)
	if [ ! -d "$main_dir/features_of_${sum}" ];then
		mkdir features_of_${sum}
	else
		a=1
	fi
	temp=`echo $i|cut -d '.' -f 1`
	if [ -s $main_dir/results/features_by_pair/${temp}_output.txt ];then
		mv $main_dir/results/features_by_pair/${temp}_output.txt $main_dir/features_of_${sum}
		echo ${temp} >>pdb_list_${sum}
		echo ${temp} >>pdb_list
	fi
done
