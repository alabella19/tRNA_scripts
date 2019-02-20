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


$all_AA{"AAA"} = "Phe";
$all_AA{"GAA"} = "Phe";
$all_AA{"TAA"} = "Leu";
$all_AA{"CAA"} = "Leu";
$all_AA{"AGA"} = "Ser";
$all_AA{"GGA"} = "Ser";
$all_AA{"TGA"} = "Ser";
$all_AA{"CGA"} = "Ser";
$all_AA{"ATA"} = "Tyr";
$all_AA{"GTA"} = "Tyr";
$all_AA{"TTA"} = "Stop";
$all_AA{"CTA"} = "Stop";
$all_AA{"ACA"} = "Cys";
$all_AA{"GCA"} = "Cys";
$all_AA{"TCA"} = "Stop";
$all_AA{"CCA"} = "Trp";
$all_AA{"AAG"} = "Leu";
$all_AA{"GAG"} = "Leu";
$all_AA{"TAG"} = "Leu";
$all_AA{"CAG"} = "Leu";
$all_AA{"AGG"} = "Pro";
$all_AA{"GGG"} = "Pro";
$all_AA{"TGG"} = "Pro";
$all_AA{"CGG"} = "Pro";
$all_AA{"ATG"} = "His";
$all_AA{"GTG"} = "His";
$all_AA{"TTG"} = "Gln";
$all_AA{"CTG"} = "Gln";
$all_AA{"ACG"} = "Arg";
$all_AA{"GCG"} = "Arg";
$all_AA{"TCG"} = "Arg";
$all_AA{"CCG"} = "Arg";
$all_AA{"AAT"} = "Ile";
$all_AA{"GAT"} = "Ile";
$all_AA{"TAT"} = "Ile";
$all_AA{"CAT"} = "Met";
$all_AA{"AGT"} = "Thr";
$all_AA{"GGT"} = "Thr";
$all_AA{"TGT"} = "Thr";
$all_AA{"CGT"} = "Thr";
$all_AA{"ATT"} = "Asn";
$all_AA{"GTT"} = "Asn";
$all_AA{"TTT"} = "Lys";
$all_AA{"CTT"} = "Lys";
$all_AA{"ACT"} = "Ser";
$all_AA{"GCT"} = "Ser";
$all_AA{"TCT"} = "Arg";
$all_AA{"CCT"} = "Arg";
$all_AA{"AAC"} = "Val";
$all_AA{"GAC"} = "Val";
$all_AA{"TAC"} = "Val";
$all_AA{"CAC"} = "Val";
$all_AA{"AGC"} = "Ala";
$all_AA{"GGC"} = "Ala";
$all_AA{"TGC"} = "Ala";
$all_AA{"CGC"} = "Ala";
$all_AA{"ATC"} = "Asp";
$all_AA{"GTC"} = "Asp";
$all_AA{"TTC"} = "Glu";
$all_AA{"CTC"} = "Glu";
$all_AA{"ACC"} = "Gly";
$all_AA{"GCC"} = "Gly";
$all_AA{"TCC"} = "Gly";
$all_AA{"CCC"} = "Gly";



$first = 0;
foreach $line (@InArray){
	$line =~ s/\n//g;
	if($first == 0){
		if($line =~ /--------/){
			$first = 1;
		}
	}else{
		@anti = split('\t', $line);
		$type = $anti[11];
		$anti = $anti[5];
		#print "type = $type\n";
		if($type =~ /IPD/){
			#print "$anti $type\n";
			$iso = $anti[9];
			if(exists $mismatch{$anti}{$iso}){
				$val = $mismatch{$anti}{$iso};
				$val = $val + 1;
				$mismatch{$anti}{$iso} = $val;
			}else{
				$mismatch{$anti}{$iso}=1; 	
			}
		}elsif($type ne "pseudo" && $anti !~ /N/){
			$val = $all_tRNA{$anti};
			$val = $val + 1;
			$all_tRNA{$anti} = $val;
		}
	}
}

#print Dumper \%all_tRNA;

$spec = $input_file;
$spec =~ s/\.fas.tRNA.out//;

#print Dumper \%mismatch;
#
open FILE, ">", "$input_file.mismatch.tRNA.txt";
print FILE "Anticodon\tMismatch_Iso\tNumer\n";
foreach $anti (keys %mismatch){
	foreach $iso (keys %{$mismatch{$anti}}){
		print FILE "$spec $anti\t$iso\t$mismatch{$anti}{$iso}\n"
	}
}
close FILE;

open FILE, ">", "$spec.tRNA.all.txt";
foreach $anti (keys %mismatch){
	foreach $iso (keys %{$mismatch{$anti}}){
		print FILE "$spec\t$anti\t$iso\t$mismatch{$anti}{$iso}\tmismatch\n"
	}
}
foreach $anti_C (keys %all_tRNA){
	print FILE "$spec\t$anti_C\t$all_AA{$anti_C}\t$all_tRNA{$anti_C}\tmatch\n"
}
close FILE;	



open FILE , ">", "$input_file.tRNA.txt";
print FILE "AntiCodonsList\ttGCN\n";
foreach $anti_C (keys %all_tRNA){
	print FILE "$anti_C\t$all_tRNA{$anti_C}\n"
}
close FILE;

$combine_line = $input_file;
$tRNA_line = "anti_codons";
foreach $anti_C (keys %all_tRNA){
	$tRNA_line = $tRNA_line . "\t" . $anti_C;
	$combine_line = $combine_line . "\t" . $all_tRNA{$anti_C};
}
print "$tRNA_line\n";
print "$combine_line\n";