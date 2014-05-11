 use REST::Neo4p;
 use Data::Dumper;
  REST::Neo4p->connect('http://127.0.0.1:7474');
  $index = REST::Neo4p->get_index_by_name('movie_index','node');
  print "\n index name is $index";
 ($my_node1) = $index->find_entries('movie_id'  => $ARGV[0]);
 ($my_node2) = $index->find_entries('movie_id'  => $ARGV[1]);
 
 print Dumper($my_node1);
 print Dumper($my_node2);

#  print " Node 1 : $my_node1->id \t Node 2 : $my_node2->id ";
  $query = REST::Neo4p::Query->new("START n=node(".$my_node1->id."),m=node(".$my_node2->id.")
                                    MATCH p = (n)-[*..2]->(m)
                                    RETURN p");

 print Dumper(\$query);
 my $result=$query->execute;
 print Dumper(\$result);

$path = $query->fetch->[0];
@nodes = $path->nodes;
@rels = $path->relationships;



print Dumper(\@rels);
for my $relations(@rels){
print "\n printing weights";
print $relations->get_property('weight');
}


#);



#MATCH (n { movie_id: 20 } )-[r]-(m { movie_id: 50 } )
#DELETE r