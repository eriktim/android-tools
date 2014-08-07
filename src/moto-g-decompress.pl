# original script by carock
# @see http://forum.xda-developers.com/showpost.php?p=48891456&postcount=140
#
# modified by gingerik
# @see https://github.com/gingerik

use strict;
use warnings;

my $file = $ARGV[0];
chomp($file);

my $pfile = "temp.raw";

open(FH, "<", $file) or die "cannot open $file: $!";
open(pFH, ">>", $pfile) or die "cannot open $file: $!";
binmode(pFH);
binmode(FH);

$/ = \1;
my $data;
my $temp;
my $id;
my $nump;
my $i;

while (<FH>)
{
	$data = unpack 'H*', $_;
	$id = substr($data, 0, 1);

	if($id eq "8")
	{
		$temp = <FH>;
		$temp = unpack 'H*', $temp;
		$nump = substr($data, 1, 1).$temp;
		$nump = hex($nump);
		$temp = <FH>.<FH>.<FH>;
		$data = unpack 'H*', $temp;
		$data = pack 'H*', $data;

		for ($i=0; $i < $nump; $i++)
		{
			print pFH $data;
		}
	}
	elsif($id eq "0")
	{
		$temp = <FH>;
		$temp = unpack 'H*', $temp;
		$nump = substr($data, 1, 1).$temp;
		$nump = hex($nump);

		for ($i=0; $i < $nump; $i++)
		{
			$temp = <FH>.<FH>.<FH>;
			$data = unpack 'H*', $temp;
			$data = pack 'H*', $data;

			print pFH $data;
		}
	}
}

close(pFH);
close(FH);

