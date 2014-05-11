#!/usr/bin/perl
use strict;
use warnings;
use REST::Neo4p;
use Data::Dumper;
REST::Neo4p->connect('http://127.0.0.1:7474');

 open(fp1,'>',"Count_Neo4j_NODES_all.txt");

 my $q = REST::Neo4p::Query->new(
          "MATCH (n { type: 'movie'} )  RETURN ' There are count(n) movies '"
         );	

    my $temp1= $q->execute;

print fp1 " Movie : $temp1";


$q = REST::Neo4p::Query->new(
          "MATCH (n { type: 'genre'} )  RETURN 'There are count(n) Genres' "
         );	
 $temp1= $q->execute;

print fp1 " GENRE : $temp1";


$q = REST::Neo4p::Query->new(
          "MATCH (n { type: 'cast'} )  RETURN ' There are count(n) actors '"
         );	
  $temp1= $q->execute;

print fp1 "Actors : $temp1";

$q = REST::Neo4p::Query->new(
          "MATCH (n { type: 'actor'} )  RETURN ' There are count(n.director_name) directors' "
         );	
 $temp1= $q->execute;

print fp1 " Directors : $temp1" ;
