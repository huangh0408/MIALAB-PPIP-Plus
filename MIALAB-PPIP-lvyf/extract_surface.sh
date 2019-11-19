#!/bin/sh
main_directory=`pwd`
mkdir workspace2
mkdir surface
cd workspace2
for i in $(ls $main_directory/data/rsa);do
        dir_rsa_file="$main_directory/data/rsa/$i"
        t="$dir_rsa_file"
        num=$(awk 'END{print NR}' $t)
        rank=$(awk '/single/ {print NR}' $t)
        temp=`echo $i|cut -d '.' -f 1`
#        awk 'NR=='$rank+1',NR=='$num-2' {print $3}' $t >${temp}_chain.txt
	h=0
        for k in $(cat $main_directory/data/chain/${i}_chain.txt);do
		awk '$1=="ATOM"&&$5=="'"$k"'"{print $0}' $main_directory/data/pdb/${temp}.pdb >${temp}_chain_${k}.pdb
		naccess ${temp}_chain_${k}.pdb
		num1=$(awk 'END{print NR}' ${temp}_chain_${k}.rsa)
		num2=$(echo "$num1-2"|bc)
		area1=$(awk 'NR=='$num2' {print $4}' ${temp}_chain_${k}.rsa)
		echo $k $area1 >>${temp}_surface_each_chain.txt
		h=$((h+1))
		echo $h >>${temp}_chain_number.txt
			
#                awk '$3=="'"$k"'"{print}' $t >${temp}_${k}_.txt
#                sed -i '/CHAIN/d' ${temp}_${k}_.txt
#                awk -vOFS='\t' '{NF=4}1' ${temp}_${k}_.txt >${temp}_${k}.txt
#               rm -f ${temp}_${k}_.txt
        done
	
	for s in $(cat ${temp}_chain_number.txt);do
		hhh=$(awk 'END{print NR}' ${temp}_chain_number.txt)
		num3=$(echo "$num+$s-$hhh-2"|bc)
		area2=$(awk 'NR=='$num3' {print $4}' $t)
		chain=$(awk 'NR=='$num3' {print $3}' $t)
		echo $chain $area2 >>${temp}_surface_all_chain.txt
	done
	for j in $(cat $main_directory/data/chain/${i}_chain.txt);do
                for l in $(cat $main_directory/data/chain/${i}_chain.txt);do
                        if [[ "$j" < "$l" ]];then
				cat ${temp}_chain_${j}.pdb >${temp}_chain_${j}_${l}.pdb
				cat ${temp}_chain_${l}.pdb >>${temp}_chain_${j}_${l}.pdb
				naccess ${temp}_chain_${j}_${l}.pdb
		                num1=$(awk 'END{print NR}' ${temp}_chain_${j}_${l}.rsa)
		                num2=$(echo "$num1-2"|bc)
				num3=$(echo "$num2-1"|bc)
		                area1=$(awk 'NR=='$num3' {print $4}' ${temp}_chain_${j}_${l}.rsa)
				area2=$(awk 'NR=='$num2' {print $4}' ${temp}_chain_${j}_${l}.rsa)
		                echo $j $l $area1 $area2 >>${temp}_surface_two_chain.txt

			fi
		done
	done
	cp ${temp}_surface_two_chain.txt ../surface
	cp ${temp}_surface_each_chain.txt ../surface
	for j in $(cat $main_directory/data/chain/${i}_chain.txt);do
                for l in $(cat $main_directory/data/chain/${i}_chain.txt);do
                        if [[ "$j" < "$l" ]];then
#				s1=$(awk '$1=="'"$j"'"{print $2}' ${temp}_surface_all_chain.txt)
#				s2=$(awk '$1=="'"$l"'"{print $2}' ${temp}_surface_all_chain.txt)
				s1=$(awk '$1=="'"$j"'"&&$2=="'"$l"'"{print $3}' ${temp}_surface_two_chain.txt)
				s2=$(awk '$1=="'"$j"'"&&$2=="'"$l"'"{print $4}' ${temp}_surface_two_chain.txt)
				s3=$(awk '$1=="'"$j"'"{print $2}' ${temp}_surface_each_chain.txt)
				s4=$(awk '$1=="'"$l"'"{print $2}' ${temp}_surface_each_chain.txt)
				surface=$(echo "$s3+$s4-$s1-$s2"|bc)
				echo $j $l $surface >>../surface/${temp}_surface.txt	
#				cp ${temp}_surface_two_chain.txt /home/huangh/data_for_ww/surface_of_pdb_reg_new/
			fi
		done	
	done

done
