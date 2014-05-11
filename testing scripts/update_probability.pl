# Get the outlinks for each genre ( hard coding it now . But will read it from file and automate the link weights)
     $query=REST::Neo4p::Query->new(
        "MATCH (n{name : 'Music' }) RETURN n"
        );
  $query->execute();

my    $node1 =  $query->fetch->[0];
my    @outgoing_relationships = $node1->get_outgoing_relationships();

my $relation_prob= sprintf("%.8f", (1 /(scalar @outgoing_relationships))); # Prob based on number of outgoing links


print Dumper(\@outgoing_relationships);

for my $relations (@outgoing_relationships){
print Dumper(\$relations);
$relations->set_property( {weight =>$relation_prob} );


}