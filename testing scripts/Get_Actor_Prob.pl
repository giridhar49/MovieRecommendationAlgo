#!/usr/bin/perl
use strict;
use warnings;
use REST::Neo4p;
use Data::Dumper;
REST::Neo4p->connect('http://127.0.0.1:7474');

# open(fp2,'>',"Actor_Names_From_Graph.txt");
 open(fp1,'>',"DirectorProb_Names_fetch_log.txt");

 my $q = REST::Neo4p::Query->new(
          "MATCH (n {type: 'actor' }) RETURN n"
         );	

    my $temp1= $q->execute;

print fp1 " ###############################################333";
   my $i =0;
    while ( $i < $temp1 ){
        my $node1= $q->fetch->[0];
	my    @outgoing_relationships = $node1->get_outgoing_relationships();
	my $relation_prob= sprintf("%.8f", (1 /(scalar @outgoing_relationships))); # Prob based on number of outgoing 

	for my $out_relations (@outgoing_relationships){

	$relation_prob =$out_relations->set_property( { weight => $relation_prob } );
	}
       print fp1 "\n Out Probability for $_ is $relation_prob  \n";
     print $i;
	my  @incoming_relationships = $node1->get_incoming_relationships();

	for my $in_relations( @incoming_relationships){
	$relation_prob =$in_relations->get_property('weight => $relation_prob');
	}
	$i++;
	print fp1 "\n Probability for $_ is $relation_prob  \n";
        print fp1 " ###############################################333";
        $i++;
}
	close(fp1);

#print fp1 " Actor Name List : \n Dumper $temp1 \n";
