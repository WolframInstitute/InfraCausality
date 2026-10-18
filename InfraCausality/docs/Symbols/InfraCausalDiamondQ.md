---
Template: Symbol
Name: InfraCausalDiamondQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraCausalDiamondQ
Keywords: [causal diamond, Alexandrov interval, convex, least element, greatest element, predicate]
SeeAlso: [InfraCausalDiamond, InfraCausalFutureQ, InfraCausalPastQ, InfraChainQ, InfraLightRayQ]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraCausalDiamondQ]()[*g*, *set*]</code> gives `True` if the vertex list *set* has a least element *p* and a greatest element *q* on *g* and equals the causal diamond [*p*, *q*].

<code>[InfraCausalDiamondQ]()[*g*, {*set1*, *set2*, …}]</code> tests every set in the list.

<code>[InfraCausalDiamondQ]()[*g*, *density*]</code> tests the keys of a density association.

## Details & Options

Statement: a vertex list *S* is a causal diamond when it is nonempty, its elements are events of *g*, some *p* in *S* precedes every event of *S*, some *q* in *S* follows every event of *S*, and *S* = [*p*, *q*] = *J*⁺(*p*) ∩ *J*⁻(*q*). Order and repetition in the list do not matter.

The two extreme events are unique, so a diamond determines its endpoints. Having a least and a greatest element is not enough: the pair {*p*, *q*} of a comparable pair with events between them has both and is not a diamond, because it leaves out the events in between. The last condition is convexity: with any two of its events a diamond contains every event between them.

The predicate takes a set, never an object; <code>[InfraCausalDiamondQ]()[*g*, [InfraCausalDiamond]()[*p*, *q*]]</code> stays unevaluated.

The set predicates form a small hierarchy. A set that passes both [InfraCausalFutureQ]() and [InfraCausalPastQ]() is a diamond; a single event is the diamond [*v*, *v*]; and the events of a light ray are a diamond, since [InfraLightRayQ]() says exactly that the diamond of the first and last events of the ray is the ray.

## Basic Examples

On each substrate: a causal diamond, the pair of its corners alone, and the union of the causal futures of two incomparable events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
    {s = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[2], 2])},
    {InfraCausalDiamondQ[g, Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"]], InfraCausalDiamondQ[g, {p, q}],
     InfraCausalDiamondQ[g, Keys @ InfraMeasurement[g, InfraCausalFuture[s], "VertexDensity"]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The same three sets on the sprinkling, labelled with the answer.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraIntersection[InfraCausalFuture[p], InfraSlice[5]]])},
  {s = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[2], 2])},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, {set}], InfraCausalDiamondQ[g, set]],
    {set, {Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"], {p, q}, Keys @ InfraMeasurement[g, InfraCausalFuture[s], "VertexDensity"]}}]]
```

## Properties and Relations

Every nonempty diamond passes, and its least and greatest events are the corners it was built from.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, InfraSlice[1]])},
    AllTrue[Keys @ InfraMeasurement[g, InfraCausalFuture[p], "VertexDensity"], q |->
      With[{diamond = Keys @ InfraMeasurement[g, InfraCausalDiamond[p, q], "VertexDensity"]},
        InfraCausalDiamondQ[g, diamond] &&
          Select[diamond, e |-> SubsetQ[VertexOutComponent[g, {e}], diamond]] === {p} &&
          Select[diamond, e |-> SubsetQ[VertexInComponent[g, {e}], diamond]] === {q}]]]]
```

A set passes exactly when it is its own causal hull and the hull has a least and a greatest event. Checked on every set of at most three events of the sprinkling.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  AllTrue[Subsets[VertexList[g], {1, 3}], set |->
    InfraCausalDiamondQ[g, set] ===
      (Keys @ InfraMeasurement[g, InfraCausalDiamond[set], "VertexDensity"] === Sort[set] &&
        AnyTrue[set, e |-> SubsetQ[VertexOutComponent[g, {e}], set]] && AnyTrue[set, e |-> SubsetQ[VertexInComponent[g, {e}], set]])]]
```

A set that is both a causal future and a causal past is a diamond, and so is every light ray.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {sets = Join[Keys @ InfraMeasurement[g, InfraCausalFuture[#], "VertexDensity"] & /@ VertexList[g], Keys @ InfraMeasurement[g, InfraCausalPast[#], "VertexDensity"] & /@ VertexList[g]]},
    AllTrue[Select[sets, InfraCausalFutureQ[g, #] && InfraCausalPastQ[g, #] &], InfraCausalDiamondQ[g, #] &] &&
      AllTrue[VertexList[g], v |-> InfraCausalDiamondQ[g, RandomInfraFutureLightCone[g, v, All]]]]]
```
