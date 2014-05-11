#!/usr/bin/perl
# This script will fetches the Neo4j graph nodes for the genre names supplied as an input file argument.
# Calculates the weight = 1/n  , n is the number of outgoing edges of nodes(count).
# For each node it will fetch the outgoing edges and incoming edges of Genre node and weight is assigned to it.
# How to run . perl edge_weight.pl 0/1 
# filename.txt - Names of genre is stored here.
use strict;
use warnings;
use REST::Neo4p;
use Data::Dumper;
REST::Neo4p->connect('http://127.0.0.1:7474'); 
my $file1 = "Index_log_$ARGV[1].txt";
open(fp1,'>',$file1);
if( $ARGV[0] == 0) {
 $index = REST::Neo4p->get_index_by_name('movie_index','node'); # Fetch the index if the script argument is 0
 print "index : $index\n";
 }
else { # create index if argument option is not 0 
  $index = REST::Neo4p->get_index_by_name('movie_index','node');
  $index->remove();
  $index = REST::Neo4p::Index->new('node', 'movie_index');
}  

   print fp1 " \n Index : $index \n";

    my $q = REST::Neo4p::Query->new(
          "MATCH (n {type: 'movie' }) RETURN n.movie_id"
         );

  $temp1= $q->execute;
  print fp1 " result :  $temp1 \n ";

   my $i =0;
    while ( $i < $temp1 ){	
   my $node1= $q->fetch->[0];
   if($node1 < $ARGV[1] && $node1 >= $ARGV[2]){
    print fp1 "\n Node : $node1  \n";
   
     my $q2= REST::Neo4p::Query->new(
          "MATCH (n { movie_id: '$node1' }) RETURN n"
         );
     my $res= $q2->execute();
    print fp1 "\n Node 1 : $node1";
       print $res2;
     my $node= $q2->fetch->[0];
         
    print fp1 " Node 2 : $node";
    print fp1 " Index created for movie id $node1 ";	
    print fp1 "\n ############################### \n";
    $index->add_entry( $node, 'movie_id' => $node1 );
 # now create index for node 
     print fp1 $node;
 print fp1 "\n Line : $i";
 print "\n Node 1 : $node1"; 
   }
 #print "\n Line : $i";
 $i++;
}
print fp1 " \n total number of nodes $temp1 \n";