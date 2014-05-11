
open(file_data,'<',$ARGV[0]) or die("cant open the file");
$i=1;
# Check if movie exist or not 
while(<file_data>){
  #  if($i>1){ 
    my $j=1;
   foreach my $word(split(',',$_))
    {
	chomp $word;
	if($j==1)  { # Id (netflix)
	$netflix_id=$word;
	} 
	if($j==2) {
	$genre=$word;
#      print "\n actor : $genre \n";
	}
#	if($j==3) {
#	$movie_title=$word;
#	}

   	  $j++;
   }

   print " Netflix id : $netflix_id \t actor : $genre for i : $i \n";
$i++;

}