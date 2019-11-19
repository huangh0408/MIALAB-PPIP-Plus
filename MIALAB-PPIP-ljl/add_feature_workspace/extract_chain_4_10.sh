#!/bin/sh
#rm -r workspace
#rm -r result_contact_matrix
#rm -r chain
#mkdir workspace
#mkdir result_contact_matrix
#mkdir chain
cd workspace
mkdir temp_dir
for j in $(ls ../../data/pdb);do
	pdb_name=`echo $j|cut -d '.' -f 1`
	echo $pdb_name >>pdb_list.txt
	../Complex_Tool/Complex_Tool -i ../../data/pdb/$j -o ${pdb_name}.contact -m 1	
	mkdir ${pdb_name}_temp_dir
	mv *con ${pdb_name}_temp_dir
#	rm ${pdb_name}_temp_dir/${pdb_name}_chain.txt

	for k in $(ls ${pdb_name}_temp_dir);do
		len=`expr length $k`
		if [ $len -eq 11 ];then
			name=`echo $k|cut -d '.' -f 1`
			chain=$(echo ${name:6})
			echo $chain >>${pdb_name}_temp_dir/${pdb_name}_chain.txt
		fi
		if [ $len -eq 12 ];then
                        name=`echo $k|cut -d '.' -f 1`
                        chain=$(echo ${name:7})
                        echo $chain >>${pdb_name}_temp_dir/${pdb_name}_chain.txt
                fi
		if [ $len -eq 10 ];then
                        name=`echo $k|cut -d '.' -f 1`
                        chain=$(echo ${name:6})
                        echo $chain >>${pdb_name}_temp_dir/${pdb_name}_chain.txt
                fi
	done
	cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt |sort |uniq -d >${pdb_name}_temp_dir/${pdb_name}_chain_temp.txt
        cat ${pdb_name}_temp_dir/${pdb_name}_chain_temp.txt > ../chain/${pdb_name}_chain.txt
	for i in $(cat ../chain/${pdb_name}_chain.txt);do
		for j in $(cat ../chain/${pdb_name}_chain.txt);do
			if [[ "$i" < "$j" ]];then
				cat ${pdb_name}_temp_dir/${pdb_name}_${i}_${j}.con > ../result_contact_matrix/${pdb_name}_${i}_${j}_temp.contact_matrix
			fi
		done
	done
#	if [ -s ../chain/${pdb_name}_chain.txt ];then
#		awk '{print $1}' ../chain/${pdb_name}_chain.txt >temp_chain_1.txt
#		awk '{print $2}' ../chain/${pdb_name}_chain.txt >temp_chain_2.txt
#		s_chain=$(awk 'END{print NR}' temp_chain_1.txt)
#		for ((i=1;i <= s_chain;i++));do
#			chain_r=$(awk 'NR=="'"$i"'"{print $1}' temp_chain_1.txt)
#			chain_l=$(awk 'NR=="'"$i"'"{print $1}' temp_chain_2.txt)
#			/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}${chain_r}.con 8 > ../result_contact_matrix/${pdb_name}_${chain_r}_temp.contact_matrix
#			cat ${pdb_name}_temp_dir/${pdb_name}${chain_r}.con > ../result_contact_matrix/${pdb_name}_${chain_r}_temp.contact_matrix
#			/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}${chain_l}.con 8 > ../result_contact_matrix/${pdb_name}_${chain_l}_temp.contact_matrix
#			cat ${pdb_name}_temp_dir/${pdb_name}${chain_l}.con > ../result_contact_matrix/${pdb_name}_${chain_l}_temp.contact_matrix
#			cat ${pdb_name}_temp_dir/${pdb_name}_${chain_r}_${chain_l}.con > ../result_contact_matrix/${pdb_name}_${chain_r}_${chain_l}_temp.contact_matrix
#			/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}_${chain_r}_${chain_l}.con 8 > ../result_contact_matrix/${pdb_name}_${chain_r}_${chain_l}_temp.contact_matrix
#			cp ${pdb_name}_temp_dir/${pdb_name}${chain_r}.con ../result_contact_distance
#			cp ${pdb_name}_temp_dir/${pdb_name}${chain_l}.con ../result_contact_distance
#			cp ${pdb_name}_temp_dir/${pdb_name}_${chain_r}_${chain_l}.con ../result_contact_distance
#		done
#		for r in $(cat temp_chain_1.txt);do 
#	                /home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}${r}.con 8 > ${pdb_name}_${r}_temp.contact_matrix
 #       	        for l in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do
 #               	        if [ "$r" != "$l" ];then
 #                       	        /home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}_${r}_${l}.con 8 > ${pdb_name}_${r}_${l}_temp.contact_matrix
#	                        fi
 #       	        done
#		done
#	else
#		chain=$(echo ${name:4})
#		echo $chain >>${pdb_name}_temp_dir/${pdb_name}_chain.txt
#		/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/*.con 8 > ${pdb_name}_${r}_temp.contact_matrix
#	fi
#	rm -rvf ${pdb_name}_temp_dir
#	rm *contact
:<<!
	for r in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do 
		/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}${r}.con 8 > ${pdb_name}_${r}_temp.contact_matrix
		for l in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do
			if [ "$r" != "$l" ];then
				/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}_${r}_${l}.con 8 > ${pdb_name}_${r}_${l}_temp.contact_matrix
			fi
		done
	done
!
done
	
