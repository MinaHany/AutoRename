
$ARGV[0]=~ s/(.+)\\[^\\]+/$1/g;

opendir $dir, $ARGV[0];
@files= readdir $dir;
closedir $dir;

@videos= grep(/.*\.mkv$|.*\.mp4$|.*\.avi$/, @files);
for $i (0 .. $#videos){
	if($videos[$i] =~ m/\Wsample\W/){
		splice(@videos, $i, 1);
		last;
	}
}	

@subs= grep(/.*\.srt$/, @files);

if(@subs > 0 and @videos > 0){
	if(@videos == 1 and @subs == 1){
		$videos[0]=~ s/(.+)\..../$1/;
		rename "$ARGV[0]"."\\"."$subs[0]", "$ARGV[0]"."\\"."$videos[0]".".srt";
	}	
	else{
		for $video (@videos){
			$epv= $video;
			#print $epv."\n";
			if($epv=~ m/(S\d\dE\d\d)/ or $epv=~ m/(\d+x\d\d)/){
				$epv= $1;
				$epv=~ s/\D//g;
				$epv= "0".$epv if length($epv) == 3;
			}	
			else{
				next;
			}	
			for $sub (@subs){
				$eps= $sub;
				if($eps=~ m/(S\d\dE\d\d)/ or $eps=~ m/(\d+x\d\d)/){
					$eps= $1;
					$eps=~ s/\D//g;
					$eps= "0".$eps if length($eps) == 3;
					print $eps."\n";
				}	
				else{
					next;
				}	
				if($eps eq $epv){
					rename "$ARGV[0]"."\\"."$sub", "$ARGV[0]"."\\"."$video".".srt";
					last;
				}
			}
		}
	}		
}