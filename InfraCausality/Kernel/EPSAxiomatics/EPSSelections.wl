Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: EPSAxiomatics :: EPSSelections *)

Options[ RandomInfraMessageFunction ] = { "NextVertexFunction" -> Automatic }

Options[ RandomInfraEchoFunction ] = { "NextVertexFunction" -> Automatic }

selectionWalk[ relation_Association, b_List ] :=
  AssociationThread[ Keys @ relation, Last /@ Take[ chainSample[ selectionDAG[ relation, b ], Automatic, RandomChoice ], { 2, -2 } ] ]

echoWalk[ graph_Graph, a_List, b_List ] :=
  With[ { there = selectionWalk[ messageDomain[ graph, a, b ], b ], back = selectionWalk[ messageDomain[ graph, b, a ], a ] },
    DeleteMissing[ Lookup[ back, Key @ # ] & /@ there ] ]

distinctWalks[ draw_, limit_ ] :=
  First @ NestWhile[
    state |-> With[ { member = draw[ Null ] },
      If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
    { { }, 0 },
    Last @ # < limit & ]

RandomInfraMessageFunction[ graph_Graph, InfraMessageFunction[ a_List, b_List ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraMessageFunction ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraMessageFunction, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { relation = messageDomain[ graph, a, b ] },
    { selection = path |-> AssociationThread[ Keys @ relation, Last /@ Take[ path, { 2, -2 } ] ],
      members = chainSample[ selectionDAG[ relation, b ], count, OptionValue[ RandomInfraMessageFunction, { opts }, "NextVertexFunction" ] ] },
    If[ count === Automatic,
      Replace[ members, nodes : { __ } :> selection @ nodes ],
      selection /@ members ] ]

RandomInfraEchoFunction[ graph_Graph, InfraEchoFunction[ a_List, b_List ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraEchoFunction ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraEchoFunction, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = echoCompositions[ graph, a, b ], nextFn = OptionValue[ RandomInfraEchoFunction, { opts }, "NextVertexFunction" ],
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    If[ IntegerQ @ count && count > Length @ members, { },
      With[ { ordered = Which[
            nextFn === Identity, SortBy[ members, Values ],
            nextFn === RandomSample, RandomSample @ members,
            nextFn === RandomChoice, distinctWalks[ ignored |-> echoWalk[ graph, a, b ], Min[ cap, Length @ members ] ],
            True, members ] },
        Switch[ count,
          Automatic, If[ nextFn === Automatic, RandomChoice @ members, First @ ordered ],
          All,       ordered,
          _UpTo,     If[ nextFn === Automatic, RandomSample[ members, Min[ cap, Length @ members ] ], Take[ ordered, UpTo @ cap ] ],
          _,         If[ nextFn === Automatic, RandomSample[ members, count ], Take[ ordered, count ] ] ] ] ] ]
