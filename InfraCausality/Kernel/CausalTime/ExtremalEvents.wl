Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalTime :: ExtremalEvents *)

MaximalAbsorber[ graph_Graph ] :=
  extremalEvents[ graph, InfraCausalPast ]

MaximalEmitter[ graph_Graph ] :=
  extremalEvents[ graph, InfraCausalFuture ]

PackageScope[ extremalEvents ]

extremalEvents[ graph_Graph, cone_ ] :=
  KeySort @ GroupBy[
    Normal @ UniversalTime @ graph,
    Last -> First,
    vs |-> Sort @ MaximalBy[ vs, v |-> InfraMeasurement[ graph, cone[ v ], "CountingMeasure" ] ] ]
