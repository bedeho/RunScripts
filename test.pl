#!/usr/bin/perl

	use File::Copy;

	# COMMAND LINE ARGUMENTS
	# $1: project name : e.g. VisBack
	# $2: experiment name: e.g. Working
	# $3: randomize names (yes/no), default is yes
	
	########################################################################################
	# Setup
	########################################################################################
	
	# office
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";  # must have trailing slash
	$PERL_RUN_SCRIPT = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/Run.pl";
	$SLASH = "/";
	
	# laptop
	# $PROJECTS_FOLDER = "D:/Oxford/Work/Projects/";  # must have trailing slash
	# $PERL_RUN_SCRIPT = "C:/MinGW/msys/1.0/home/Mender/Run.pl";
	# $SLASH = "/";
	
	########################################################################################
	
	open (TMP, '>test.txt');
	
	for(my $i = 0;$i < 360;$i++) {
		print TMP "$i\n";
	}
	
	close(TMP);
	exit;
	
	if($#ARGV >= 0) {
        print $ARGV[0];
	}
	
	exit;

	$a = 33;
	$b = 88;
	
	print "$a hello$b";
	
	exit;
	my @files =  glob("/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/*.pl");

	print $files[0];

	exit;
	
	my $dir = '/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object/_E400_T4_L0.01_S0.99';
	
	opendir(DIR, $dir) or die $!;
	
	while (my $file = readdir(DIR)) {
	
		# We only want files
		next unless (-d "$dir/$file");
		
		# Use a regular expression to find files ending in .txt
		next unless ($file =~ m/Network/);
		
		#$z = substr $file, 0, length($file) - 4;
		
		print "$file\n";
	}
	
	closedir(DIR);