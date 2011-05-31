#!/usr/bin/perl

	#
	#  ParamSearch.pl
	#  VisBack
	#
	#  Created by Bedeho Mender on 29/04/11.
	#  Copyright 2011 OFTNAI. All rights reserved.
	#

	use File::Copy;
	use Data::Dumper;

	########################################################################################
	# VARS
	########################################################################################
	
	# office
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";  # must have trailing slash
	$PERL_RUN_SCRIPT = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/Run.pl";
	$MATLAB_SCRIPT_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Scripts/VisBackMatlabScripts/";  # must have trailing slash
	$MATLAB = "/Volumes/Applications/MATLAB_R2010b.app/bin/matlab -nosplash -nodisplay"; # -nodesktop
	
	# laptop must have trailing slash
	#$PROJECTS_FOLDER = "D:/Oxford/Work/Projects/";  # must have trailing slash
	#$PERL_RUN_SCRIPT = "C:/MinGW/msys/1.0/home/Mender/Run.pl";
	#$MATLAB_SCRIPT_FOLDER = "D:/Oxford/Work/Projects/VisBack/VisBackScripts/";  # must have trailing slash
	#$MATLAB = "matlab -nojvm -nodisplay -nosplash ";
	
	########################################################################################

	if($#ARGV < 0) {

		print "To few arguments passed.\n";
		print "Usage:\n";
		print "Arg. 1: project name, default is VisBack\n";
		print "Arg. 2: experiment name, default is 1Object\n";
		exit;
	}
	
	my $project;
	if($#ARGV >= 0) {
        $project = $ARGV[0];
	} else {
        die "No project name provided\n";
	}
	
	my $experiment;
	if($#ARGV >= 1) {
        $experiment = $ARGV[1];
	}
	else {
		die "No experiment name provided\n";
	}
	
	my $stimuli;
	if($#ARGV >= 2) {
        $stimuli = $ARGV[2];
	} else {
        die "No stimuli name provided\n";
	}

    my $experimentFolder = $PROJECTS_FOLDER.$project."/Simulations/".$experiment."/";
    my $xgridResult = $PROJECTS_FOLDER.$project."/Xgrid/".$experiment."/";
    
	open (F, "${experimentFolder}simulations.txt") || die "Could not open ${experimentFolder}simulations.txt: $!\n";
	@lines = <F>;
	close F;
	
	# Move from result folder to xgrid working directory
	system("mv ${xgridResult}* $experimentFolder") == 0 or die "Moving xgrid results $xgridResult content into $experimentFolder failed: $!";
	
	for(my $i = 0;$i < $#lines+1;$i++) {
		
		# Get name of parameter file
		$file = $lines[$i];
		
		# Check for trailing new line
		chomp($file) if (substr($file, -1, 1) eq "\n");
		
		print "Processing $file..\n";
		
		# Move it into dir
		move($experimentFolder.$file, "${experimentFolder}${i}/Parameters.txt") or die "Moving parameter file $file failed: $!";
					
		# Make /Training subdirectory
		mkdir("${experimentFolder}${i}/Training") or die "Could not make training dir ${experimentFolder}${i}/Training dir: $!";
		
		# Untar result.tgz
		system("tar -xjf ${experimentFolder}${i}/result.tbz -C ${experimentFolder}${i}") == 0 or die "Could not untar ${experimentFolder}${i}/result.tbz: $!";
		
		# Move results into /Training
		system("mv ${experimentFolder}${i}/*.dat ${experimentFolder}${i}/Training") == 0 or die "Moving result files into training folder failed: $!";
		
		# Copy blank network into folder so that we can do control test automatically
		my $blankNetworkSRC = $experimentFolder."BlankNetwork.txt";
		my $blankNetworkDEST = $experimentFolder.$i."/BlankNetwork.txt";
		copy($blankNetworkSRC, $blankNetworkDEST) or die "Copying blank network failed: $!";
		
		# Rename dir
		$simulation = substr($file, 0, -4);
		move($experimentFolder.$i, $experimentFolder.$simulation) or die "Renaming folder ${experimentFolder}${simulation} failed: $!";
		
		# Run test
		system($PERL_RUN_SCRIPT, "test", $project, $experiment, $simulation, $stimuli);
	}
	
	# Call matlab to plot all
	system($MATLAB . " -r \"cd('$MATLAB_SCRIPT_FOLDER');plotExperimentInvariance('$project','$experiment');\"");

	# Check to see that all results are back
    #my $sleepTime = 30;
    #my $foundSleepTime = 60*5;
    #my $nrOfSleeps = 0;
    #my $found = 0;
    #
	#while ($found != $counter) {
	#	
	#	# Sleep for 30 seconds for next check
	#	print "$nrOfSleeps . Results not back, sleeping $sleepTime seconds... \n";
	#	$nrOfSleeps++;
	#	sleep($sleepTime);
	#	
	#	opendir(DIR, $experimentFolder) or die $!;
	#	
	#	while (my $dir = readdir(DIR)) {
	#		
	#		# Check that it is a directory
	#       next unless (-d $experimentFolder.$dir);
	#		
	#		# Check that it is a number and check its range
	#		if($dir eq int $dir && ($dir >= 0 && $dir < $counter)) {
	#			
	#			# check if it has nonzero tar file to be sure!!
	#			$found++;
	#		}
	#	}
	#	
	#	closedir(DIR);
	#};
	#
	#print "Found all results, sleeping for $foundSleepTime seconds to make sure all results are completely downloaded... \n";
	#sleep($foundSleepTime);
    #
    # Process each result folder
  	#opendir(DIR, $experimentFolder) or die $!;
	#
	#while (my $dir = readdir(DIR)) {
	#	
	#	# Check that it is a directory
    #    next unless (-d $experimentFolder.$dir);
	#		
	#	# Check that it is a number and check its range
	##	if($dir eq int $dir && ($dir >= 0 && $dir < $counter)) {
	#		
	#		# Find the right param file
	#		my @files = glob($experimentFolder.$dir.'_*.txt');
	#		
	#		if($#files != 0) {
	#			print "Unique parameter file was not found for result $dir\n";
	#			print Dumper(@files);
	#			exit;
	#		}
	#		
	#		#Process file
	#
    #
	#		
	#	}
	#}
	#
	#closedir(DIR);
    