#!/usr/bin/perl
use strict;
use warnings;
use REST::Neo4p;
use Data::Dumper;
REST::Neo4p->connect('http://127.0.0.1:7474');


 open(fp1,'>',"Missed_Probability_log.txt");
my $prob;
 my $q = REST::Neo4p::Query->new(
          "MATCH (n {type: 'cast' }) RETURN n"
         );	

    my $temp1= $q->execute;
   my $i =0;
    while ( $i < $temp1 ){
        my $node1= $q->fetch->[0];
	my    @outgoing_relationships = $node1->get_outgoing_relationships();
	my $relation_prob= sprintf("%.8f", (1 /(scalar @outgoing_relationships))); # Prob based on number of outgoing


	for my $out_relations (@outgoing_relationships){

	 $prob=$out_relations->get_property('weight');
	 if (! defined $prob){ 
         print fp1 " Missed Actor Node : $node1.actor_name ";
        }
       }
	my  @incoming_relationships = $node1->get_incoming_relationships();

	
	for my $in_relations( @incoming_relationships){
	$prob=$in_relations->get_property('weight');
        if (! defined $prob){
         print fp1 " Missed Actor Node : $node1.actor_name";
	 }
        }
	$i++;
}
	close(fp1);

#print fp1 " Actor Name List : \n Dumper $temp1 \n";
