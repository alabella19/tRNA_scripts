#!/usr/bin/perl
use Data::Dumper;
use Cwd;
$Data::Dumper::Sortkeys = 1;

##takes the output of a grep script and adds the names ot the sequences

##BASH SCRIPT
#for i in *fas.tRNA.fasta
#> do
#> echo $i >> CAG_tRNA_seqs.fasta
#> grep -A 1 --group-separator="" "(CAG)" $i >> CAG_tRNA_seqs.fasta
#> done



if($#ARGV<0){
	print "*******************************************\nSyntax: name_tRNA_seqs.pl fasta_file_withnames";
	exit;
}
$input_file = $ARGV[0];
open(INPUT, "genome_data.txt") || die "Couldn't nopen file $!";
@genome_array = <INPUT>;
close(INPUT);

foreach $line (@genome_array){
	$line =~ s/\n//g;           
	@line = split('\t', $line);
	$genome = $line[1];
	$info = $line[0];
	
	#print "$genome\n$info\n\n";
	$genome_info{$genome}=$info;
}

#print Dumper \%genome_info;


open(INPUT,$input_file) || die "could not open file: $!";
@InArray = <INPUT>;
close(INPUT);


foreach $line (@InArray){
	if($line =~ /tRNA.fasta/){
		$this_spec = $line;
		$this_spec =~ s/\n//;
		$this_spec =~ s/\.fas.tRNA.fasta//;
		$this_spec_info = $genome_info{$this_spec};
		#print "$this_spec\t$this_spec_info\n";
	}elsif($line =~ />/){
		$line =~ s/>//;
		$line = ">" . $this_spec_info."_".$this_spec."-".$line;
		push(@out_array, $line);
	}elsif($line =~ /^\n#/){
	}else{
		push(@out_array, $line);	
	}
	
}

#print Dumper \@out_array;

open FILE, ">" , $input_file;
print FILE @out_array;
close FILE;