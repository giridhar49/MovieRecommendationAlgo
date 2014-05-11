#!/usr/bin/perl
use strict;
use warnings;
use List::Util;
use Data::Dumper;
use REST::Neo4p;
 use POSIX;
REST::Neo4p->connect('http://127.0.0.1:7474');

    my $i=1;
    my $netflix_id ;
    my $movie_title;
    my $genre;
    my $genrei;
    my $r1;
    my $moviei;
    my $q;
    my $query;
    my $row;
    my $r2;
print "\n file name : $ARGV[0] \n";


open(file_data,'<',$ARGV[0]) or die("cant open the file");


open(fp1,'>>','actor_file_log.txt') or die("cant open the file");


open(fp2,'>>','error_actor_log.txt') or die("cant open the file");
 print fp1 "\n file name : $ARGV[0] \n";
 print fp2 "\n file name : $ARGV[0] \n";

 print fp1 "##############################################";
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
     print fp1 "\n actor : $genre \n";
	}
#	if($j==3) {
#	$movie_title=$word;
#	}

   	  $j++;
   }

#    print "Movie title $movie_title , Netflix id : $netflix_id \t actor : $genre for i : $i \n";

 
$q = REST::Neo4p::Query->new(
          "MATCH (n { movie_id : '$netflix_id' } )RETURN n"
         );	
    my $temp1= $q->execute;

  
      
    if ($temp1 > 0 ) {
    print fp2 " \n Movie sattus : $temp1";
    print "Netflix id : $netflix_id \t Actor : $genre \n";
     }

    print fp1 " Movie : Dumper(\$temp1) ";

  
  print fp1 "\n genre queried for $genre \n";
 
       $query=REST::Neo4p::Query->new(
        "MATCH (n{actor_name : '$genre' }) RETURN n"
        );
  
    my $temp2= $query->execute;

    print fp1 " Actor : Dumper(\$temp2) ";
 
    if($temp1==0 && $temp2==0){
    	 #  $moviei = REST::Neo4p::Node->new({movie_id => $netflix_id,type=>'movie',title=> $movie_title});
           $moviei = REST::Neo4p::Node->new({movie_id => $netflix_id,type=>'movie'});
 	   $genrei= REST::Neo4p::Node->new({actor_name=> $genre,type=>'cast'});	
 	  print " Actor : Dumper(\$genrei) \n";
  	  $r1 = $genrei->relate_to($moviei, 'Has actor');  
          $r2=  $moviei->relate_to($genrei, 'Has actor'); 

   }
   if($temp1==0 && $temp2!=0) {
    #  print "\n creating movie at  \n";
    #     print "Movie title $movie_title , Netflix id : $netflix_id \t $genre : $genre for i : $i and  J : $j\n";
         #     $moviei = REST::Neo4p::Node->new({movie_id => $netflix_id,type=>'movie',title=> $movie_title});
           $moviei = REST::Neo4p::Node->new({movie_id => $netflix_id,type=>'movie'});
           $temp2 = $query->fetch->[0];
           print fp1 " Genre id : Dumper(\$row) \n";
            $r1 = $temp2->relate_to($moviei, 'Has actor'); 
            $r2=  $moviei->relate_to($temp2, 'Has actor'); 

    }
    if($temp1!=0 && $temp2==0) {
         print fp1 "\n creating Actor at ";
         print fp1 "Netflix id : $netflix_id \t Actor : $genre for i : $i and  J : $j\n";
         $genrei= REST::Neo4p::Node->new({actor_name => $genre,type=>'cast'});
        $temp1= $q->fetch->[0];
            print fp1 " Movie id : Dumper(\$row) \n";
         $r1 = $genrei->relate_to($temp1, 'Has actor');  
         $r2=  $temp1->relate_to($genrei, 'Has actor'); 

    }
   if($temp1!=0 && $temp2!=0) {
            $temp1 = $q->fetch->[0];
           print fp1 " Movie id : $temp1 \n";
            $temp2 =  $query->fetch->[0];
          print fp1 " Genre id : $temp2 \n";

 # check if relationship exist already or not 
    my  $query2=REST::Neo4p::Query->new(
   				"MATCH (n { movie_id: '$netflix_id' } )--( m {actor_name: '$genre' } ) 
     				 return n ");

       my $temp3=$query2->execute();
  my $query3=REST::Neo4p::Query->new(
   				"MATCH (n { actor_name: '$genre' } )--( m { movie_id: '$netflix_id' } ) 
     				 return n ");

       my $temp4 = $query3->execute();
  print fp1 "\n relation sattus : $temp3 \n"; 
          if($temp3==0){ # 0 there is no relationship between them before 
             print fp1 " \n creating only relationship between existing ";
            print fp1 "Netflix id : $netflix_id \t $genre : $genre for i : $i and  J : $j\n";
            $r1 = $temp2->relate_to($temp1, 'Has actor'); 
          }
          if($temp4==0){
       $r2=  $temp1->relate_to($temp2, 'Has actor'); 
     }       
    }

print "\n line no : $i ";
 # }
 $i++;
} # end of while

 print fp1 "##############################################";
 print fp2 "##############################################";
 print "##############################################";





