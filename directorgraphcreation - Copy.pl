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

open(fp1,'>>','director_file_log.txt') or die("cant open the file");

open(fp2,'>>','error_director_log.txt') or die("cant open the file");
# Check if movie exist or not 
while(<file_data>){
    if($i>1){ 
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

#    print "Movie title $movie_title , Netflix id : $netflix_id \t director : $genre for i : $i \n";
#    print "##############################################";
 
$q = REST::Neo4p::Query->new(
          "MATCH (n { movie_id : '$netflix_id' } )RETURN n"
         );	
    my $temp1= $q->execute;
 #   print Dumper(\$temp1);
         if ($temp1 == 0 ) {
    print fp2 " \n Movie  not exist before and query response : $temp1";
    print fp2 "Netflix id : $netflix_id \t Director : $genre \n";
     }
   
#   print "\n Director queried for $genre \n";
 
       $query=REST::Neo4p::Query->new(
        "MATCH (n{director_name : '$genre' }) RETURN n"
        );
  
    my $temp2= $query->execute;

#    print " Genre : Dumper(\$temp2) ";
 
    if($temp1==0 && $temp2==0){
    	   $moviei = REST::Neo4p::Node->new({movie_id => $netflix_id,type=>'movie',title=> $movie_title});
 	   $genrei= REST::Neo4p::Node->new({director_name=> $genre,type=>'director'});	
 	#  print Dumper(\$genrei);
  	  $r1 = $genrei->relate_to($moviei, 'Has director');  
          $r2=  $moviei->relate_to($genrei, 'Has director'); 

   }
   if($temp1==0 && $temp2!=0) {
    #  print "\n creating movie at  \n";
    #     print "Movie title $movie_title , Netflix id : $netflix_id \t Director : $genre for i : $i and  J : $j\n";
              $moviei = REST::Neo4p::Node->new({movie_id => $netflix_id,type=>'movie',title=> $movie_title});
           $temp2 = $query->fetch->[0];
#            print " Genre id : Dumper(\$row) \n";
            $r1 = $temp2->relate_to($moviei, 'Has director'); 
            $r2=  $moviei->relate_to($temp2, 'Has director'); 

    }
    if($temp1!=0 && $temp2==0) {
    #     print "\n creating Genre at  \n";
     #    print "Movie title $movie_title , Netflix id : $netflix_id \t Director  : $genre for i : $i and  J : $j\n";
         $genrei= REST::Neo4p::Node->new({director_name => $genre,type=>'director'});
        $temp1= $q->fetch->[0];
            print " Movie id : Dumper(\$row) \n";
         $r1 = $genrei->relate_to($temp1, 'Has director');  
         $r2=  $temp1->relate_to($genrei, 'Has director'); 

    }
   if($temp1!=0 && $temp2!=0) {
            $temp1 = $q->fetch->[0];
#            print " Movie id : $temp1 \n";
            $temp2 =  $query->fetch->[0];
 #           print " Director  id : $temp2 \n";

 # check if relationship exist already or not 
    my  $query2=REST::Neo4p::Query->new(
   				"MATCH (n { movie_id: '$netflix_id' } )--( m {director_name: '$genre' } ) 
     				 return n ");

       my $temp3=$query2->execute();
  my $query3=REST::Neo4p::Query->new(
   				"MATCH (n { director_name: '$genre' } )--( m { movie_id: '$netflix_id' } ) 
     				 return n ");

       my $temp4 = $query3->execute();
  print "\n relation sattus : $temp3 \n"; 
          if($temp3==0){ # 0 there is no relationship between them before 
           #  print " \n creating only relationship between existing ";
           # print "Movie title $movie_title , Netflix id : $netflix_id \t Director  : $genre for i : $i and  J : $j\n";
            $r1 = $temp2->relate_to($temp1, 'Has director'); 
          }
          if($temp4==0){
          $r2=  $temp1->relate_to($temp2, 'Has director'); 
     }       
    }


  }
 $i++;
} # end of while



 print fp1 "##############################################";
 print fp2 "##############################################";
 print "##############################################";

