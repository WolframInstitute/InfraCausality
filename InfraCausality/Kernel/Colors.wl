Package["WolframInstitute`InfraCausality`"]


(* Causal colour palette: the causal-graph orange family plus observer and
   light colours; every colour in the paclet derives from these entries.      *)

(* "Vertex" and "Accent" reproduce WolframPhysicsProjectStyleData["CausalGraph"]
   without the ResourceFunction network dependency.                           *)

PackageExport[ $CausalColors ]
$CausalColors = <|
  "Causal"        -> StandardOrange,
  "Vertex"        -> Hue[ 0.11, 1, 0.97 ],
  "Edge"          -> Blend[ { StandardOrange, StandardGray }, 0.35 ],
  "Ambient"       -> Blend[ { StandardOrange, StandardGray }, 0.6 ],
  "Accent"        -> Hue[ 0, 1, 0.56 ],
  "LightRay"      -> RGBColor[ 0.95, 0.82, 0.2 ],
  "LightRayFaded" -> RGBColor[ 0.92, 0.88, 0.6 ],
  "Echo"          -> RGBColor[ 0.7, 0.4, 0.9 ],
  "Event"         -> RGBColor[ 0.65, 0.5, 0.85 ],
  "Observer1"     -> RGBColor[ 0.4, 0.65, 0.95 ],
  "Observer2"     -> RGBColor[ 0.95, 0.45, 0.45 ],
  "Observer3"     -> RGBColor[ 0.35, 0.78, 0.45 ],
  "Simultaneity"  -> RGBColor[ 0.9, 0.65, 0.35 ],
  "Tick"          -> GrayLevel[ 0.35 ],
  "Label"         -> GrayLevel[ 0.2 ],
  "Background"    -> RGBColor[ 0.98, 0.98, 0.96 ]
|>;


(* CausalGraphStyle[tier]: Graph style options for causal graphs -- "Default"
   the light-orange causal look, "Opaque"/"Faint" orange-gray backdrops for
   highlighted constructions, "Gray" a neutral fallback.                       *)

PackageExport[ CausalGraphStyle ]
CausalGraphStyle[ "Default" ] := {
  VertexStyle -> Directive[ $CausalColors[ "Vertex" ], EdgeForm[ { $CausalColors[ "Vertex" ], Opacity[ 1 ] } ] ],
  EdgeStyle   -> $CausalColors[ "Edge" ]
}

CausalGraphStyle[ "Opaque" ] := {
  VertexStyle -> Directive[ $CausalColors[ "Ambient" ], Opacity[ 0.6 ] ],
  EdgeStyle   -> Directive[ $CausalColors[ "Ambient" ], Opacity[ 0.4 ] ]
}

CausalGraphStyle[ "Faint" ] := {
  VertexStyle -> Directive[ $CausalColors[ "Ambient" ], Opacity[ 0.3 ] ],
  EdgeStyle   -> Directive[ $CausalColors[ "Ambient" ], Opacity[ 0.15 ] ]
}

CausalGraphStyle[ "Gray" ] := {
  VertexStyle -> StandardGray,
  EdgeStyle   -> StandardGray
}
