#!/usr/bin/perl

BEGIN{ unshift (@INC, "./lib"); };
use pdb_pl::Pdb;
use strict;

if(@ARGV<1){
	print STDERR "-i = current.pdb\n";
	print STDERR "-prefOut = ./output\n";
	print STDERR "-c1 = \$\n";
	print STDERR "-c2 = \$\n";
	print STDERR "-probe = 1.400000\n";
	exit;
}

my( $temp, $i, $prefOut, $c1, $c2, $probe );

while(@ARGV){
	$temp = shift;
	if( $temp eq "-i" ){ $i = shift; }
	elsif( $temp eq "-prefOut" ){ $prefOut = shift; }
	elsif( $temp eq "-c1" ){ $c1 = shift; }
	elsif( $temp eq "-c2" ){ $c2 = shift; }
	elsif( $temp eq "-probe" ){ $probe = shift; }
	else{
		print STDERR "Warning: argument $temp igorned.\n";
	}
}

$i = "current.pdb" if(!defined($i));
$prefOut = "./output" if(!defined($prefOut));
$c1 = "\$" if(!defined($c1));
$c2 = "\$" if(!defined($c2));
$probe = "1.400000" if(!defined($probe));

if(!-e $i){
	print "$i does not exist, exit!\n";
	exit;	
}

my $qc = "./Qcontacts";

my $cmd;

if($c1 ne $c2){
	$cmd = "$qc -i $i -prefOut ${prefOut} -c1 $c1 -c2 $c2";
	print `$cmd`;
	exit;
}

my $pdb = new Pdb; $pdb->load($i);
my @chains = $pdb->chains;
my $c;
if(@chains==1){
	$c = $chains[0]->id;
	$cmd = "$qc -i $i -prefOut ${prefOut}_$c -c1 $c -c2 $c";
	print `$cmd`;
} else { # > 1
	for( my $x=0; $x<@chains; $x++ ){
		$c = $chains[$x]->id;
		$cmd = "$qc -i $i -prefOut ${prefOut}_$c -c1 $c -c2 $c";
		print `$cmd`;
	}
}
