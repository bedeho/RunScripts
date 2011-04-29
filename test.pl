#!/usr/bin/perl

	use File::Copy;

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

die "hello";

my $dir = '/Network/Servers/mac0.cns.ox.ac.uk/Volumes/Data/Users/mender/Dphil/Projects/VisBack/Simulations/1Object';

opendir(DIR, $dir) or die $!;

while (my $file = readdir(DIR)) {

   # We only want files
   next unless (-f "$dir/$file");

   # Use a regular expression to find files ending in .txt
   next unless ($file =~ m/Network.txt$/);
   
   $z = substr $file, 0, length($file) - 4;

   print "$z\n";
}

closedir(DIR);