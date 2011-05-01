#!/usr/bin/perl

	#
	#  Plotting.pl
	#  VisBack
	#
	#  Created by Bedeho Mender on 29/04/11.
	#  Copyright 2011 OFTNAI. All rights reserved.
	#

	print "decomissioned, now use autoPlotRegion.m";
	exit;

	use File::Copy;
	use Data::Dumper;

	########################################################################################
	# VARS
	########################################################################################
	
	# office
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";  # must have trailing slash
	$MATLAB_SCRIPT_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Scripts/VisBackMatlabScripts/";  # must have trailing slash
	$MATLAB = "/Volumes/Applications/MATLAB_R2010b.app/bin/matlab  -nosplash "; #-nodisplay -nodesktop                                                                                                                                
	$SLASH = "/";
	
	# laptop
	#$PROJECTS_FOLDER = "D:/Oxford/Work/Projects/";  # must have trailing slash
	#$MATLAB_SCRIPT_FOLDER = "D:/Oxford/Work/Projects/VisBack/VisBackScripts/";  # must have trailing slash
	#$MATLAB = "matlab -nojvm -nodisplay -nosplash ";
	#$SLASH = "/";
	
	########################################################################################

	if($#ARGV < 0) {
		
		print "To few arguments passed.\n";
		print "Usage:\n";
		print "Arg. 1: project name, default is VisBack\n";
		print "Arg. 2: experiment name, default is 1Object\n";
		exit;
	}

	if($#ARGV >= 0) {
        $project = $ARGV[0];
	} else {
        die "No project name provided\n";
	}

	if($#ARGV >= 1) {
        $experiment = $ARGV[1];
	}
	else {
		die "No experiment name provided\n";
	}

	if($#ARGV >= 2) {
        $simulation = $ARGV[2];
	} else {
        die "No simulation name provided\n";
	}

	$experimentFolder = $PROJECTS_FOLDER.$project.$SLASH."Simulations".$SLASH.$experiment.$SLASH;
	$simulationFolder = $experimentFolder.$simulation.$SLASH;
	
	# Iterate all network result folders in this simulation folder
	opendir(DIR, $simulationFolder) or die $!;
	
	while (my $dir = readdir(DIR)) {
		
		# A file test to check that it is a directory
		# Use -f to test for a file
        next unless (-d $simulationFolder.$dir);
		
		# Do plotting simulation, but not for the training data
		if($dir ne "Training" && $dir ne "." && $dir ne "..") {
			doPlot($simulationFolder.$dir);
		}
	}
	
	closedir(DIR);
	
	# Run test on network, make result folder
	sub doPlot {
	
		# Get result folder
		my ($folder) = @_;
		$firingRateFile = $folder."/firingRate.dat";
		
		# Do plot of top region 
		# plotRegionInvariance(filename, region, object, depth)
		system($MATLAB . " -r \"cd('$MATLAB_SCRIPT_FOLDER');plotRegionInvariance('$firingRateFile');\""); #
		#print $MATLAB . " -r \"cd('$MATLAB_SCRIPT_FOLDER');plotRegionInvariance('$firingRateFile');\"";
		#print "\n";
		
		# Do plot of second to top region
		#system($MATLAB . " -r plotRegionHistory('$firingRateFile',4)");
		#print $MATLAB . " -r plotRegionHistory('$firingRateFile',4)";     
	}