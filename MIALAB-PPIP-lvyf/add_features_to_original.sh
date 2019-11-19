#!/bin/sh

main_directory=`pwd`
pdb_dir="$main_directory/data/pdb"
rsa_dir="$main_directory/data/rsa"
propka_dir="$main_directory/data/propka"
res_surface_dir="$main_directory/data/res_surface"

#create directory: workspace
cd $main_directory
mkdir workspace
mkdir bad_data

#create subdirectory
cd data
mkdir rsa
mkdir propka
mkdir res_surface
mkdir chain
cd -
cd workspace

#create files: rsa

for i  in $(ls $pdb_dir);do
        temp=$(echo ${i%.*})
        naccess $pdb_dir/$i
#	mv complex.rsa ${temp}.rsa
        cp ${temp}.rsa $rsa_dir
done

#create files: chain, pdb

for i in $(ls $rsa_dir);do
	temp=$(echo ${i%.*})
        dir_rsa_file="$rsa_dir/$i"
        t="$dir_rsa_file"
        num=$(awk 'END{print NR}' $t)
	if [ 3 -gt $num ];then
		rm -f $t
		continue
	fi
	
        rank=$(awk '/single/ {print NR}' $t)
        awk 'NR=='$rank+1',NR=='$num-2' {print $3}' $t >${i}_chain.txt
	if [ -s ${i}_chain.txt ];then
		for chain in $(ls ${i}_chain.txt);do
			case "$chain" in
                        	[A-Z])
                        	value=1
#                       		;;
#				[1-9])
#				sed -i "s/1/X/" ${i}_chain.txt
	#			cd $pdb_dir
         #                       sed -i '/END/d' $pdb_dir/${temp}.pdb
          #                      mv ${temp}.pdb ${temp}_temp.pdb
           #                     awk '{$5="X";print}' ${temp}_temp.pdb >${temp}.pdb
	#			rm -f ${temp}_temp.pdb
         #                       cd -
				;;
                	        *)
        	   		sed -i "s/1/X/" ${i}_chain.txt 
				sed -i "s/_/X/" ${i}_chain.txt
	#			cd $pdb_dir
	#			sed -i '/END/d' $pdb_dir/${temp}.pdb
	#			mv ${temp}.pdb ${temp}_temp.pdb
	#			awk '{$5="X "$5;print}' ${temp}_temp.pdb >${temp}.pdb
	#			rm -f ${temp}_temp.pdb
	#			cd -
	                esac
		done
	else
		echo X >${i}_chain.txt
	#	cd $pdb_dir
         #       sed -i '/END/d' $pdb_dir/${temp}.pdb
          #      mv ${temp}.pdb ${temp}_temp.pdb
           #     awk '{$5="X "$5;print}' ${temp}_temp.pdb >${temp}.pdb
	#	rm -f ${temp}_temp.pdb
         #       cd -
	fi			
	cp ${i}_chain.txt $main_directory/data/chain	
done

#amend files: rsa
cd $main_directory/data/rsa
for i in $(ls $rsa_dir);do
	sed -i '/REM/d' $i
	sed -i '/END/d' $i
	sed -i '/CHAIN/d' $i
	sed -i '/TOTAL/d' $i
	chain_temp=$(awk 'NR==1{print $3}' $i)
	case "$chain_temp" in
        	[A-Z])
                value=1
                ;;
#		[_])
#		mv $i ${i}_temp
 #               awk '{$3="X_"$3;print}' ${i}_temp >$i 
  #              rm -f ${i}_temp
#		;;
                *)
 #               chain_temp=X
		mv $i ${i}_temp
		awk '{print NF}' ${i}_temp >temp.txt
		NF=$(sed '/^$/d' temp.txt|awk 'NR==1{max=$1;next}{max=max>$1?max:$1}END{print max}')
		if [ $NF -gt 11 ];then
			awk '{$3="X";print}' ${i}_temp >$i 
		else
			awk '{$3="X "$3;print}' ${i}_temp >$i
		fi
		rm -f ${i}_temp
		rm -f temp.txt
        esac
done

cd -
#create files: propka

for i in $(ls $pdb_dir);do
	temp=$(echo ${i%.*})
	propka31.py $pdb_dir/$i
	column_first=$(awk '/SUMMARY OF THIS PREDICTION/{print NR}' ${temp}.pka)
        column_first=`expr $column_first + 1`
        column_end=$(awk '/(using neutral reference)/{print NR}' ${temp}.pka)
        column_end=`expr $column_end - 1`
        column_sum=`expr $column_end-$column_first`
        sed -n ''$column_first','$column_end'p' ${temp}.pka >${temp}__.pka
	sed -i '/Group/d' ${temp}__.pka
	sed -i '/-/d' ${temp}__.pka
	chain_temp=$(awk 'NR==1{print $3}' ${temp}__.pka)
	rm ${temp}.pka
	mv ${temp}__.pka ${temp}.pka
        case $chain_temp in
                [A-Z])
                cp ${temp}.pka $propka_dir
                ;;
                *)
                chain_temp=X
                mv ${temp}.pka ${temp}_temp.pka
                awk '{$3="X";print}' ${temp}_temp.pka >$propka_dir/${temp}.pka
                rm -f ${temp}_temp.pka
        esac

done

#create files: pdb amend


#create files:res_surface 


for i in $(ls $rsa_dir);do
	cp $main_directory/data/chain/${i}_chain.txt >workspace
        temp=$(echo ${i%.*})
        for k in $(cat ${i}_chain.txt);do
		if [ "$k" = "X" ];then
			awk '{print}' $rsa_dir/$i >${i}_${k}_.txt
                	awk -vOFS='\t' '{NF=6}1' ${i}_${k}_.txt >${i}_${k}_h_h_h.txt
                	sum=$(awk 'END{print NR}' ${i}_${k}_h_h_h.txt)
                	awk '$1=="ATOM"{print}' $pdb_dir/${temp}.pdb >${temp}_${k}.pdb
                	awk '{print $4}' ${i}_${k}_h_h_h.txt >${i}_${k}_list.txt
                	for e in $(cat ${i}_${k}_list.txt);do
				awk '{print NF}' ${temp}_${k}.pdb >temp.txt
                		col_temp=$(sed '/^$/d' temp.txt|awk 'NR==1{max=$1;next}{max=max>$1?max:$1}END{print max}')
				rm -f temp.txt
				if [ -n "`echo $e|sed 's/[0-9]//g'`" ];then
					echo $temp $main_directory/bad_data/bad_data.txt
					continue 3
				else
					value=1
				fi
#				case "$e" in
#					[1-9])
#					value=1
#					;;
#					*)
#					cd $rsa_dir
#					temp_hh=`echo $i|cut -d '_' -f 1`
#					mv $i $main_directory/bad_data/rsa
#					echo $temp $main_directory/bad_data/bad_data.txt
#					cd -
#					continue 3
#				esac
				if [ $col_temp -gt 11 ];then
	                        	awk '$6=="'"$e"'"{print}' ${temp}_${k}.pdb >temp.pdb
        	                	naccess temp.pdb
                	        	ressurface=$(awk '{sum += $10};END {print sum}' temp.asa)
				else
                                        awk '$5=="'"$e"'"{print}' ${temp}_${k}.pdb >temp.pdb
                                        naccess temp.pdb
                                        ressurface=$(awk '{sum += $9};END {print sum}' temp.asa)
					
				fi
                        	echo $ressurface >>${i}_${k}_h_h.txt
                        	rm -f temp.asa
                        	rm -f temp.rsa
                        	rm -f temp.log
                        	rm -f temp.pdb
                	done
		else
            		awk '$3=="'"$k"'"{print}' $rsa_dir/$i >${i}_${k}_.txt
                	awk -vOFS='\t' '{NF=6}1' ${i}_${k}_.txt >${i}_${k}_h_h_h.txt
                	sum=$(awk 'END{print NR}' ${i}_${k}_h_h_h.txt)
                	awk '$1=="ATOM"&&$5=="'"$k"'"{print}' $pdb_dir/${temp}.pdb >${temp}_${k}.pdb
                	awk '{print $4}' ${i}_${k}_h_h_h.txt >${i}_${k}_list.txt
                	for e in $(cat ${i}_${k}_list.txt);do
                        	awk '$6=="'"$e"'"&&$5=="'"$k"'"{print}' ${temp}_${k}.pdb >temp.pdb
                        	naccess temp.pdb
                        	ressurface=$(awk '{sum += $10};END {print sum}' temp.asa)
                        	echo $ressurface >>${i}_${k}_h_h.txt
                        	rm -f temp.asa
                        	rm -f temp.rsa
                        	rm -f temp.log
                        	rm -f temp.pdb
                	done
		fi
                paste ${i}_${k}_h_h_h.txt ${i}_${k}_h_h.txt >${i}_${k}_h.txt
                cp ${i}_${k}_h.txt $res_surface_dir
        done
done

#######216

cd $main_directory
#main_directory=`pwd`
pdb_dir="$main_directory/data/pdb"
rsa_dir="$main_directory/data/rsa"
propka_dir="$main_directory/data/propka"
res_surface_dir="$main_directory/data/res_surface"

#create directory: workspace, results
rm -rvf workspace
mkdir workspace
mkdir results
cd results
mkdir features_by_chain
mkdir features_by_pair

#combinate two chains
for i in $(ls $rsa_dir);do
	dir_rsa_file="$rsa_dir/$i"
	t="$dir_rsa_file"
	num=$(awk 'END{print NR}' $t)
	rank=$(awk '/single/ {print NR}' $t)

#find chain of pdb
#create features: absEA, relEA
#features dimension: 2
#	awk 'NR=='$rank+1',NR=='$num-2' {print $3}' $t >${i}_chain.txt
	temp=$(echo ${i%.*})
	for k in $(cat $main_directory/data/chain/${i}_chain.txt);do
		cd $res_surface_dir
		case "$k" in
                	[A-Z])
                	value=1
                        ;;
                        *)
                        continue 
                esac
		if [ -f "${i}_${k}_h.txt" ];then
			sum=$(awk 'END{print NR}' ${i}_${k}_h.txt)
		else
			continue 2
		fi
		if [ 1 -gt $sum ];then
			continue 2
		fi
		cp $res_surface_dir/${i}_${k}_h.txt $main_directory/workspace
		cd $main_directory/workspace
		awk '$3=="'"$k"'"{print}' $propka_dir/${temp}.pka >${temp}_${k}.pka
		sumh=$(awk 'END{print NR}' ${temp}_${k}.pka)

#create feature:propka 
#features dimension: 2
		for((e=1;e<=sum;e++));do
			echo 0 0 >>${temp}_${k}_pka.txt
		done        
		for((w=1;w<=sumh;w++));do
			tempcol=$(awk 'NR=='$w'{print $2}' ${temp}_${k}.pka)
			tempres=$(awk 'NR=='$w'{print $1}' ${temp}_${k}.pka)
			zifu_res=`echo "$tempres"|wc -m`
			tempnum=$(awk 'NR=='$w'{print $4,$5}' ${temp}_${k}.pka)
			changecol=$(awk 'NR==1{print $4}' ${i}_${k}_h.txt)
			changecol_1=$(awk 'NR==1{print $3}' ${i}_${k}_h.txt)
			case "$changecol_1" in
				[A-Z])
				gyw=1
				;;
				*)
				continue 3
			esac
			if [ -n "`echo $changecol|sed 's/[0-9]//g'`" ];then
				continue 3
			fi 
			if [ 0 -gt $changecol ];then
                                continue 3
                        fi
			if [ -n "`echo $tempcol|sed 's/[0-9]//g'`" ];then
                        	continue 3
	                fi
			maxnum=$[ $sum+$changecol ]
			if [ $maxnum -gt $tempcol ];then
				if [ $zifu_res -gt 3 ];then
					objcol=$[ $tempcol-$changecol+1 ]
					changenum=$(awk 'NR=='$objcol'{print $2,$3}' ${temp}_${k}_pka.txt)
					sed -i "${objcol}s/0 0/$tempnum/" ${temp}_${k}_pka.txt
				fi
			fi
		done

#create feature: hydro
#features dimension: 2
		awk '{print $2}' ${i}_${k}_h.txt >${i}_${k}_amino_acid.txt
		for s in $(cat ${i}_${k}_amino_acid.txt);do
			awk '$1=="'"$s"'"{print}' $main_directory/hydro.txt >>${i}_${k}_hydro_.txt
		done
		awk '{print $2,$3}' ${i}_${k}_hydro_.txt >${i}_${k}_hydro.txt
		paste ${i}_${k}_h.txt ${i}_${k}_hydro.txt >${i}_${k}__.txt
		paste ${i}_${k}__.txt ${temp}_${k}_pka.txt >${i}_${k}.txt
		rm -f ${i}_${k}_.txt
		rm -f ${i}_${k}_hydro_.txt
		rm -f ${i}_${k}_amino_acid.txt
		rm -f ${i}_${k}__.txt


#create features: EC，EV，IC
#features dimension: 3
		Qcontacts -i $pdb_dir/${temp}.pdb -prefOut ${prefOut}${temp}_${k}_${k} -c1 $k -c2 $k
		sumhhh=$(awk 'END{print NR}' ${temp}_${k}_${k}-by-res.vor)
		awk '{print $6}' ${temp}_${k}_${k}-by-res.vor >${temp}_${k}_${k}-unique1.txt
		sort ${temp}_${k}_${k}-unique1.txt |uniq -c >${temp}_${k}_${k}-unique2.txt
		awk '{print $2}' ${temp}_${k}_${k}-unique2.txt >${temp}_${k}_${k}-unique.txt
		sumhhhh=$(awk 'END{print NR}' ${temp}_${k}_${k}-unique.txt)
		for((u=1;u<=sum;u++));do
        		echo 0 0 0 >>${temp}_${k}_${k}_EC_IC_EV.txt
	        done
		for((w=1;w<=sumhhhh;w++));do
			col=$(awk 'NR=='$w'{print $1}' ${temp}_${k}_${k}-unique.txt)
			changecol=$(awk 'NR==1{print $4}' ${i}_${k}.txt)
			objcol=$(echo "$col-$changecol+1"|bc)
                	absEA=$(awk 'NR=='$objcol'{print $5}' ${i}_${k}_h.txt)
			ressurface=$(awk 'NR=='$objcol'{print $7}' ${i}_${k}_h.txt)
			awk '$6=="'"$col"'"{print}' ${temp}_${k}_${k}-by-res.vor >${temp}_${k}_${k}_${col}.txt
			IC=$(awk '$2=='$col'{print $9}' ${temp}_${k}_${k}_${col}.txt)
			EC1=$(awk '{sum += $9};END {print sum}' ${temp}_${k}_${k}_${col}.txt)
			EC=$(echo "$EC1-$IC"|bc)
                	EV=$(echo "$ressurface-$EC-$absEA"|bc)
			sed -i "${objcol}s/0 0 0/$EC $IC $EV/" ${temp}_${k}_${k}_EC_IC_EV.txt
			rm -f ${temp}_${k}_${k}_${col}.txt
		done

		paste ${i}_${k}.txt ${temp}_${k}_${k}_EC_IC_EV.txt >${temp}_${k}_lvyf.txt
		paste ${temp}_${k}_lvyf.txt $main_directory/santi_new_features/${temp}_${k}.fasta.txt >${temp}_${k}.txt
		cp ${temp}_${k}.txt $main_directory/results/features_by_chain
		rm -f ${temp}_${k}_lvyf.txt
		rm -f ${temp}_${k}_.txt
		rm -f ${temp}_${k}_${k}-by-res.vor
		rm -f ${temp}_${k}_${k}-by-atom.vor
		

	done
	echo "$i features is ready"

#combination two chains
	for j in $(cat $main_directory/data/chain/${i}_chain.txt);do
		case "$j" in
                        [A-Z])
                        value=1
                        ;;
                        *)
                        continue
                esac
		for l in $(cat $main_directory/data/chain/${i}_chain.txt);do
			case "$l" in
                        	[A-Z])
                        	value=1
                        	;;
                        	*)
                        	continue
                	esac
			if [[ "$j" < "$l" ]];then
				temp1=$(awk 'END{print NR}' ${temp}_${l}.txt)
				temp2=$(awk 'END{print NR}' ${temp}_${j}.txt)
				echo $temp1
				echo $temp2
				awk '{for(s=1;s<='"$temp1"';s++)print}' ${temp}_${j}.txt >${temp}_${j}_1.txt
				for(( q=1;q<=$temp2;q++));do
					cat ${temp}_${l}.txt >>${temp}_${l}_1.txt
				done
				paste ${temp}_${j}_1.txt ${temp}_${l}_1.txt >${temp}_${j}_${l}_.txt
				sumjl=$(awk 'END{print NR}' ${temp}_${j}_${l}_.txt)
#create flag
				Qcontacts -i $pdb_dir/${temp}.pdb -prefOut ${prefOut}${temp}_${j}_${l} -c1 $j -c2 $l
				for((e=1;e<=sumjl;e++));do
        	        		echo 0 >>${temp}_${j}_${l}_flag.txt
			        done
				sumflag=$(awk 'END{print NR}' ${temp}_${j}_${l}-by-res.vor)
				for((n=1;n<=sumflag;n++));do
					flagcol_j=$(awk 'NR=='$n'{print $2}' ${temp}_${j}_${l}-by-res.vor)
					flagcol_l=$(awk 'NR=='$n'{print $6}' ${temp}_${j}_${l}-by-res.vor)
					changecol_jl=$(awk '$4=="'"$flagcol_j"'"&&$106=="'"$flagcol_l"'"{print NR}' ${temp}_${j}_${l}_.txt)
					echo $changecol_jl >>${temp}_${j}_${l}_hh.txt
					sed -i "${changecol_jl}s/0/1/" ${temp}_${j}_${l}_flag.txt
				done
				paste ${temp}_${j}_${l}_.txt ${temp}_${j}_${l}_flag.txt >${temp}_${j}_${l}_hr.txt
				sed -i "s/RES/$temp/" ${temp}_${j}_${l}_hr.txt
				sed 's/[[:space:]][[:space:]]*/ /g' ${temp}_${j}_${l}_hr.txt >${temp}_${j}_${l}.txt
				rm -f ${temp}_${j}_${l}_hr.txt
#				awk '{print $1,$3,$17,$2,$16,$4,$18,$5,$6,$12,$14,$13,$8,$9,$10,$11,$19,$20,$26,$28,$27,$22,$23,$24,$25,$29}' ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output.txt
				awk '{print $1,$3,$32,$2,$31,$4,$33,$5,$6,$12,$14,$13,$8,$9,$10,$11}' ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output_1.txt
	#			awk 'for(i=1;i<113;i++){print $i}' ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output_2.txt
				cut -d ' ' -f 15-29 ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output_2.txt
				awk '{print $34,$35,$41,$43,$42,$37,$38,$39,$40}' ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output_3.txt
#				awk 'for(i=117;i<=NF;i++){print $i}' ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output_4.txt
				cut -d ' ' -f 44- ${temp}_${j}_${l}.txt >${temp}_${j}_${l}_output_4.txt
				paste ${temp}_${j}_${l}_output_1.txt ${temp}_${j}_${l}_output_2.txt >${temp}_${j}_${l}_output_1_2.txt
				paste ${temp}_${j}_${l}_output_1_2.txt ${temp}_${j}_${l}_output_3.txt >${temp}_${j}_${l}_output_1_2_3.txt
				paste ${temp}_${j}_${l}_output_1_2_3.txt ${temp}_${j}_${l}_output_4.txt >${temp}_${j}_${l}_output.txt
				rm -f ${temp}_${j}_${l}_output_1.txt
				rm -f ${temp}_${j}_${l}_output_1_2.txt
				rm -f ${temp}_${j}_${l}_output_1_2_3.txt
				rm -f ${temp}_${j}_${l}_output_2.txt
				rm -f ${temp}_${j}_${l}_output_3.txt
				rm -f ${temp}_${j}_${l}_output_4.txt
	#			rm -f ${temp}_${j}_${l}.txt
				cat ${temp}_${j}_${l}_output.txt >>$main_directory/results/features_by_pair/${temp}_output.txt
				rm -f ${temp}_${j}_${l}_output.txt
				rm -f ${temp}_${j}_${l}-by-res.vor
				rm -f ${temp}_${j}_${l}-by-atom.vor
				rm -f ${temp}_${j}_${l}_.txt
				rm -f ${temp}_${j}_1.txt
				rm -f ${temp}_${l}_1.txt
				rm -f ${temp}_${j}_${l}.txt
			fi
		done
	done
	echo "$temp combination is ok"
done
						
	
	   
