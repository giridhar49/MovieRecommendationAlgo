#!/usr/bin/perl
# This script will fetches the Neo4j graph nodes for the genre names supplied as an input file argument.
# Calculates the weight = 1/n  , n is the number of outgoing edges of nodes(count).
# For each node it will fetch the outgoing edges and incoming edges of Genre node and weight is assigned to it.
# How to run . perl edge_weight.pl filename.txt
# filename.txt - Names of genre is stored here.
use strict;
use warnings;
use List::Util;
use Data::Dumper;
use REST::Neo4p;
use POSIX;

REST::Neo4p->connect('http://127.0.0.1:7474');

open(file_data,'<',$ARGV[0]) or die("cant open the file");

my $file_name ="genre_prob_all_2.txt";
print "\n opening file $file_name";
open(fp1,'>',$file_name);

open(fp2,'>','running_log'); # will have the information about program progress and other required information 
while(<file_data>){
# The input file has all the names of genres . Need to fetch the nodes in graph and assign weight to edge based on number of outgoing links.

my $genre=chomp ($_);
print fp2 "Queried for : $_"; # for checking its running 
my $query=REST::Neo4p::Query->new(
        "MATCH (n { name : '$_'  } ) RETURN n"
        );

 $query->execute();

my    $node1 =  $query->fetch->[0];

my    @outgoing_relationships = $node1->get_outgoing_relationships();

my $relation_prob= sprintf("%.8f", (1 /(scalar @outgoing_relationships))); # Prob based on number of outgoing links

print fp1 'out going weight :'.scalar @outgoing_relationships .'\n ';
print fp1 Dumper(\@outgoing_relationships);

for my $out_relations (@outgoing_relationships){

$out_relations->set_property( { weight => $relation_prob } );
}

my  @incoming_relationships = $node1->get_incoming_relationships();
print fp1 'in coming weight :'.scalar @incoming_relationships .'\n ';
print Dumper \@incoming_relationships;
for my $in_relations( @incoming_relationships){
$in_relations->set_property( { weight => $relation_prob } );
}

print fp1 "\n Probability for $_ is $relation_prob  \n";

}

close(fp1);
close(fp2);
close(file_data);