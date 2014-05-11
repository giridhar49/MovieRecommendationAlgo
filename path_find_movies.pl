#!/usr/bin/perl
use strict;
use warnings;	
use REST::Neo4p;
use Data::Dumper;
#use POSIX;

REST::Neo4p->connect('http://127.0.0.1:7474');
# open file with results

my $file_2 = "result_$ARGV[0]_movies.txt";
open(fp1,'>',$file_2);
# open the file and assign each line to movie 1
open(file1,'<',$ARGV[0]);

# open the other file and assign each line to movie 2

my $i=1 ;  # Printing Line 1 to see progress  yo
open(file3,'>>','missed_movie_nodes_graph.txt');

while(<file1>){
  print " Line : $i \n";
  my $j=1;
  my $movie1;
  my $movie_title;
  # Parsing watched file for user and storing the movie id into movie1 variable
    foreach my $word(split(',',$_)){
	chomp $word;
	if($j==1) {
	$movie1=$word;
	}
	if($j==2) {
	$movie_title=$word;
	}
   	  $j++;
    }
print "\n movie id is $movie1";
 match_movie($movie1,$ARGV[1]);

}
close();

sub match_movie(){
my $movie1=shift;
my $file=shift;
print "\n file 2 is : $file";
print "\n movie id in match movie is : $movie1";
  # Parsing Non watched file and storing the movie id into movie2 variable
open(file2,'<',$file);
  while(<file2>){
     my $k=1;
     my $movie2;
     my $movie_title2;
    foreach my $word(split(',',$_)){
		chomp $word;
		if($k==1) {
	  	 $movie2=$word;
#	         print fp1 "\n movie 2 : $movie2 \n";
 		}
		if($k==2) {
		 $movie_title2=$word;
	  	}
   	  $k++;
     }

    my $prob=0;
    # Retrieve Lucene index and find the entries for the movies inputs
    my  $index = REST::Neo4p->get_index_by_name('movie_index','node');
    my ($my_node1) = $index->find_entries('movie_id'  => $movie1);
    my ($my_node2) = $index->find_entries('movie_id'  => $movie2);

  # if any one of movie is not in index then log them to a file . It will help in finding why the movie is not present in index.

   if ( ! defined $my_node2) {
    #print Dumper $my_node2;
#     print fp1 "\n  $movie2 , $prob,$movie_title2 \n"; 
    $prob =0;
    print fp1 " $movie1,$movie2,$prob,$movie_title2 \n";
    next;
   }

   if( ! defined $my_node1){
    $prob =0;
    print file3 " $movie1 , $prob,$movie_title2 \n"; 
    $prob =0;
    print fp1 " $movie1,$movie2,$prob,$movie_title2 \n";
    next;
   }
   my $query = REST::Neo4p::Query->new("START n=node(".$my_node1->id."),m=node(".$my_node2->id.")
                                    MATCH p = (n)-[*..2]->(m)
                                    RETURN p");

        my $result=$query->execute;

	#    print "\n Movie 1 : $movie1 and  Node 1 : $my_node1->id Movie 2 :$movie2 and Node 2 : $my_node2->id and  result :$result \n ";
	 #  print Dumper $query;
	#   print Dumper $result;
   if( $result > 0 && defined $result ) {
	  my  $path = $query->fetch->[0];
    	#@nodes = $path->nodes;
	  my  @rels = $path->relationships;
	  for my $relations(@rels){
	    my $temp= $relations->get_property('weight');
            $prob = $prob + $temp;
   	  }
         my $prob1 =sprintf('%.15f',$prob);
 	#print "\n Movie : $movie2 and prob : $prob1 \n";  
        print fp1 "$movie1,$movie2 , $prob1,$movie_title2 \n";
     } 
     else {
    $prob =0;
    print fp1 "$movie1,$movie2,$prob,$movie_title2 \n";
    }
  	#print " Line : $j \n";
 } # End of Not watched list loop

close(file2);
  $i++;
  print " Line : $i \n";
 #} # end of watched list loop
}

sub close(){
close(fp1);
 close(fp2);
close(file1);
close(file3);

}