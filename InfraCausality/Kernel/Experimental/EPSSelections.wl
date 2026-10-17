Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: Experimental :: EPSSelections *)

Options[ RandomInfraMessageFunction ] = { "NextVertexFunction" -> Automatic }

RandomInfraMessageFunction[ graph_Graph, InfraMessageFunction[ a_List, b_List ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraMessageFunction ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraMessageFunction, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { relation = Select[ messageRelation[ graph, a, b ], # =!= { } & ] },
    { selection = path |-> AssociationThread[ Keys @ relation, Last /@ Take[ path, { 2, -2 } ] ],
      members = chainSample[ selectionDAG[ relation, b ], count, OptionValue[ RandomInfraMessageFunction, { opts }, "NextVertexFunction" ] ] },
    If[ count === Automatic,
      Replace[ members, nodes : { __ } :> selection @ nodes ],
      selection /@ members ] ]

RandomInfraEchoFunction[ graph_Graph, InfraEchoFunction[ a_List, b_List ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic ] :=
  With[ { members = echoCompositions[ graph, a, b ] },
    Switch[ count,
      Automatic, If[ members === { }, { }, RandomChoice @ members ],
      All,       members,
      _UpTo,     RandomSample[ members, count ],
      _,         If[ count > Length @ members, { }, RandomSample[ members, count ] ] ] ]
