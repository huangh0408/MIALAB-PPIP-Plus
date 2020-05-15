#!/bin/sh
main_dir=`pwd`
for i in $(cat pdb_list);do
	if [ -s $main_dir/surface/${i}_surface.txt ];then
		sum=$(awk 'END{print NR}' data/chain/${i}.rsa_chain.txt)
		if [ ! -d "$main_dir/surface_of_${sum}" ];then
                	mkdir surface_of_${sum}
	        else
        	        a=1
	        fi
		cp $main_dir/surface/${i}_surface_each_chain.txt surface_of_${sum}
		cp $main_dir/surface/${i}_surface_two_chain.txt surface_of_${sum}
		cp $main_dir/surface/${i}_surface.txt surface_of_${sum}
		echo $i >>pdb_list_new
	fi
done
