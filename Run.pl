#!/usr/bin/perl

	#
	#  Run.pl
	#  VisBack
	#
	#  Created by Bedeho Mender on 29/04/11.
	#  Copyright 2011 OFTNAI. All rights reserved.
	#
	
	use Data::Dumper;
	use File::Copy;

	########################################################################################
	# VARS
	########################################################################################
	
	# office
	$PROGRAM = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Source/build/Release/VisBack";
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/"; # must have trailing slash
	$MATLAB_SCRIPT_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Scripts/VisBackMatlabScripts/";  # must have trailing slash
	$MATLAB = "/Volumes/Applications/MATLAB_R2010b.app/bin/matlab -nosplash -nodisplay"; # -nodesktop 
	
	# laptop
	#$PROGRAM = "VisBack.exe";
	#chdir("d:/Oxford/Work/VisBack/Release"); # The reason we have do to this is because the drive spesifier( d:) does not work with bash system() command
	#$PROJECTS_FOLDER = "d:/Oxford/Work/Projects/";  # must have trailing slash
	#$MATLAB_SCRIPT_FOLDER = "D:/Oxford/Work/Projects/VisBack/VisBackScripts/";  # must have trailing slash
	#$MATLAB = "matlab -nojvm -nodisplay -nosplash ";

	########################################################################################

	if($#ARGV < 0) {

		print "To few arguments passed.\n";
		print "Usage:\n";
		print " * build\n";
		print " * train\n";
		print " * test\n";
		print " * loadtest\n";
		print "Arg. 2: project name\n";
		print "Arg. 3: experiment name\n";
		print "Arg. 4: simulation name\n";
		print "Arg. 5: stimuli name\n";
		exit;
	}
	else {
        $command = $ARGV[0];
	}
	
	my $project;
	if($#ARGV >= 1) {
        $project = $ARGV[1];
	} else {
        die "No project name provided\n";
	}
	
	my $experiment;
	if($#ARGV >= 2) {
        $experiment = $ARGV[2];
	}
	else {
		die "No experiment name provided\n";
	}
	
	my $experimentFolder = $PROJECTS_FOLDER.$project."/Simulations/".$experiment."/";
	
	# copy stuff into testing training folders
	if($command eq "build") {
		
		$parameterFile = $experimentFolder."Parameters.txt";

        system($PROGRAM, "build", $parameterFile, $experimentFolder);

	} else {
		
		my $simulation;
		if($#ARGV >= 3) {
	        $simulation = $ARGV[3];
		} else {
	        die "No simulation name provided\n";
		}
		
		if ($command eq "loadtest") {

			# Add md5 test here
			if($#ARGV >= 4) {
				$networkFile = $experimentFolder.$ARGV[4];
			} else {
				$networkFile = $experimentFolder."BlankNetwork.txt";
			}
			
			system($PROGRAM, $command, $parameterFile, $networkFile, $simulationFolder);
        } else {
		
			my $stimuli;
			if($#ARGV >= 4) {
		        $stimuli = $ARGV[4];
			} else {
		        die "No stimuli name provided\n";
			}
			
			my $stimuliFolder = $PROJECTS_FOLDER.$project."/Stimuli/".$stimuli."/";
			my $simulationFolder = $experimentFolder.$simulation."/";
			my $parameterFile = $simulationFolder."Parameters.txt";
	
	        if($command eq "test") {
	
				if($#ARGV >= 5) {
					doTest($PROGRAM, $parameterFile, $ARGV[5], $experimentFolder, $stimuliFolder, $simulationFolder);
				} else {
				
					# Call doTest() for all files with file name *Network.txt, this will include
					# 1. trained net (TrainedNetwork)
					# 2. intermediate nets (TrainedNetwork_epoch_transform)
					# 3. untrained control nets (BlankNetwork)
					opendir(DIR, $simulationFolder) or die $!;
					
					while (my $file = readdir(DIR)) {

						# We only want files
						next unless (-f $simulationFolder.$file);
	
						# Use a regular expression to find files of the form *Network*
						next unless ($file =~ m/Network/);

						# Run simulation
						doTest($PROGRAM, $parameterFile, $file, $experimentFolder, $stimuliFolder, $simulationFolder);
					}
					
					closedir(DIR);
					
					# WE DO NOT CALL THIS ANY MORE
					# Call matlab to plot all
					# system($MATLAB . " -r \"cd('$MATLAB_SCRIPT_FOLDER');plotSimulationRegionInvariance('$project','$experiment','$simulation');\""); #	
				}
	                
	        } elsif($command eq "train") {
	        	
				$networkFile = "${experimentFolder}BlankNetwork.txt";
				system($PROGRAM, $command, $parameterFile, $networkFile, "${experimentFolder}FileList.txt", "${stimuliFolder}Filtered/", $simulationFolder);
				
				# Cleanup
				$destinationFolder = $simulationFolder."Training";
				
				if(!(-d $destinationFolder)) {
					print "Making result $destinationFolder \n";
					mkdir($destinationFolder, 0777) || print $!;
				} else {
			    	die "Result directory already exists\n";
			    }
				
				# Move result files into result folder
				system("mv ${simulationFolder}*.dat $destinationFolder");
	        }
        }
	}
	
	# Run test on network, make result folder
	sub doTest {

		my ($PROGRAM, $parameterFile, $net, $experimentFolder, $stimuliFolder, $simulationFolder) = @_;
		
		$networkFile = $simulationFolder.$net;
		
		# DEBUG-DEBUG-DEBUG	
		#print $PROGRAM."\n"."test"."\n".$parameterFile."\n".$networkFile."\n"."${experimentFolder}FileList.txt"."\n"."${stimuliFolder}Filtered/"."\n".$simulationFolder."\n\n\n";
		
		#print "Press any key to run test...\n";
		
		#use Term::ReadKey; 
		#ReadMode 'cbreak'; 
		#$key = ReadKey(0); 
		#ReadMode 'normal';
	
		# DEBUG-DEBUG-DEBUG
		
		system($PROGRAM, "test", $parameterFile, $networkFile, "${experimentFolder}FileList.txt", "${stimuliFolder}Filtered/", $simulationFolder) == 0 or die "Could not execute simulator, or simulator returned 0";
		
		# Make result directory
		$newFolder = substr $net, 0, length($net) - 4;
		$destinationFolder = $simulationFolder.$newFolder;
		
	   	if(!(-d $destinationFolder)) {
			print "Making result directory $destinationFolder \n";
			mkdir($destinationFolder, 0777) || print $!;
	    } else {
	    	die "Result directory already exists\n";
	    }
	    
	    # Move result files into result folder
	    system("mv ${simulationFolder}*.dat ${destinationFolder}");
	    
	    # Move network into result folder
		system("mv $networkFile $destinationFolder");
	}