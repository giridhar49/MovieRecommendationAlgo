#!/usr/bin/perl
use strict;
use warnings;
use REST::Neo4p;
use Data::Dumper;
REST::Neo4p->connect('http://127.0.0.1:7474');


 open(fp1,'>',"Director_Probability_Log_new.txt");

 my $q = REST::Neo4p::Query->new(
          "MATCH (n {type: 'actor' }) RETURN n"
         );	

    my $temp1= $q->execute;

 print fp1 "\n Result count : $temp1 \n ";

print fp1 " ###############################################333";
   my $i =0;
    while ( $i < $temp1 ){
        my $node1= $q->fetch->[0];
	my    @outgoing_relationships = $node1->get_outgoing_relationships();
	my $relation_prob= sprintf("%.8f", (1 /(scalar @outgoing_relationships))); # Prob based on number of outgoing links

	print fp1 'out going weight :'.scalar @outgoing_relationships .'\n ';
        print 'out going weight :'.scalar @outgoing_relationships .'\n '; 
	print fp1 Dumper(\@outgoing_relationships);

	for my $out_relations (@outgoing_relationships){

	$out_relations->set_property( { weight => $relation_prob } );
	}

	my  @incoming_relationships = $node1->get_incoming_relationships();
	print fp1 'in coming weight :'.scalar @incoming_relationships .'\n ';
        print 'in coming weight :'.scalar @incoming_relationships .'\n ';
	print Dumper \@incoming_relationships;
	
	for my $in_relations( @incoming_relationships){
	$in_relations->set_property( { weight => $relation_prob } );
	}
#	$i++;
	print fp1 "\n Probability for $_ is $relation_prob  \n";

	print fp1 "\n ######################################################### \n\n\n";


	print fp1 "\n $i number of nodes queried so for \n";
        print " \n line : $i \n";

        print fp1 " ###############################################333";
        $i++;
}
	close(fp1);

#print fp1 " Actor Name List : \n Dumper $temp1 \n";
