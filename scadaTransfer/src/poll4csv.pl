#!/usr/bin/perl

use warnings;
use strict;
use File::Basename;
use File::Copy "mv";

my $verstring = '$Revision$ ';
$verstring =~ s/^\$Revision: //;
$verstring =~ s/ \$//;

my $appdir = $ENV{"HDB_ENV"};

#check to see command line usage.
my $progname = basename($0);
chomp $progname;

my ($polldir, $archivedir, $pattern, @files, $file, $accountfile);
my (@crspfiles, $crspfile, $newcrspfile, @dates, $date);

while (@ARGV)
{
  my $arg = shift(@ARGV);
  if ($arg =~ /-h/) {	        # print help
    usage();
  } elsif ($arg =~ /-v/) {	# print version
    version();
  } elsif ($arg =~ /-a/) {	# get hdb login file
    $accountfile=shift(@ARGV);
  } elsif ($arg =~ /-f/) {	# get csv filename pattern
    $pattern = shift(@ARGV);
  } elsif ($arg =~ /-d/) {	# get directory to check
    $polldir = shift(@ARGV);
    if (! -d $polldir) {
      print "polling directory not found: $polldir\n";
      usage();
    }
  }
}

if (!defined($accountfile)) {
  print "Error! No HDB login file!\n";
  usage();
}

if (!defined($polldir)) {
  print "Must specify directory to watch!\n";
  usage();
}

if (!defined($pattern)) {
  print "Must specify filename pattern to watch for!\n";
  usage();
}

$archivedir=$appdir . "/scadaTransfer/work/old_csv";

chdir $polldir;

#run this loop forever
while (1) {
#check the directory specified for files beginning with $pattern
  opendir(DIR, $polldir) || die "opendir of $polldir failed: $!";
  @files = grep { /^$pattern/ && -f "$polldir/$_" } readdir(DIR);
  closedir DIR;

  undef @dates;

  #if any new files, 
  # run parsecsv.pl to create separate crsp_ files for each day
  # run the loading script against them, and then
  # move the crsp_ files to the old_files subdir and
  # move the csv file to old_csv subdir
  if (@files) {
    sleep 10; # wait for gefrx to finish checking the file before moving it!
    foreach $file (@files) {

      my @program=("perl","$appdir/scadaTransfer/src/parsecsv.pl","-f","$polldir/$file");
      system (@program) == 0 or die "Failed to run parsecsv.pl!\n $!";

      #read the directory again to find all crsp_20* files 
      # have to do this since the old scada files are crsp_ as well, they
      # just use a two digit year instead of four.
      # watch out for the Y2.1K bug!
      opendir(DIR, $polldir) || die "opendir of $polldir failed: $!";
      @crspfiles = grep { /^crsp_20/ && -f "$polldir/$_" } readdir(DIR);
      closedir DIR;

      # now for each crsp file created by parsecsv.pl, run the loading script
      foreach $crspfile (@crspfiles) {
        my @program=("perl","$appdir/scadaTransfer/src/scada2hdb.pl","-a",$accountfile,"-f","$polldir/$crspfile");
        system (@program) == 0 or die "Failed to run scada2hdb.pl!\n $!";
      # move processed crspfile to old_files
        $newcrspfile=$crspfile;
        while (-e "$appdir/scadaTransfer/work/old_files/$newcrspfile") {
          $newcrspfile =~ s/dat$/update.dat/;
        }
        mv "$polldir/$crspfile", "$appdir/scadaTransfer/work/old_files/$newcrspfile" or
           die "Failed to move file: $crspfile\n$!\n";
      }

      #now move processed csv file to command line specified directory
      mv "$polldir/$file","$archivedir/$file" or
         die "Failed to move file: $file\n$!\n";

      #get the date for all of the crsp files created by parsecsv
      grep {/20(\d\d\w\w\w\d\d)/ && push @dates, $1 } @crspfiles;
    }

#then run derivation for specified SDIs, only need to do this after each set of
#files processed, not for each file.
#    system ("../src/derive_scada") == 0 or warn "SCADA Derivation failed!\n";
#      print "$file\n";

# we need to try and create Glen total release here. But for which day?
# We assume here that power release was computed by the AVM process
#
#    for $date (@dates) {
#      system ("glenTotRelease app_user uchdb2 $date") == 0 or
#        warn "glenTotRelease failed!\n";
#    }
#    system ("../src/derive_tot") == 0 or warn "Total Release Derivation failed!\n";

#  the following processed was removed by M. Bogner on 21-March-2011
# it is believed this data move functionality is no longer needed since Hydromet no longer exists
#sleep for 10 seconds to let daily computations complete
#sleep 10;
# attempt to ship scada data to hydromet
#    for $date (@dates) {
#      system ("scadaData app_user uchdb2 $date") == 0 or
#        warn "scadaData failed.\n";
#    }
  }
  sleep 60;
}

sub usage
{
  print STDERR <<"ENDHELP";
$progname [ -h | -v ] | [ options ]
Watches a specified directory for filenames beginning with a pattern every 60
seconds. Runs scada2hdb.pl on matching files, then moves the file to the
archives subdirectory.
Example: $progname -d <directory> -a <accountfile> -f <pattern>

  -h               : This help
  -v               : Version
  -a <accountfile> : HDB account login file (REQUIRED)
  -f <filename pattern>    : file pattern to watch for csv files(REQUIRED)
  -d <directory>   : directory to watch for files with right pattern (REQUIRED)
ENDHELP

  exit (1);
}

sub version
{
  print "$progname version $verstring\n";
  exit 1;
}
