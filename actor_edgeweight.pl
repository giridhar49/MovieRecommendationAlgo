#!/usr/bin/perl
use strict;
use warnings;
use List::Util;
use Data::Dumper;
use REST::Neo4p;
use POSIX;

REST::Neo4p->connect('http://127.0.0.1:7474');

open(file_data,'<',$ARGV[0]) or die("cant open the file");

my $file_name ="genre_prob_all_2.txt";
print "\n opening file $ARGV[0]";
open(fp1,'>>',$file_name);


while(<file_data>){
#my $genre=chomp ($_);
print "Queried for : $_";
# Get the outlinks for each genre ( hard coding it now . But will read it from file and automate the link weights)
my $query=REST::Neo4p::Query->new(
        "MATCH (n { actor_name : '$_'  } ) RETURN n"
        );
print Dumper $query;
print  $query->execute();

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

print fp1 "\n ######################################################### \n\n\n";
}

close(fp1);
close(file_data);