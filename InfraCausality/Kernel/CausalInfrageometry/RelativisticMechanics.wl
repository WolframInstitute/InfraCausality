Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: RelativisticMechanics *)


(* Light cones, causal intervals, universal time and light rays on a finite
   directed acyclic graph treated as a causal set.

   References:
     Sorkin, Causal Sets: Discrete Gravity, gr-qc/0309009.
     Knuth & Bahreyni, A Potential Foundation for Emergent Space-Time,
       arXiv:1005.4172.                                                        *)


(* =========================== Universal time =========================== *)

UniversalTime[ graph_Graph ] :=
  With[ { predecessors = GroupBy[ EdgeList @ graph, ( e |-> e[[ 2 ]] ) -> ( e |-> e[[ 1 ]] ) ] },
    KeyTake[
      Fold[
        { time, v } |-> Append[ time, v -> Max[ 0, 1 + Lookup[ time, Lookup[ predecessors, Key[ v ], { } ] ] ] ],
        <| |>,
        TopologicalSort @ graph ],
      VertexList @ graph ] ]

UniversalTime[ g_Graph, foliation_List ] :=
  Association @ Catenate @ MapIndexed[
    { slice, idx } |-> Map[ # -> First[ idx ] - 1 &, slice ],
    foliation
  ]

UniversalFoliation[ graph_Graph ] :=
  Values @ KeySort @ GroupBy[ Normal @ UniversalTime @ graph, Last -> First, Sort ]


(* MaximalAbsorber[g]: per universal-time slice, the events whose backward
   light cone is largest -- "most-informed" events with the broadest causal
   past on their slice.  Returns Association[ slice -> {v, ...} ].           *)

MaximalAbsorber[ g_ ] := extremalEvents[ g, InfraCausalPast ]


(* MaximalEmitter[g]: per universal-time slice, the events whose forward
   light cone is largest -- "most-influential" events with the broadest causal
   future on their slice.                                                     *)

MaximalEmitter[ g_ ] := extremalEvents[ g, InfraCausalFuture ]


(* extremalEvents[g, cone]: per universal-time slice, the events whose cone
   volume is largest.                                                         *)

PackageScope[ extremalEvents ]
extremalEvents[ g_, cone_ ] :=
  KeySort @ GroupBy[
    Normal @ UniversalTime @ g,
    Last -> First,
    MaximalBy[ #, p |-> InfraMeasurement[ g, cone[ p ], "CountingMeasure" ] ] &
  ]
