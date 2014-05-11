 use REST::Neo4p;
 use Data::Dumper;
  REST::Neo4p->connect('http://127.0.0.1:7474');
# create a lucene index for movies 
print "\n creating index \n";
#  $i = REST::Neo4p::Index->new('node', 'my_node_index');
 $i = REST::Neo4p::Index->new('node', 'movie_index');
 
 my $q = REST::Neo4p::Query->new(
          "MATCH (n { name : '$ARGV[0]' } )RETURN n"
         );	
    my $temp1= $q->execute;

  $movie1=$q->fetch->[0];


#print "\n ARV[1[ and 2 are $ARGV[0] and $ARGV[1] \n";

#print "\n adding movie 1  to index ";

print "\n Movie 1 : $movie1";

    $i->add_entry($movie1,movie_id  => 10);


  my $q2 = REST::Neo4p::Query->new(
          "MATCH (n { movie_id : '$ARGV[1]' } )RETURN n"
         );	
   
  my $temp2= $q2->execute;

  $movie2=$q2->fetch->[0];
print " \n movie 2 : $ARGV[1] ";
my    @incoming_relationships = $movie2->get_incoming_relationships();
print Dumper(\@incoming_relationships);
#my $res= $movie2->relate_to($movie1, 'Has movie');

print "\n outgoing relationships of  $ARGV[1] \n";
 @incoming_relationships = $movie2->get_outgoing_relationships();

print Dumper(\@incoming_relationships);

print "\n Incoming of movie 1 : $ARGV[0]";
@incoming_relationships = $movie1->get_incoming_relationships();

print Dumper(\@incoming_relationships);

  print "\n outgoing relationships of  $ARGV[0] \n";
 @incoming_relationships = $movie2->get_outgoing_relationships();

print Dumper(\@incoming_relationships);