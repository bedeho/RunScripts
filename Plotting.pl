#!/usr/bin/perl

	#
	#  Plotting.pl
	#  VisBack
	#
	#  Created by Bedeho Mender on 29/04/11.
	#  Copyright 2011 OFTNAI. All rights reserved.
	#

	use File::Copy;

	########################################################################################
	# VARS
	########################################################################################
	
	$MATLAB = "matlab -nojvm -nodisplay -nosplash ";
	
	# office
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";  # must have trailing slash
	$MATLAB_SCRIPT_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Scripts/VisBackMatlabScripts/";  # must have trailing slash
	$SLASH = "/";
	
	# laptop
	#$PROJECTS_FOLDER = "D:/Oxford/Work/Projects/";  # must have trailing slash
	#$MATLAB_SCRIPT_FOLDER = "D:/Oxford/Work/Projects/VisBack/VisBackScripts/";  # must have trailing slash
	#$SLASH = "/";
	
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
	
	# Iterate all network result folders in this simulation folder
	opendir(DIR, $simulationFolder) or die $!;
	
	while (my $file = readdir(DIR)) {
		
		# A file test to check that it is a directory
		# Use -f to test for a file
        next unless (-d "$dir/$file");
		
		# Do plotting simulation
		doPlot($simulationFolder.$file);
	}
	
	closedir(DIR);
	
# Run test on network, make result folder
sub doPlot {

	# Get result folder
	my ($folder) = @_;
	$firingRateFile = $folder . "/firingRate.dat";
	
	# Go to the script directory to run matlab plotting script
	chdir($SCRIPT_FOLDER);
	
	# Do plot of top region
	# plotRegionInvariance(filename, region, object, depth)
	system($MATLAB . " -r plotRegionHistory('$firingRateFile', 5)");
	print $MATLAB . " -r plotRegionHistory('$firingRateFile', 5)";     
}