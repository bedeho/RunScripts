#!/usr/bin/perl

	use File::Copy;
	use Data::Dumper;
	use POSIX;
	
	
	print LONG_MAX;
	
	exit;
	
	
	print floor(34.56) if 4==4;
	
	exit;
	
	$f = 33;
	use Term::ReadKey; 
	ReadMode 'cbreak'; 
	$key = ReadKey(0); 
	ReadMode 'normal';
	
	
	
	
	exit;
	
	@test = (1,2,3,4,5,6,6,555);
	
	$str = "@test";
	
	$str =~ s/\s/-/g;
	
	print $str;
	#print Dumper(@test);
	exit;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


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
	

	
	system("mv","/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object/_E10_T4_Ti4_Itrue_RTtrue_L0.01_S0.65/*.dat","/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object/_E10_T4_Ti4_Itrue_RTtrue_L0.01_S0.65/BlankNetwork");
	
	exit
	
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