#!/usr/bin/perl

        use strict;
        use warning;

# COMMAND LINE ARGUMENTS
# $1: command
# * build
# * train
# * test
# * loadtest
# $2: project name : e.g. VisBack
# $3: experiment name: e.g. Working
# $4: simulation name: e.g. 20Epoch

########################################################################################
# Setup
########################################################################################

$SLASH = "/"; # Change to \ on windows

#$PROGRAM = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Model/build.../Release/Model";
$PROGRAM = "VisBack.exe";
chdir("d:/Oxford/Work/VisBack/Release");

# Must have trailing slash in path
#$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";
$PROJECTS_FOLDER = "d:/Oxford/Work/Projects/";

########################################################################################

	if($#ARGV < 0) {

	        print "To few arguments passed.\n";
	        print "Usage:\n";
	        # print " * new simulation\n";
	        print " * build\n";
	        print " * train\n";
	        print " * test\n";
	        print " * loadtest\n";
	        print "Arg. 2: project name, default is VisBack\n";
	        print "Arg. 3: experiment name, default is Working\n";
	        print "Arg. 4: simulation name, default is 20Epoch\n";
	        exit;
	}
	else {
	        $command = $ARGV[0];
	}

	if($#ARGV >= 1) {
	        $project = $ARGV[1];
	} else {
	        $project = "VisBack";
	}

	if($#ARGV >= 2) {
	        $experiment = $ARGV[2];
	}
	else {
	        $experiment = "Working";
	}

	if($#ARGV >= 3) {
	        $simulation = $ARGV[3];
	} else {
	        $simulation = "20Epoch";
	}

	$experimentFolder = $PROJECTS_FOLDER.$project.$SLASH."Simulations".$SLASH.$experiment.$SLASH;
	$simulationFolder = $experimentFolder.$simulation.$SLASH;
	$parameterFile = $simulationFolder."Parameters.txt";

	# copy stuff into testing training folders
	if($command eq "build") {

	        system($PROGRAM." build ".$parameterFile." ".$experimentFolder);

	        # print $PROGRAM." build ".$parameterFile." ".$experimentFolder;

	} else {

	        if($command eq "test") {
	                $networkFile = $simulationFolder."TrainedNetwork.txt";
	                system($PROGRAM." ".$command." ".$parameterFile." ".$networkFile." ".$experimentFolder." ".$simulationFolder);

	        } elsif($command eq "train") {
	                $networkFile = $experimentFolder."BlankNetwork.txt";
	                system($PROGRAM." ".$command." ".$parameterFile." ".$networkFile." ".$experimentFolder." ".$simulationFolder);

	        } elsif ($command eq "loadtest") {

	                # Add md5 test here
	                if($#ARGV >= 4) {
	                        $networkFile = $experimentFolder.$ARGV[4];
	                } else {
	                        $networkFile = $experimentFolder."BlankNetwork.txt";
	                }
	                system($PROGRAM." ".$command." ".$parameterFile." ".$networkFile." ".$simulationFolder);
	        }

	        # Cleanup
	        if($command eq "test") {
	                $destinationFolder = $simulationFolder."Testing";
	        }
	        elsif($command eq "train") {
	                $destinationFolder = $simulationFolder."Training";
	                # $PROGRAM .= " --silent";
	        }

	        if(!(-d $destinationFolder)) {
	                print "Making result directory...\n";
	                mkdir($destinationFolder, 0777) || print $!;
	        }

	        system("mv ".$simulationFolder."*.dat ".$destinationFolder);
	}