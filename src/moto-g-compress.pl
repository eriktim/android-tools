# original script by carock
# @see http://forum.xda-developers.com/showpost.php?p=48891456&postcount=140
#
# modified by gingerik
# @see https://github.com/gingerik

use strict;
use warnings;

my $file = $ARGV[0];
my $pfile = "logo_boot.bin";
my $xres = 720;

open(FH, "<", $file) or die "cannot open $file: $!";
binmode(FH);
local $/;
my @hex = unpack '(H6)*', <FH>;
close (FH);

open(pFH, ">", $pfile) or die "cannot open $pfile: $!";
binmode(pFH);

my $data;
my $i;
my $id = 0;
my $max = 0;

#compress raw 24bit BGR file in motorola boot logo format
MAIN: for ($i=0; $i <= $#hex; $i++)
{
	if(($hex[$i] eq $hex[$i+1]) && ($hex[$i+1] eq $hex[$i+2]))
	{
		$data = $hex[$i];
		$id++;
		$max++;
		$i++;

		#edge case
		if(($max+1)>=$xres)
		{
			$id++;
			$id = sprintf("8%03x", $id);
			$id = pack 'H*', $id;
			print pFH $id;
			$id = 0;			

			$data = pack 'H*', $data;
			print pFH $data;

			$max=0;			
			next MAIN;
		}
		else
		{
			while($hex[$i] eq $hex[$i+1])
			{
				$id++;
				$max++;
				$i++;

				if(($max+1)>=$xres)
				{
					$id++;
					$id = sprintf("8%03x", $id);
					$id = pack 'H*', $id;
					print pFH $id;
					$id = 0;			

					$data = pack 'H*', $data;
					print pFH $data;

					$max=0;			
					next MAIN;
				}
			}
		}
		
		$id++;
		$max++;

		if(($max+1)>=$xres)
		{
			$max=0;
		}

		$id = sprintf("8%03x", $id);
		$id = pack 'H*', $id;
		print pFH $id;
		$id = 0;
	}
	else
	{

		$data = $hex[$i];
		$id++;
		$max++;
		#$i++;

		#edge case
		if($max==$xres)
		{
			$id = sprintf("8%03x", $id);
			$id = pack 'H*', $id;
			print pFH $id;
			$id = 0;
	
			$data = pack 'H*', $data;
			print pFH $data;

			$max=0;			
			next MAIN;
		}
		else
		{
			while(($hex[$i+1] ne $hex[$i+2]) || ($hex[$i+2] ne $hex[$i+3]))
			{
				$id++;
				$max++;
				$i++;
				$data = $data.$hex[$i];

				if($max==$xres)
				{
					$id = sprintf("%04x", $id);
					$id = pack 'H*', $id;
					print pFH $id;
					$id = 0;			

					$data = pack 'H*', $data;
					print pFH $data;

					$max=0;			
					next MAIN;
				}
			}
		}
	
		$id = sprintf("%04x", $id);
		$id = pack 'H*', $id;
		print pFH $id;
		$id = 0;
	}

	$data = pack 'H*', $data;
	print pFH $data;
}

close(pFH);


#update file size in header of modified bin file
open(FH, "<logo.bin") or die "cannot open logo.bin: $!";
binmode(FH);
local $/;
@hex = unpack '(H2)*', <FH>;
close (FH);

open(pFH, ">logo-custom.bin") or die "cannot open logo-custom.bin: $!";
binmode(pFH);

for ($i=0; $i <= 104; $i++)
{
	print pFH (pack 'H*', $hex[$i]);
}

my $size = -s $pfile;
$size = $size + 12;
$size = sprintf("%06x",$size);
$size = substr($size,4,2).substr($size,2,2).substr($size,0,2);
print pFH (reverse pack 'H*', $size);

for ($i=108; $i <= $#hex; $i++)
{
	print pFH (pack 'H*', $hex[$i]);
}

close(pFH);

