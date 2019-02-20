#!/usr/bin/perl
use Data::Dumper;
use Cwd;
$Data::Dumper::Sortkeys = 1;

#This file turns a fasta file into a fasta file formatted for structure and calculates missing data
#requires the script fasta_to_one_line.pl
#updated for version of tRNAscan-SE 2.0
if($#ARGV<0){
	print "*******************************************\nSyntax: get_trna_list.pl input_from_tRNAscan \n takes the output from tRNAscan and creates input for sTAI";
	exit;
}

$input_file = $ARGV[0];

open(INPUT,$input_file) || die "could not open file: $!";
@InArray = <INPUT>;
close(INPUT);

$all_tRNA{"AAA"} = 0;
$all_tRNA{"GAA"} = 0;
$all_tRNA{"TAA"} = 0;
$all_tRNA{"CAA"} = 0;
$all_tRNA{"AGA"} = 0;
$all_tRNA{"GGA"} = 0;
$all_tRNA{"TGA"} = 0;
$all_tRNA{"CGA"} = 0;
$all_tRNA{"ATA"} = 0;
$all_tRNA{"GTA"} = 0;
$all_tRNA{"TTA"} = 0;
$all_tRNA{"CTA"} = 0;
$all_tRNA{"ACA"} = 0;
$all_tRNA{"GCA"} = 0;
$all_tRNA{"TCA"} = 0;
$all_tRNA{"CCA"} = 0;
$all_tRNA{"AAG"} = 0;
$all_tRNA{"GAG"} = 0;
$all_tRNA{"TAG"} = 0;
$all_tRNA{"CAG"} = 0;
$all_tRNA{"AGG"} = 0;
$all_tRNA{"GGG"} = 0;
$all_tRNA{"TGG"} = 0;
$all_tRNA{"CGG"} = 0;
$all_tRNA{"ATG"} = 0;
$all_tRNA{"GTG"} = 0;
$all_tRNA{"TTG"} = 0;
$all_tRNA{"CTG"} = 0;
$all_tRNA{"ACG"} = 0;
$all_tRNA{"GCG"} = 0;
$all_tRNA{"TCG"} = 0;
$all_tRNA{"CCG"} = 0;
$all_tRNA{"AAT"} = 0;
$all_tRNA{"GAT"} = 0;
$all_tRNA{"TAT"} = 0;
$all_tRNA{"CAT"} = 0;
$all_tRNA{"AGT"} = 0;
$all_tRNA{"GGT"} = 0;
$all_tRNA{"TGT"} = 0;
$all_tRNA{"CGT"} = 0;
$all_tRNA{"ATT"} = 0;
$all_tRNA{"GTT"} = 0;
$all_tRNA{"TTT"} = 0;
$all_tRNA{"CTT"} = 0;
$all_tRNA{"ACT"} = 0;
$all_tRNA{"GCT"} = 0;
$all_tRNA{"TCT"} = 0;
$all_tRNA{"CCT"} = 0;
$all_tRNA{"AAC"} = 0;
$all_tRNA{"GAC"} = 0;
$all_tRNA{"TAC"} = 0;
$all_tRNA{"CAC"} = 0;
$all_tRNA{"AGC"} = 0;
$all_tRNA{"GGC"} = 0;
$all_tRNA{"TGC"} = 0;
$all_tRNA{"CGC"} = 0;
$all_tRNA{"ATC"} = 0;
$all_tRNA{"GTC"} = 0;
$all_tRNA{"TTC"} = 0;
$all_tRNA{"CTC"} = 0;
$all_tRNA{"ACC"} = 0;
$all_tRNA{"GCC"} = 0;
$all_tRNA{"TCC"} = 0;
$all_tRNA{"CCC"} = 0;

$first = 0;
foreach $line (@InArray){
	$line =~ s/\n//g;
	if($first == 0){
		if($line =~ /--------/){
			$first = 1;
		}
	}else{
		@anti = split('\t', $line);
		$type = $anti[9];
		$anti = $anti[5];
		#print "type = $type\n";
		if($type ne "pseudo" && $anti !~ /NNN/){
			$val = $all_tRNA{$anti};
			$val = $val + 1;
			$all_tRNA{$anti} = $val;
		}else{
			#print $anti;
		}
	}
}

#print Dumper \%all_tRNA;

#open FILE , ">", "$input_file.tRNA.txt";
#print FILE "AntiCodonsList\ttGCN\n";
#foreach $anti_C (keys %all_tRNA){
#	print FILE "$anti_C\t$all_tRNA{$anti_C}\n"
#}
#close FILE;

$combine_line = $input_file;
$tRNA_line = "anti_codons";
foreach $anti_C (keys %all_tRNA){
	$tRNA_line = $tRNA_line . "\t" . $anti_C;
	$combine_line = $combine_line . "\t" . $all_tRNA{$anti_C};
}
print "$tRNA_line\n";
print "$combine_line\n";