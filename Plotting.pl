#!/usr/bin/perl

	use File::Copy;

	########################################################################################
	# VARS
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

	if($#ARGV < 0) {

	        print "To few arguments passed.\n";
	        print "Usage:\n";
	        print "Arg. 1: project name, default is VisBack\n";
	        print "Arg. 2: experiment name, default is 1Object\n";
	        exit;
	}

	if($#ARGV >= 1) {
	        $project = $ARGV[1];
	} else {
	        #$project = "VisBack";
	        die "No project name provided\n";
	}

	if($#ARGV >= 2) {
	        $experiment = $ARGV[2];
	}
	else {
	        #$experiment = "Working";
			die "No experiment name provided\n";
	}

	if($#ARGV >= 3) {
	        $simulation = $ARGV[3];
	} else {
	        #$simulation = "20Epoch";
	        die "No simulation name provided\n";
	}

	$experimentFolder = $PROJECTS_FOLDER.$project.$SLASH."Simulations".$SLASH.$experiment.$SLASH;
	$simulationFolder = $experimentFolder.$simulation.$SLASH;
	$parameterFile = $simulationFolder."Parameters.txt";
        
	$experimentFolder = $PROJECTS_FOLDER.$project.$SLASH."Simulations".$SLASH.$experiment.$SLASH;
	$simulationFolder = $experimentFolder.$simulation.$SLASH;
	
	# Iterate all simulations in this experiment
	opendir(DIR, $experimentFolder) or die $!;
	
	while (my $file = readdir(DIR)) {
	
		# We only want files
		next unless (-f "$dir/$file");
		
		# Use a regular expression to find files ending in *Network.txt
		next unless ($file =~ m/Training$/);
		
		# Run simulation
		doTest($PROGRAM, $parameterFile, $file, $experimentFolder, $simulationFolder);
	}
	
	closedir(DIR);

# 
	
# Run test on network, make result folder
sub doTest {

	my ($PROGRAM, $parameterFile, $net, $experimentFolder, $simulationFolder) = @_;
	
	$networkFile = $simulationFolder.$net;
	                    
	system($PROGRAM." test ".$parameterFile." ".$networkFile." ".$experimentFolder." ".$simulationFolder);
	
	# Cleanup
	$newFolder = substr $net, 0, length($net) - 4;
	$destinationFolder = $simulationFolder.$newFolder;
	
   	if(!(-d $destinationFolder)) {
            print "Making result directory...\n";
            mkdir($destinationFolder, 0777) || print $!;
    }
    
    # Move result files into result folder
    system("mv ".$simulationFolder."*.dat ".$destinationFolder);
    
    # Move network into result folder
	system("mv $networkFile ".$destinationFolder);
	    
	# Do plot of top region
	# chdir($SCRIPT_FOLDER);
	# $firingRateFile = $simulationFolder."firingRate.dat";
	# system($MATLAB . " -r plotRegionHistory('".$firingRateFile."', 5)");
	# print $MATLAB . " -r plotRegionHistory('".$firingRateFile."', 5)";     
}