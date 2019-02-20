#!/usr/bin/perl
use Data::Dumper;
use Cwd;
$Data::Dumper::Sortkeys = 1;

if($#ARGV<0){
	print "*******************************************\nSyntax: process_struct_tRNA.pl tRNA_output.struct";
	exit;
}

$input_file = $ARGV[0];


$spec = $input_file;
$spec =~ s/.fas.tRNA.struct//;

$mismatch = $spec.".fas.tRNA.out";

open(INPUT,$mismatch) || die "could not open file: $!";
@mis_array = <INPUT>;
close(INPUT);

foreach $line (@mis_array){
	if($line !~ /^Sequence/ && $line !~ /^Name/ && $line !~ /^--------/){
		@line = split('\t', $line);
		$name = $line[0];
		$name =~ s/\s//g;
		$tRNA_num = $line[1];
		$seq_name = $name.".trna$tRNA_num";
		$type = $line[4];
		$iso = $line[9];
		#print "$seq_name check $type against $iso\n";
		if($type eq $iso){
			$mismatch_hash{$seq_name}="match";
		}else{
			$mismatch_hash{$seq_name}=$iso;	
		}
	}
}

#print Dumper \%mismatch_hash;

open(INPUT,$input_file) || die "could not open file: $!";
@InArray = <INPUT>;
close(INPUT);


foreach $line (@InArray){
	if($line =~ /Length:/){
		$seq_info = $line;
		$seq_info =~ s/\(\d*-\d*\)//;
		$seq_info =~ s/Length: \d* bp//;
		$seq_info =~ s/\n//g;
		$seq_info =~ s/\s+//g;
		#print "checking $seq_info and get $mismatch_hash{$seq_info}--\n";
		
		if($mismatch_hash{$seq_info} eq "match"){
			$seq_name = ">$spec"."_$seq_info\n";
		}elsif($mismatch_hash{$seq_info} ne "match"){
			$seq_name = ">$spec"."_M-$mismatch_hash{$seq_info}_$seq_info\n";
		}
		$seq_name =~ s/\|/_/g;
		$intron_start = 0;
		$intron_end = 0;
	}elsif($line =~ /Anticodon/){
		@line = split('\t', $line);
		$anticodon = $line[1];
		$anticodon =~ s/Anticodon: //;
		@anticodon = split('\s',$anticodon);
		$anticodon = $anticodon[0];
		$anticodon_loc = $anticodon[2];
		#print "Anticodon is at $anticodon_loc\n";
		@anticodon_loc = split('\-', $anticodon_loc);
		$anti_start = $anticodon_loc[0];
		$anti_end = $anticodon_loc[1];
	}elsif($line =~ /^Possible intron/){
		@intron_coord = split('\s', $line);
		$intron_coord = $intron_coord[2];
		@intron_coord = split('\-', $intron_coord);
		$intron_start = $intron_coord[0],
		$intron_end = $intron_coord[1];
		$seq_name =~ s/\n/_IR\n/;
		#print "coordinates for $line are $intron_start and $intron_end\n";
	}elsif($line =~ /^Seq:/){
		$seq = $line;
		$seq =~ s/Seq: //;
		$anti_seq = $seq;
		$anti_seq =~ s/./\./g;
		#print $seq;
		#print $anti_seq;
		$anti_seq1 = substr $anti_seq, 0, ($anti_start-1);
		$anti_seq2 = substr $anti_seq, $anti_end;
		$anti_seq = $anti_seq1 . "AAA" . $anti_seq2;
		#print $anti_seq;
		if($intron_end != 0 && $intron_start != 0){
			$start = substr $seq, 0, ($intron_start - 1);
			$end = substr $seq, $intron_end;
			#print "$start\tINTRON\t$end\n";
			$seq = $start . $end;
			
			$start = substr $anti_seq, 0, ($intron_start - 1);
			$end = substr $anti_seq, $intron_end;
			#print "$start\tINTRON\t$end\n";
			$anti_seq = $start . $end;
			
		}
		$anti_seq =~ s/\n//g;
		$anti_seq_num = $anti_seq;
		$anti_seq_num =~ s/AAA/123/;
		$anti_seq_num = $anti_seq_num . " #2\n";
		$anti_seq = $anti_seq . " #1\n";
	}elsif($line =~ /^Str/){
		$str = $line;
		$str =~ s/Str: //;
		$str =~ s/>/(/g;
		$str =~ s/</)/g;
		if($intron_end != 0 && $intron_start != 0){
			$start = substr $str, 0, ($intron_start - 1);
			$end = substr $str, $intron_end;
			#print "$start\tINTRON\t$end\n";
			$str = $start . $end;
		}
		$str =~ s/\n//g;
		$str = $str." #S\n";
		#print $seq;
		#print $str;
		#print $anti_seq;
		
		#print $str;
		open FILE, ">>" , "all_seqs_noIR_$anticodon.structseq2";
		print FILE $seq_name;
		print FILE $seq;
		print FILE $str;
		print FILE $anti_seq;
		print FILE $anti_seq_num;
		close FILE;
	}
}