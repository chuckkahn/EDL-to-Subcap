# script to format EDL into subcap

use utf8;

@EDLS = ( "RSM 211 LOCK v1.edl", "RSM 211 LOCK v2.edl", "RSM 211 LOCK v3.edl" );

foreach $EDL (@EDLS)
{
	open EDL, $EDL or die $!;

	while ($record = <EDL>)
	{
#		print "[$record -xxxxx]\n";
		if ($record =~ /(\d\d.\d\d.\d\d.\d\d) (\d\d.\d\d.\d\d.\d\d) (\d\d.\d\d.\d\d.\d\d) (\d\d.\d\d.\d\d.\d\d)/ms)
		{
			$in = $3;
			$out{$in} = $4;
			$done = 0;
		}
		if ($record =~ /LOC\: \d\d.\d\d.\d\d.\d\d Green (.*)/ )
		{
			$marker{$in} = $1;
			$marker{$in} =~ s/^\s+//;
			$marker{$in} =~ s/\r\n?//g;
			
			$done = 1;
		}
		elsif ( ($record =~ /^\* (.*)/ ) && ($done == 1) )
		{
			$marker2 = $1;
			$marker2 =~ s/^\s+//;
			$marker2 =~ s/\r\n?//g;
			print $marker2 . "\n";

			$marker{$in} = $marker{$in} . " \n" . $marker2;
			print $marker{$in} . "\n";
			$done = 1;
		}
	}
	close (EDL);
}


$subcap = "RSM 212 Subcap.txt";

open SUBCAP, ">$subcap";

print SUBCAP "<begin subtitles>";

@in = sort keys %marker;

foreach $in (@in)
{
#	print $in "is in\n";
	print SUBCAP "\n\n$in $out{$in}\n";
	print SUBCAP $marker{$in} . "  ";
}
	

print SUBCAP "\n\n<end subtitles>\n";

close (SUBCAP);


# print to subcap




