#!/usr/bin/perl

# COMMAND LINE ARGUMENTS
# $1: project name : e.g. VisBack
# $2: experiment name: e.g. Working
# $3: randomize names (yes/no), default is yes

########################################################################################
# Setup
########################################################################################

my $SLASH = "/"; # Change to \ on windows

#$PROJECTS_FOLDER = "/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/";
my $PROJECTS_FOLDER = "d:/Oxford/Work/Projects/";

my $PERL_RUN_SCRIPT = "C:/MinGW/msys/1.0/home/Mender/Run.pl";

########################################################################################

	if($#ARGV < 0) {

	        print "To few arguments passed.\n";
	        print "Usage:\n";
	        print "Arg. 1: project name, default is VisBack\n";
	        print "Arg. 2: experiment name, default is 1Object\n";
                print "Arg. 3: randomize names (yes/no), default is yes\n";
	        exit;
	}

        my $project;
	if($#ARGV >= 0) {
	        $project = $ARGV[0];
        }
	else {
        	$project = "VisBack";
        }

        my $experiment;
	if($#ARGV >= 1) {
	        $experiment = $ARGV[1];
        }
	else {
	        $experiment = "1Object";
        }

        # Generate the random string to slap in front of file names
        my $random_string = &generate_random_string(4);
        if($#ARGV >= 2 && $ARGV[2] == "no") {
	        $random_string = "";
        }

        my $experimentFolder = $PROJECTS_FOLDER.$project.$SLASH."Simulations".$SLASH.$experiment.$SLASH;
        my $untrainedNet = $experimentFolder."BlankNetwork.txt";

        # Build template parameter file from these
        my $pathWayLength		= 4;
        my @dimension			= (32,32,32,32);
        my @depth			= (1,1,1,1);
        my @fanInRadius 		= (6,6,9,12);
        my @fanInCount 			= (100,100,100,100);
        my @learningrate		= ("0.1","0.1","0.1","0.1");
        my @eta				= ("0.8","0.8","0.8","0.8");
        my @sparsenessLevel		= ("0.98","0.98","0.98","0.98");
        my @sigmoidSlope 		= ("190.0","40.0","75.0","26.0");
        my @inhibitoryRadius		= ("1.38","2.7","4.0","6.0");
        my @inhibitoryContrast		= ("1.5","1.5","1.6","1.4");
        my @inhibitoryWidth		= (7,11,17,25);

        my @esRegionSettings;
        for(my $r = 0;$r < $pathWayLength;$r++) {

	        %region   = ('dimension'          =>      $dimension[$r],
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
        my @nrOfEpochs			= (20,50,100,200,300,500);
        my @trainAtTimeStepMultiple	= (1,4);
        my @learningRates 		= ("1.0","2.0","4.0","10.0");
        # my @sparsenessLevel		= ("0.96","0.97","0.98","0.99");

        for my $e (@nrOfEpochs) {
        	for my $t (@trainAtTimeStepMultiple) {
                	for my $l (@learningRates) {

                        for $region ( @esRegionSettings ) {
                        	$region{'learningrate'} = $l;
                        }

                        my $simulationCode = "_E" . $e . "_T" . $t . "_L" . $l;

	                # New folder name for this iteration
	                my $simulation = $random_string . $simulationCode;

                       	my $experimentFolder = $PROJECTS_FOLDER.$project.$SLASH."Simulations".$SLASH.$experiment.$SLASH;
			my $simulationFolder = $experimentFolder.$simulation.$SLASH;
                        my $parameterFile = $simulationFolder."Parameters.txt";

                        if(!(-d $simulationFolder)) {

                                # Make simulation folder
                                print "Making new simulation folder: " . $simulationFolder . "\n";
                                mkdir($simulationFolder, 0777) || print $!;

                                # Make parameter file and write to simulation folder
                                print "Writing new parameter file: ". $simulationCode ." \n";
                                my $result = makeParameterFile($e, $t, @esRegionSettings);

                                open (MYFILE, '>>'.$parameterFile);
                                print MYFILE $result;
                                close (MYFILE);

                                # Run training
                                system($PERL_RUN_SCRIPT, "train", $project, $experiment, $simulation);

                                # Run test
                                system($PERL_RUN_SCRIPT, "test", $project, $experiment, $simulation);
                        } else {
                                print "Could not make folder: " . $simulationFolder . "\n";
                                exit;
                        }
                	}
                }
        }

	sub makeParameterFile {

                my ($nrOfEpochs, $trainAtTimeStepMultiple, @esRegionSettings) = @_;

                @timeData = localtime(time);
		$stamp = join(' ', @timeData);

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
* 0 = rate coded, 1 ?= leaky integrator
*/
neuronType = 0;

/*
* Only used in build command:
* No feedback = 0, symmetric feedback = 1, probabilistic feedback ?= 2
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
useInhibition = true;

/* Number of time steps pr. input file, in practice MUST be at least the length of pathway (including v1)-1
   BE AWARE THAT IF THERE IS NO FEEDBACK, THEN THERE IS NO POINT IN HAVING THIS PARAM
   LARGER THEN SIZE OF EXTRA STRIATE PATHWAY.*/
timeStepsPrInputFile = 4;

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
        rule = 0;

        /*
        * Whether or not to reset trace value
        */
        resetTrace = true;

        /*
        * Restrict training in all layers to timesteps for a given transform
        * that are multiples of this value (= 1 => every time step).
        */
        trainAtTimeStepMultiple = $trainAtTimeStepMultiple;
};

output: {
        /*
        * Parameters controlling what values to output,what layers is governed by "output" parameter in each layer. */
        /*
        firingRate = true;
        inhibitedActivation = false;
        activation = true;
        */
        weights = true;
        outputAtTimeStepMultiple = 4;
        saveNetworkAtEpochMultiple = 5;
};

stimuli: {
        nrOfObjects = 1; /* Number of objects, is not used directly, but rather dumped into output files for matlab convenience */
        nrOfTransformations = 9; /* #transforms pr. object, is not used directly, but rather dumped into output files for matlab convenience  */
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
                phases = (0.0,180.0);                           /* on/off bar detectors*/
                orientations = (0.0,45.0,90.0,135.0);

                /* lambda is a the param, count is the number of V2 projections from each wavelength (subsampling) */
                /* Visnet values for count: 201,50,13,8 */
                wavelengths = ( {lambda = 4; fanInCount = 201;} );
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

                for $region ( @esRegionSettings ) {

                	$str .= "\n\t\t{\n";
	                $str .= "\t\tdimension         = ". $region{"dimension"} .";\n";
	                $str .= "\t\tdepth             = ". $region{"depth"} .";\n";
	                $str .= "\t\tfanInRadius       = ". $region{"fanInRadius"} .";\n";
	                $str .= "\t\tfanInCount        = ". $region{"fanInCount"} .";\n";
	                $str .= "\t\tlearningrate      = ". $region{"learningrate"} .";\n";
	                $str .= "\t\teta               = ". $region{"eta"} .";\n";
	                $str .= "\t\tsparsenessLevel   = ". $region{"sparsenessLevel"} .";\n";
	                $str .= "\t\tsigmoidSlope      = ". $region{"sigmoidSlope"} .";\n";
	                $str .= "\t\tinhibitoryRadius  = ". $region{"inhibitoryRadius"} .";\n";
	                $str .= "\t\tinhibitoryContrast= ". $region{"inhibitoryContrast"} .";\n";
	                $str .= "\t\tinhibitoryWidth   = ". $region{"inhibitoryWidth"} .";\n";
	                $str .= "\t\t},";
                }

	        # Cut away last ',' and add on closing paranthesis and semi-colon
                chop($str);
	        $str .= " );";

                return $str;
	}


###########################################################
# Written by Guy Malachi http://guymal.com
# 18 August, 2002
###########################################################

# This function generates random strings of a given length
sub generate_random_string
{
	my $length_of_randomstring=shift;# the length of
			 # the random string to generate

	my @chars=('a'..'z','A'..'Z','0'..'9','_');
	my $random_string;
	foreach (1..$length_of_randomstring)
	{
		# rand @chars will generate a random
		# number between 0 and scalar @chars
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}