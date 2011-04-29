#!/usr/bin/perl

	########################################################################################
	# VARS
	########################################################################################
	
	# office
	$PROGRAM = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/VisBack/build/Release/VisBack";
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/"; # must have trailing slash
	$SCRIPT_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Scripts/VisBackMatlabScripts/";  # must have trailing slash
	$SLASH = "/";
	
	# laptop
	#$PROGRAM = "VisBack.exe";
	#chdir("d:/Oxford/Work/VisBack/Release");
	#$PROJECTS_FOLDER = "d:/Oxford/Work/Projects/";  # must have trailing slash
	#$SCRIPT_FOLDER = "D:/Oxford/Work/Projects/VisBack/VisBackScripts/";  # must have trailing slash
	#$SLASH = "/";
	 
	$MATLAB = "matlab -nojvm -nodisplay -nosplash ";
	
	########################################################################################

	if($#ARGV < 0) {

	        print "To few arguments passed.\n";
	        print "Usage:\n";
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

	# copy stuff into testing training folders
	if($command eq "build") {

	        system($PROGRAM." build ".$parameterFile." ".$experimentFolder);

	} else {

	        if($command eq "test") {

                	if($#ARGV >= 4) {

	                        doTest($PROGRAM, $parameterFile, $ARGV[4], $experimentFolder, $simulationFolder);
	                } else {
	                        
	                        # Call doTest() for all files with file name *Network.txt, this will include
	                        # 1. trained net
	                        # 2. intermediate nets
	                        # 3. untrained control nets
							opendir(DIR, $simulationFolder) or die $!;
							
							while (my $file = readdir(DIR)) {
							
								# We only want files
								next unless (-f "$dir/$file");
								
								# Use a regular expression to find files ending in *Network.txt
								next unless ($file =~ m/Network.txt$/);
								
								# Run simulation
								doTest($PROGRAM, $parameterFile, $file, $experimentFolder, $simulationFolder);
							}
							
							closedir(DIR);	
	                }
	                
	        } elsif($command eq "train") {
	        	
	                $networkFile = $experimentFolder."BlankNetwork.txt";
	                system($PROGRAM." ".$command." ".$parameterFile." ".$networkFile." ".$experimentFolder." ".$simulationFolder);
	                
	                # Cleanup
	                $destinationFolder = $simulationFolder."Training";
		
			        if(!(-d $destinationFolder)) {
			                print "Making result directory...\n";
			                mkdir($destinationFolder, 0777) || print $!;
			        }
					
					# Move result files into result folder
			        system("mv ".$simulationFolder."*.dat ".$destinationFolder);
	
	        } elsif ($command eq "loadtest") {

	                # Add md5 test here
	                if($#ARGV >= 4) {
	                        $networkFile = $experimentFolder.$ARGV[4];
	                } else {
	                        $networkFile = $experimentFolder."BlankNetwork.txt";
	                }
	                system($PROGRAM." ".$command." ".$parameterFile." ".$networkFile." ".$simulationFolder);
	        }
	}
	
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