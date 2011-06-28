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
	$PROGRAM = "VisBack";
	$PROGRAM_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Source/build/Release/";
	$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";  # must have trailing slash
	$PERL_RUN_SCRIPT = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/Run.pl";
	$MATLAB_SCRIPT_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Scripts/VisBackMatlabScripts/";  # must have trailing slash
	$MATLAB = "/Volumes/Applications/MATLAB_R2010b.app/bin/matlab -nosplash -nodisplay"; # -nodesktop
	#$PERL_PLOT_SCRIPT = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/Plotting.pl";
	#$PERL_XGRIDLISTENER_SCRIPT = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/RunScripts/xGridListener.pl";
	
	# laptop
	#$PROGRAM_FOLDER
	#$PROJECTS_FOLDER = "D:/Oxford/Work/Projects/";  # must have trailing slash
	#$PERL_RUN_SCRIPT = "C:/MinGW/msys/1.0/home/Mender/Run.pl";
	#$PERL_PLOT_SCRIPT = "C:/MinGW/msys/1.0/home/Mender/Plotting.pl";
	
	########################################################################################

	if($#ARGV < 0) {

		print "To few arguments passed.\n";
		print "Usage:\n";
		print "Arg. 1: project name\n";
		print "Arg. 2: experiment name\n";
		print "Arg. 3: stimuli name\n";
		print "Arg. 4: xgrid\n";
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
	my $stimuliFolder = $PROJECTS_FOLDER.$project."/Stimuli/".$stimuli."/";
    my $untrainedNet = $experimentFolder."BlankNetwork.txt";
    my $xgridResult = $PROJECTS_FOLDER.$project."/Xgrid/".$experiment."/";
	
    my $xgrid = 0;
	if($#ARGV >= 3 && $ARGV[3] == "xgrid") {
		
        $xgrid = 1;
        
        # Make xgrid file
        open (XGRID_FILE, '>'.$experimentFolder.'xgrid.txt');
        print XGRID_FILE '-in '.substr($experimentFolder, 0, -1).' -files '.$stimuliFolder.'xgridPayload.tbz ';
        
        # Make simulation file
        open (SIMULATIONS_FILE, '>'.$experimentFolder.'simulations.txt');
        
        # Make result directory
        mkdir($xgridResult);
	}

    my $pathWayLength		= 4;
    
    # Build template parameter file from these
    my @dimension			= (32,32,32,32);
    my @depth				= (1,1,1,1);
    my @fanInRadius 		= (6,6,9,12);
    my @fanInCount 			= (100,100,100,100);
    my @learningrate		= ("fail","fail","fail","fail");
    my @eta					= ("0.8","0.8","0.8","0.8");
    my @sparsenessLevel		= ("fail","fail","fail","fail");
    my @sigmoidSlope 		= ("190.0","40.0","75.0","26.0");
    my @inhibitoryRadius	= ("1.38","2.7","4.0","6.0");
    my @inhibitoryContrast	= ("1.5","1.5","1.6","1.4");
    my @inhibitoryWidth		= (7,11,17,25);

    my @esRegionSettings;
   	for(my $r = 0;$r < $pathWayLength;$r++) {

     	my %region   	= ('dimension'          =>      $dimension[$r],
                         'depth'             =>      $depth[$r],
                         'fanInRadius'       =>      $fanInRadius[$r],
                         'fanInCount'        =>      $fanInCount[$r],
                         'learningrate'      =>      $learningrate[$r],
                         'eta'               =>      $eta[$r],
                         'sparsenessLevel'   =>      $sparsenessLevel[$r],
                         'sigmoidSlope'      =>      $sigmoidSlope[$r],
                         'inhibitoryRadius'  =>      $inhibitoryRadius[$r],
                         'inhibitoryContrast'=>      $inhibitoryContrast[$r],
                         'inhibitoryWidth'   =>      $inhibitoryWidth[$r]
                         );

         push @esRegionSettings, \%region;
    }

    # Generate all combinations of these parameters
    # GENERALIZE THIS LOUSY CODE !!! LATER USING ASSOCIATIVE ARRAYS
    # AND PARTITIONING PARAMS INTO GENERAL AND LAYER PARAMS
    # do recursive perumtation and send result key->val map to
    # makeParameterFile in bottom of recursion
    
	# FIXED PARAMS - non permutable
	# These are global!, used directly in param file
    $wavelengths					= "{lambda = 2; fanInCount = 201;}"; # YOU MUST CHANGE LAMBDA SO THAT SIMULATOR CAN FIND PROPER INPUT FILE NAME
	$neuronType						= 1; # 0 = discrete, 1 = continuous
    $learningRule					= 0; # 0 = trace, 1 = hebb
    $nrOfObjects					= 7;
    $nrOfTransformations			= 9;
    $timePrTransform				= "0.1";
    $nrOfEpochs						= 100;
    $saveNetworkAtEpochMultiple 	= 30;
    $saveNetworkAtTransformMultiple = $nrOfObjects * $nrOfTransformations;
	$outputAtTimeStepMultiple		= 100;
    $trainAtTimeStepMultiple		= 4; # only used in discrete model
    $timeStepsPrInputFile	 		= 4; # only used in discrete model
    $useInhibition					= "true"; # "false"
    $resetTrace						= "true"; # "false"
    
    # RANGE PARAMS - permutable
    # Notice, layer one needs 3x because of small filter magnitudes, and 5x because of
    # number of afferent synapses, total 15x.
    my @learningRates 				= ( #["150000.0"	,"100000.0"	,"100000.0"	,"100000.0"],
    									["15000.0"	,"10000.0"	,"10000.0"	,"10000.0"],
    									["1500.0"	,"1000.0"	,"1000.0"	,"1000.0"],
    									["150.0"	,"100.0"	,"100.0"	,"100.0"]
    									#["15.0"		,"10.0"		,"10.0"		,"10.0"],
    									#["1.5"		,"0.1"		,"0.1"		,"0.1"], # 0.1 
    									#["0.15"	,"0.01"		,"0.01"		,"0.01"] # 0.01 
    									#["0.015"	,"0.001"	,"0.001"	,"0.001"], # 0.001 
    									#["0.0015"	,"0.0001"	,"0.0001"	,"0.0001"], # 0.0001 
    									#["0.00015"	,"0.00001"	,"0.00001"	,"0.00001"], # 0.00001 
    									#["0.000015","0.000001"	,"0.000001"	,"0.000001"] # 0.000001
    									); 
    									
    my @sparsenessLevel				= ( 
    									#["0.75"	,"0.80"		,"0.88"		,"0.91"], # 0.91 
    									#["0.80" 	,"0.85"		,"0.88"		,"0.95"], # 0.95
    									#["0.85"	,"0.85"		,"0.88"		,"0.96"], # 0.96
    									#["0.94"		,"0.90"		,"0.88"		,"0.90"], # 0.90
    									["0.992"		,"0.98"		,"0.88"		,"0.91"] # classic trace ("0.992"	,"0.98"	,"0.88"	,"0.91") 
    									#["0.95"	,"0.90"		,"0.99"		,"0.99"]  # 0.99
    									); 
 
    my @timeConstant				= ("0.001", "0.010", "0.100"); # 1ms, 5ms "0.005", 10ms
    my @stepSizeFraction			= ("0.1", "0.05"); # 0.1 = 1/10, 0.05 = 1/20, 0.02 = 1/50
    my @traceTimeConstant			= ("0.1", "0.05", "0.01"); #("0.1", "0.05", "0.01")

    $firstTime = 1;
    
	#for my $t (@trainAtTimeStepMultiple) {
		#for my $tPrFile (@timeStepsPrInputFile) {
			#for my $ui (@useInhibition) {
				#for my $rt (@resetTrace) {
					for my $tC (@timeConstant) {
						for my $sSF (@stepSizeFraction) {
							for my $ttC (@traceTimeConstant) {
								for my $l (@learningRates) {
									for my $s (@sparsenessLevel) {
										
										my @learningRateArray = @{ $l };
										my @sparsityArray = @{ $s };
										my $layerCounter = 0;
										
										for $region ( @esRegionSettings ) {
											
											$region->{'learningrate'} = $learningRateArray[$layerCounter];
											$region->{'sparsenessLevel'} = $sparsityArray[$layerCounter];
											
											$layerCounter++;
										}
										
										$Lstr = "@learningRateArray";
										$Lstr =~ s/\s/-/g;
										
										$Sstr = "@sparsityArray";
										$Sstr =~ s/\s/-/g;
										
										my $simulationCode = "L${Lstr}_S${Sstr}_tC${tC}_sSF${sSF}_ttC${ttC}";
										#"_I".$ui.
										#"_RT".$rt
										#"_T".$t
										#"_Ti".$tPrFiles
										#"_E".$nrOfEpochs
										
										if($xgrid) {
											
											my $parameterFile = $experimentFolder.$simulationCode.".txt";
											
											# Make parameter file
											print "Writing new parameter file: ". $simulationCode ." \n";
											my $result = makeParameterFile(\@esRegionSettings, $tC, $sSF, $ttC);
											
											open (PARAMETER_FILE, '>'.$parameterFile);
											print PARAMETER_FILE $result;
											close (PARAMETER_FILE);
											
											# Add reference to simulation name file
											print SIMULATIONS_FILE $simulationCode.".txt\n";
											
											# Add line to batch file
											print XGRID_FILE "\n" if !$firstTime;
											print XGRID_FILE "$PROGRAM --xgrid train ${simulationCode}.txt BlankNetwork.txt";
											
											$firstTime = 0;
										} else {
											
											# New folder name for this iteration
											my $simulation = $simulationCode;
											
											my $simulationFolder = $experimentFolder.$simulation."/";
											my $parameterFile = $simulationFolder."Parameters.txt";
											
											my $blankNetworkSRC = $experimentFolder."BlankNetwork.txt";
											my $blankNetworkDEST = $simulationFolder."BlankNetwork.txt";
										
											if(!(-d $simulationFolder)) {
												
												# Make simulation folder
												print "Making new simulation folder: " . $simulationFolder . "\n";
												mkdir($simulationFolder, 0777) || print $!;
												
												# Make parameter file and write to simulation folder
												print "Writing new parameter file: ". $simulationCode ." \n";
												my $result = makeParameterFile(\@esRegionSettings, $tC, $sSF, $ttC);
												
												open (PARAMETER_FILE, '>'.$parameterFile);
												print PARAMETER_FILE $result;
												close (PARAMETER_FILE);
												
												# Run training
												system($PERL_RUN_SCRIPT, "train", $project, $experiment, $simulation, $stimuli);
												
												# Copy blank network into folder so that we can do control test automatically
												print "Copying blank network: ". $blankNetworkSRC . " \n";
												copy($blankNetworkSRC, $blankNetworkDEST) or die "Copying blank network failed: $!";
												
												# Run test
												system($PERL_RUN_SCRIPT, "test", $project, $experiment, $simulation, $stimuli);
												
											} else {
												print "Could not make folder (already exists?): " . $simulationFolder . "\n";
												exit;
											}
										}
									}
								}
							}
						}
					}
				#}
			#}
		#}
	#}
	
	# If we just setup xgrid parameter search
	if($xgrid) {
		
		# close xgrid batch file
		close(XGRID_FILE);
		
		# close simulation name file
		close(SIMULATIONS_FILE);
		
		# submit job to grid
		# is manual for now!
		
		# start listener
		# is manual for now! #system($PERL_XGRIDLISTENER_SCRIPT, $project, $experiment, $counter);
	}
	else {
		# Call matlab to plot all
		system($MATLAB . " -r \"cd('$MATLAB_SCRIPT_FOLDER');plotExperimentInvariance('$project','$experiment');\"");	
	}

	sub makeParameterFile {
		
		my ($a, $timeConstant, $stepSizeFraction, $traceTimeConstant) = @_;

		@esRegionSettings = @{$a}; # <== 2h of debuging to find, I have to frkn learn PERL...
		
        my @timeData = localtime(time);
		my $stamp = join(' ', @timeData);

	    my $str = <<"TEMPLATE";
		/*
		*
		* GENERATED IN ParamSearch.pl on $stamp
		*
		* VisBack parameter file
		*
		* Created by Bedeho Mender on 02/02/11.
		* Copyright 2010 OFTNAI. All rights reserved.
		*
		* Note:
		* This parameter file follows the libconfig hierarchical
		* configuration file format, see:
		* http://www.hyperrealm.com/libconfig/libconfig_manual.html#Introducion
		* The values of some parameters may cause
		* other parameters to not be used, but ALL must
		* always be present for parsing.
		* New content adhering to the libconfig standard
		* is not harmful.
		*/
		
		/*
		* Tells run command what type
		* of activation function to use:
		* 0 = rate coded, 1 = leaky integrator
		*/
		neuronType = $neuronType;
		
		continuous : {
		
			/*
			* Time constant of excitatory neurons
			*/
			timeConstant = $timeConstant;
			
			/*
			* This fraction of timeConstant is the step size of the forward euler solver
			*/
			stepSizeFraction = $stepSizeFraction;
			
			/*
			* Time constant of trace term in continous case, analogous
			* to \eta in discrete case.
			*/
			traceTimeConstant = $traceTimeConstant;
			
			/*
			* Time used on each transform, the number of time steps
			* pr. transform is therefor: floor(timePrTransform/(traceTimeConstant * stepSizeFraction));
			*/
			timePrTransform = $timePrTransform;
		};
		
		/*
		* Only used in build command:
		* No feedback = 0, symmetric feedback = 1, probabilistic feedback = 2
		*/
		feedback = 0;
		
		/*
		* Only used in build command:
		* The initial weight set on synapses
		* 0 = zero, 1 = same [0,1] uniform random weight used feedbackorward&backward,
		* 2 = two independent [0,1] uniform random weights used forward&backward
		*/
		initialWeight = 1;
		
		/*
		* What type of weight normalization will be applied after learning.
		* If there is no learning, then there will be no normalization.
		* 0 = none, 1 = classic vector normalization
		*/
		weightNormalization = 1;
		
		/*
		* What type of sparsification routine to apply.
		* 0 = none, 1 = qsort based, 2 = heap based (FAST - recommended)
		*/
		sparsenessRoutine = 2;
		
		/*
		* Whether or not to apply inhibition
		*/
		useInhibition = $useInhibition;
		
		/*
		* ONLY USED IN DISCRETE CASE: 
		* Number of time steps pr. input file,
		* in continous case we use timePrTransform
		
		* In practice MUST be at least the length of pathway (including v1)-1
		* BE AWARE THAT IF THERE IS NO FEEDBACK, THEN THERE IS NO POINT IN HAVING THIS PARAM
		* LARGER THEN SIZE OF EXTRA STRIATE PATHWAY.
		*/
		timeStepsPrInputFile = $timeStepsPrInputFile;
		
		/*
		* Only used in build command:
		* Random seed used to setup initial weight strength
		* and setup connectivity based on radii parameter.
		*/
		seed = 55;
		
		training: {
		
	        /*
	        * What type of learning rule to apply.
	        * 0 = trace, 1 = hebbian
	        */
	        rule = $learningRule;
	
	        /*
	        * Whether or not to reset trace value
	        */
	        resetTrace = $resetTrace;
	
	        /*
	        * ONLY USED IN DISCRETE CASE:
	        * Restrict training in all layers to timesteps for a given transform
	        * that are multiples of this value (= 1 => every time step).
	        */
	        trainAtTimeStepMultiple = $trainAtTimeStepMultiple;
		};
		
		output: {
			/*
			* Parameters controlling what values to output,what layers is governed by "output" parameter in each layer.
			*/
			outputNeurons = false;
			outputWeights = false;
			outputAtTimeStepMultiple = $outputAtTimeStepMultiple;
		
			/*
			* Saving intermediate network states
			* as independent network files
			*/
			saveNetwork = true;
			saveNetworkAtEpochMultiple = $saveNetworkAtEpochMultiple;
			saveNetworkAtTransformMultiple = $saveNetworkAtTransformMultiple; /* This is transform multiples within each epoch, not within each object */
		};
		
		stimuli: {
	        nrOfObjects = $nrOfObjects; /* Number of objects, is not used directly, but rather dumped into output files for matlab convenience */
	        nrOfTransformations = $nrOfTransformations; /* #transforms pr. object, is not used directly, but rather dumped into output files for matlab convenience  */
	        nrOfEpochs = $nrOfEpochs; /* An epoch is one run through the file list, and the number of epochs can be no less then 1 */
		};
		
		v1: {
	        dimension = 128; /* Classic value: 128 */
	
	        /*
	        * The next values are for the parameter values used by the Gabor filter that produced the input to this netwok,
	        * The parameter values are required to be able to deduce the input file names and to process the files properly,
	        * as well as setup V1 structure.
	        * Parameter explanation : http://matlabserver.cs.rug.nl/edgedetectionweb/web/edgedetection_params.html
	        * Good visualization tool : http://www.cs.rug.nl/~imaging/simplecell.html
	        *
	        * NOTE: All filter params except .count must be in decimal form!, otherwise
	        * the libconfig will throw a SettingTypeException exception.
	        */
	        filter: {
                phases = (0.0,180.0,90.0,-90.0);                           /* on/off bar detectors*/
                orientations = (0.0,45.0,90.0,135.0);

                /* lambda is a the param, count is the number of V2 projections from each wavelength (subsampling) */
                /* Visnet values for count: 201,50,13,8 */
                wavelengths = ( $wavelengths );
			};
		};
		
		/*
		* Params controlling extrastriate regions
		*
		* Order is relevant, goes V2,V3,...
		*
		* dimensions                    = the side of a square region. MUST BE EVEN and increasing with layers                                                                  classic: 32,32,32,32
		* fanInRadius                   = radius of each gaussian connectivity cone betweene layers, only used with build command.                                      classic: 6,6,9,12
		* fanInCount                    = Number of connections into a neuron in V3 and above (connections from V1 to V2 have separate param: samplecount)      classic: 272,100,100,100
		* learningRate                  = Learningrates used in hebbian&trace learning.                                                                                                 classic: 25,6.7,5.0,4.0
		* etas                          = Etas used in trace learning in non V1 layers.                                                                                                 classic: 0.8,0.8,0.8,0.8
		* sparsenessLevel               = Sparsity levels used for setSparse routine.                                                                                                   classic: 0.992,0.98,0.88,0.91
		* sigmoidSlope                  = Sigmoid slope used in sigmoid activation function.                                                                                            classic: 190,40,75,26
		* inhibitoryRadius              = Radius (sigma) parameter for inhibitory filter.                                                                                               classic: 1.38,2.7,4.0,6.0
		* inhibitoryContrast            = Contrast (sigma) parameter for inhibitory filter.                                                                                             classic: 1.5,1.5,1.6,1.4
		* inhibitoryWidth               = Size of each side of square inhibitory filter. MUST BE ODD.                                                                           classic: 7,11,17,25
		* saveOutput                            = Whether or not this region is outputted                                                                                                                               ***
		*
		* The following MUST be in decimal format: learningrate,eta,sparsenessLevel,sigmoidSlope,
		*
		*
		*/
		
		extrastriate: (
TEMPLATE

		#my $str = "";
		
		for my $region ( @esRegionSettings ) {
			
			my %tmp = %{ $region }; # <=== perl bullshit

			$str .= "\n\t\t{\n";
			$str .= "\t\tdimension         = ". $tmp{"dimension"} .";\n";
			$str .= "\t\tdepth             = ". $tmp{"depth"} .";\n";
			$str .= "\t\tfanInRadius       = ". $tmp{"fanInRadius"} .";\n";
			$str .= "\t\tfanInCount        = ". $tmp{"fanInCount"} .";\n";
			$str .= "\t\tlearningrate      = ". $tmp{"learningrate"} .";\n";
			$str .= "\t\teta               = ". $tmp{"eta"} .";\n";
			$str .= "\t\tsparsenessLevel   = ". $tmp{"sparsenessLevel"} .";\n";
			$str .= "\t\tsigmoidSlope      = ". $tmp{"sigmoidSlope"} .";\n";
			$str .= "\t\tinhibitoryRadius  = ". $tmp{"inhibitoryRadius"} .";\n";
			$str .= "\t\tinhibitoryContrast= ". $tmp{"inhibitoryContrast"} .";\n";
			$str .= "\t\tinhibitoryWidth   = ". $tmp{"inhibitoryWidth"} .";\n";
			$str .= "\t\t},";
		}
        # Cut away last ',' and add on closing paranthesis and semi-colon
        chop($str);
        return $str." );";
	}