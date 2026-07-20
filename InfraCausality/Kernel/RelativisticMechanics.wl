Package["WolframInstitute`InfraCausality`"]


(* Light cones, causal intervals, universal time and light rays on a finite
   directed acyclic graph treated as a causal set.

   References:
     Sorkin, Causal Sets: Discrete Gravity, gr-qc/0309009.
     Knuth & Bahreyni, A Potential Foundation for Emergent Space-Time,
       arXiv:1005.4172.                                                        *)


(* =========================== Light cones =========================== *)

(* Forward light cone: subgraph induced by all events reachable from v along
   directed paths of length <= len.  Discrete analog of J^+(v).               *)

ForwardLightCone[ g_, v_List, len_ : Infinity ] :=
  VertexOutComponentGraph[ g, v, len ]

ForwardLightCone[ g_, v_, len_ : Infinity ] :=
  VertexOutComponentGraph[ g, { v }, len ]


(* Backward light cone: subgraph induced by events from which v is reachable
   along directed paths of length <= len.  Discrete analog of J^-(v).         *)

BackwardLightCone[ g_, v_List, len_ : Infinity ] :=
  VertexInComponentGraph[ g, v, len ]

BackwardLightCone[ g_, v_, len_ : Infinity ] :=
  VertexInComponentGraph[ g, { v }, len ]


(* Causal interval J^+(v1) \[Intersection] J^-(v2): subgraph of events between
   v1 and v2 in the causal order.                                             *)

CausalInterval[ g_, v1_, v2_, len_ : Infinity ] :=
  Subgraph[ g,
    Intersection[
      VertexList @ ForwardLightCone[ g, v1, len ],
      VertexList @ BackwardLightCone[ g, v2, len ]
    ]
  ]


(* Causal closure of a chain c: events both reachable from c and able to reach
   c.  Returns the vertex list (graph reconstruction is one Subgraph call).   *)

ChainCausalInterval[ g_, c_ ] :=
  Intersection[
    VertexList @ ForwardLightCone[ g, c ],
    VertexList @ BackwardLightCone[ g, c ]
  ]


(* =========================== Universal time =========================== *)

(* Universal foliation: partition of vertices by maximum directed distance from
   the source set.  Slice k = events whose longest past chain from a source has
   length k.  Computed as -GraphDistance with edge weights -1.                *)

UniversalFoliation[ g_Graph ] :=
  With[
    {
      sources = GetSources[ g ],
      negDistMatrix = -GraphDistanceMatrix[
        Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ]
      ]
    },
    Values @ KeySort @ GroupBy[
      Normal @ AssociationThread[
        VertexList @ g ->
          MapThread[ Min, negDistMatrix[[ VertexIndex[ g, sources ], All ]] ]
      ],
      Last -> First
    ]
  ]


(* Universal time: assigns to every vertex its slice index in the universal
   foliation (0 on sources, k on slice k).                                    *)

UniversalTime[ g_Graph, foliation_List ] :=
  Association @ Catenate @ MapIndexed[
    { slice, idx } |-> Map[ # -> First[ idx ] - 1 &, slice ],
    foliation
  ]

UniversalTime[ g_Graph ] :=
  UniversalTime[ g, UniversalFoliation[ g ] ]


(* MaximalAbsorber[g]: per universal-time slice, the events whose backward
   light cone is largest -- "most-informed" events with the broadest causal
   past on their slice.  Returns Association[ slice -> InfraEvent[{v, ...}] ]. *)

MaximalAbsorber[ g_ ] := extremalEvents[ g, BackwardLightCone ]


(* MaximalEmitter[g]: per universal-time slice, the events whose forward
   light cone is largest -- "most-influential" events with the broadest causal
   future on their slice.                                                     *)

MaximalEmitter[ g_ ] := extremalEvents[ g, ForwardLightCone ]


(* extremalEvents[g, cone]: per universal-time slice, the events whose cone
   volume is largest.                                                         *)

PackageScope[ extremalEvents ]
extremalEvents[ g_, cone_ ] :=
  KeySort @ GroupBy[
    Normal @ UniversalTime @ g,
    Last -> First,
    InfraEvent @ MaximalBy[ #, p |-> VertexCount @ cone[ g, p ] ] &
  ]


(* =========================== Light rays =========================== *)

(* OutgoingLightRays[g, v]: vertex set of events on outgoing null geodesics
   from v.  Characterised within the forward cone by t(p) + 1 == |J^-(p)|,
   i.e. every past step is unique -- no overtaking.                           *)

OutgoingLightRays[ g_, v_ ] :=
  With[
    { forwardCone = ForwardLightCone[ g, v ] },
    { coords = UniversalTime @ forwardCone, vertices = VertexList @ forwardCone },
    { volumes = AssociationMap[ VertexCount @ BackwardLightCone[ forwardCone, # ] &, vertices ] },
    Select[ vertices, coords[ # ] + 1 == volumes[ # ] & ]
  ]


(* IncomingLightRays[g, v]: vertex set of events on incoming null geodesics
   into v -- the time-reverse of OutgoingLightRays.                           *)

IncomingLightRays[ g_, v_ ] := OutgoingLightRays[ ReverseGraph @ g, v ]
