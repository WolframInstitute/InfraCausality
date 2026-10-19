Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalTime :: UniversalTime *)

UniversalTime[ graph_Graph ] :=
  With[ { predecessors = GroupBy[ EdgeList @ graph, ( e |-> e[[ 2 ]] ) -> ( e |-> e[[ 1 ]] ) ] },
    KeyTake[
      Fold[
        { time, v } |-> Append[ time, v -> Max[ 0, 1 + Lookup[ time, Lookup[ predecessors, Key[ v ], { } ] ] ] ],
        <| |>,
        TopologicalSort @ graph ],
      VertexList @ graph ] ]

UniversalFoliation[ graph_Graph ] :=
  Values @ KeySort @ GroupBy[ Normal @ UniversalTime @ graph, Last -> First, Sort ]

InfraAntichainQ[ graph_Graph, family_Association ] :=
  InfraAntichainQ[ graph, Keys @ family ]

InfraAntichainQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraAntichainQ[ graph, # ] & ]

InfraAntichainQ[ graph_Graph, vs_List ] :=
  AllTrue[ vs, VertexQ[ graph, # ] & ] && DuplicateFreeQ @ vs &&
    AllTrue[ vs, v |-> Intersection[ VertexOutComponent[ graph, { v } ], vs ] === { v } ]
