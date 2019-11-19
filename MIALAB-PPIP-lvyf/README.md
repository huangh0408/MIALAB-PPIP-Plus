#This is the extracting features proccess for MIALAB-PPIP, which can compute features for the prediction of residue-residue interaction.


## Installation
	There is no installation needed, just make sure the following files is included:
	(1) extract_features.sh
	(2) hydro.txt
	(3) classify_features_by_chain.sh
	(4) extract_surface.sh
	(5) classify_surface_by_chain.sh
	(6) README.md

## Externel sofeware tools
	After installation and before running compute jobs,The following externel sofeware tools is required:
	(1) Qcontacts		
	(2) Naccess
	(3) Propka31

## Usage
	
(1)Please change directory to MIALAB-PPIP
	cd /MIALAB-PPIP
(2)Please put the ".pdb" data which you want to extract their features in a directory called "pdb"
	mkdir pdb
(3)Please create a directory called "data" and copy the directory "pdb"
	mkdir data
	cp -r pdb data
(4)Please change directory to /home/username/MIALAB-PPIP.Then execute:
	nohup bash extract_features.sh &
(5)If you want to classify the data by protein chain, then execute:
	nohup bash classify_features_by_chain.sh &
## Results
	A directory "results" which contains "features_by_chain" & "features_by_pair" will be created after the compute jobs running out.
If you running the (5) of Usage, then you will get serveral directory by chain.
