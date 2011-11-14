#!/usr/bin/perl

	use strict;
    use warnings;
    
    #my @e1 = (3,2);
    #my @e2 = (3,9);
    
    my $a = 3;#\@e1;
    my $b = 3;#\@e2;

	print "equal\n" if compare( $a, $b);
	
	# Data::Compare, but it was impossible to install
	# on lab machines.
	# compare numbers or array of numbers
	sub compare {
		
		my ($elm_1, $elm_2) = @_;
		
		die("incompatible types being compared.\n") if (ref($elm_1) ne ref($elm_2));
			
		if(ref($elm_1) eq 'ARRAY') {
			my @arr_1 = @{$elm_1};
			my @arr_2 = @{$elm_2};
			
			my $length_1 = scalar (@arr_1);
			my $length_2 = scalar (@arr_2);
			
			die("unequal length.\n") if ($length_1 != $length_2);
			
			# compare two arrays
		   	for(my $i = 0;$i < $length_1;$i++) {
		   		return 0 if $arr_1[$i] != $arr_2[$i];
		    }
		    
		    return 1;
			
		} else {
			
			# compare scalars
			return $elm_1 == $elm_2;
		}
	}
	
	exit;

	#use File::Copy;
	#use Data::Dumper;
	#use POSIX;
	
	
	#print LONG_MAX;
	
	#exit;
	
	
	#print floor(34.56) if 4==4;
	
	#exit;
	
	#$f = 33;
	#use Term::ReadKey; 
	#ReadMode 'cbreak'; 
	#$key = ReadKey(0); 
	#ReadMode 'normal';
	
	
	
	
	#exit;
	
	#@test = (1,2,3,4,5,6,6,555);
	
	#$str = "@test";
	
	#$str =~ s/\s/-/g;
	
	#print $str;
	#print Dumper(@test);
	#exit;
	
	
	
		#$#ARGV >= 2 && $ARGV[2] eq "xgrid"
	#
	#if($#ARGV < 0) {
	#
	#	print "To few arguments passed.\n";
	#	print "Usage:\n";
	#	print "Arg. 1: experiment name\n";
	#	print "Arg. 2: stimuli name\n";
	#	print "Arg. 3: xgrid\n";
	#	exit;
	#}
	#
	#my $experiment;
	#if($#ARGV >= 0) {
    #    $experiment = $ARGV[0];
	#}
	#else {
	#	die "No experiment name provided\n";
	#}
	#
	#my $stimuli;
	#if($#ARGV >= 1) {
    #    $stimuli = $ARGV[1];
	#} else {
    #    die "No stimuli name provided\n";
	#}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	# COMMAND LINE ARGUMENTS
	# $1: project name : e.g. VisBack
	# $2: experiment name: e.g. Working
	# $3: randomize names (yes/no), default is yes
	
	########################################################################################
	# Setup
	########################################################################################
	
	# office
	#$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";  # must have trailing slash
	#$PERL_RUN_SCRIPT = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/Run.pl";
	#$SLASH = "/";
	
	# laptop
	# $PROJECTS_FOLDER = "D:/Oxford/Work/Projects/";  # must have trailing slash
	# $PERL_RUN_SCRIPT = "C:/MinGW/msys/1.0/home/Mender/Run.pl";
	# $SLASH = "/";
	
	########################################################################################
	

	
	#system("mv","/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object/_E10_T4_Ti4_Itrue_RTtrue_L0.01_S0.65/*.dat","/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object/_E10_T4_Ti4_Itrue_RTtrue_L0.01_S0.65/BlankNetwork");
	
	
	#open (TMP, '>test.txt');
	
	#for(my $i = 0;$i < 360;$i++) {
	#	print TMP "$i\n";
	#}
	
	#close(TMP);
	#exit;
	
	#if($#ARGV >= 0) {
    #    print $ARGV[0];
	#}
	
	#exit;

	#$a = 33;
	#$b = 88;
	
	#print "$a hello$b";
	
	#exit;
	#my @files =  glob("/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/*.pl");

	#print $files[0];

	#exit;
	
	#my $dir = '/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object/_E400_T4_L0.01_S0.99';
	
	#opendir(DIR, $dir) or die $!;
	
	#while (my $file = readdir(DIR)) {
	
		# We only want files
	#	next unless (-d "$dir/$file");
		
		# Use a regular expression to find files ending in .txt
	#	next unless ($file =~ m/Network/);
		
		#$z = substr $file, 0, length($file) - 4;
		
	#	print "$file\n";
	#}
	
	#closedir(DIR);