Package["WolframInstitute`InfraCausality`"]


(* Multi-realisation wrappers for branchable causal-graph objects.

   Each head holds a list of realisations of the same kind:
     InfraChain         {{ v1, v2, ... }, ...}    ordered chains (worldlines)
     InfraLightRay      {{ v, ... }, ...}         vertex sets on null geodesics
     InfraLightCone     {{ v, ... }, ...}         vertex sets of forward / backward cones
     InfraCausalInterval{{ v, ... }, ...}         vertex sets supporting causal intervals
     InfraEvent         {{ v }, ...}              singleton bags of events

   The wrapper rule fires only on the single-_List-arg form. Behaviour mirrors
   SyntheticInfrageometry's InfraObjects.wl: auto-flatten of nested same-head
   wrappers; Part returns a wrapped sub-list; ["Realisations"], ["Length"],
   ["Expand"], ["First"] for the standard read-out.                            *)


(* ===== Auto-flatten nested wrappers ===== *)

InfraChain[ reps_List ] /; AnyTrue[ reps, MatchQ[ InfraChain[ _List ] ] ] :=
  InfraChain[ Flatten[ reps /. InfraChain[ xs_List ] :> xs, 1 ] ]

InfraLightRay[ reps_List ] /; AnyTrue[ reps, MatchQ[ InfraLightRay[ _List ] ] ] :=
  InfraLightRay[ Flatten[ reps /. InfraLightRay[ xs_List ] :> xs, 1 ] ]

InfraLightCone[ reps_List ] /; AnyTrue[ reps, MatchQ[ InfraLightCone[ _List ] ] ] :=
  InfraLightCone[ Flatten[ reps /. InfraLightCone[ xs_List ] :> xs, 1 ] ]

InfraCausalInterval[ reps_List ] /; AnyTrue[ reps, MatchQ[ InfraCausalInterval[ _List ] ] ] :=
  InfraCausalInterval[ Flatten[ reps /. InfraCausalInterval[ xs_List ] :> xs, 1 ] ]

InfraEvent[ reps_List ] /; AnyTrue[ reps, MatchQ[ InfraEvent[ _List ] ] ] :=
  InfraEvent[ Flatten[ reps /. InfraEvent[ xs_List ] :> xs, 1 ] ]


(* ===== Part: wrapped sub-list ===== *)

InfraChain /: Part[ InfraChain[ reps_List ], i_Integer ] := InfraChain[ { reps[[ i ]] } ]
InfraChain /: Part[ InfraChain[ reps_List ], spec_ ]     := InfraChain[ reps[[ spec ]] ]

InfraLightRay /: Part[ InfraLightRay[ reps_List ], i_Integer ] := InfraLightRay[ { reps[[ i ]] } ]
InfraLightRay /: Part[ InfraLightRay[ reps_List ], spec_ ]     := InfraLightRay[ reps[[ spec ]] ]

InfraLightCone /: Part[ InfraLightCone[ reps_List ], i_Integer ] := InfraLightCone[ { reps[[ i ]] } ]
InfraLightCone /: Part[ InfraLightCone[ reps_List ], spec_ ]     := InfraLightCone[ reps[[ spec ]] ]

InfraCausalInterval /: Part[ InfraCausalInterval[ reps_List ], i_Integer ] := InfraCausalInterval[ { reps[[ i ]] } ]
InfraCausalInterval /: Part[ InfraCausalInterval[ reps_List ], spec_ ]     := InfraCausalInterval[ reps[[ spec ]] ]

InfraEvent /: Part[ InfraEvent[ reps_List ], i_Integer ] := InfraEvent[ { reps[[ i ]] } ]
InfraEvent /: Part[ InfraEvent[ reps_List ], spec_ ]     := InfraEvent[ reps[[ spec ]] ]


(* ===== Length ===== *)

InfraChain /: Length[ InfraChain[ reps_List ] ] := Length @ reps
InfraLightRay /: Length[ InfraLightRay[ reps_List ] ] := Length @ reps
InfraLightCone /: Length[ InfraLightCone[ reps_List ] ] := Length @ reps
InfraCausalInterval /: Length[ InfraCausalInterval[ reps_List ] ] := Length @ reps
InfraEvent /: Length[ InfraEvent[ reps_List ] ] := Length @ reps


(* ===== Property accessors ===== *)

InfraChain[ reps_List ][ "Realisations" ] := reps
InfraChain[ reps_List ][ "Length" ]       := Length @ reps
InfraChain[ reps_List ][ "Expand" ]       := InfraChain[ { # } ] & /@ reps
InfraChain[ reps_List ][ "First" ]        := First @ reps

InfraLightRay[ reps_List ][ "Realisations" ] := reps
InfraLightRay[ reps_List ][ "Length" ]       := Length @ reps
InfraLightRay[ reps_List ][ "Expand" ]       := InfraLightRay[ { # } ] & /@ reps
InfraLightRay[ reps_List ][ "First" ]        := First @ reps

InfraLightCone[ reps_List ][ "Realisations" ] := reps
InfraLightCone[ reps_List ][ "Length" ]       := Length @ reps
InfraLightCone[ reps_List ][ "Expand" ]       := InfraLightCone[ { # } ] & /@ reps
InfraLightCone[ reps_List ][ "First" ]        := First @ reps

InfraCausalInterval[ reps_List ][ "Realisations" ] := reps
InfraCausalInterval[ reps_List ][ "Length" ]       := Length @ reps
InfraCausalInterval[ reps_List ][ "Expand" ]       := InfraCausalInterval[ { # } ] & /@ reps
InfraCausalInterval[ reps_List ][ "First" ]        := First @ reps

InfraEvent[ reps_List ][ "Realisations" ] := reps
InfraEvent[ reps_List ][ "Length" ]       := Length @ reps
InfraEvent[ reps_List ][ "Expand" ]       := InfraEvent[ { # } ] & /@ reps
InfraEvent[ reps_List ][ "First" ]        := First @ reps


(* ===== Predicates ===== *)

InfraChainQ[ expr_ ]            := MatchQ[ expr, InfraChain[ _List ] ]
InfraLightRayQ[ expr_ ]         := MatchQ[ expr, InfraLightRay[ _List ] ]
InfraLightConeQ[ expr_ ]        := MatchQ[ expr, InfraLightCone[ _List ] ]
InfraCausalIntervalQ[ expr_ ]   := MatchQ[ expr, InfraCausalInterval[ _List ] ]
InfraEventQ[ expr_ ]            := MatchQ[ expr, InfraEvent[ _List ] ]
