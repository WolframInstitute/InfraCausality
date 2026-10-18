---
Template: Symbol
Name: MaximalAbsorber
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/MaximalAbsorber
Keywords: [extremal events, causal past, absorber, slice, universal foliation, experimental]
SeeAlso: [MaximalEmitter, InfraCausalPast, UniversalFoliation, InfraSlice, UniversalTime]
RelatedGuides: [CausalTime]
---

## Usage

<code>[MaximalAbsorber]()[*g*]</code> gives, for each slice *k* of the universal foliation, the sorted events of the slice whose causal past has the most vertices.

## Details & Options

Experimental: extremal events. The notion is unsettled; the function reads one count per event and may change.

Definition: for each height *k* = 0, …, *h* of the universal time *t*, the maximal absorbers of the slice *S*(*k*) = {*v* : *t*(*v*) = *k*} are the events *v* of *S*(*k*) for which the number of events of the causal past *J*⁻(*v*), *v* included, is largest. The result is the association *k* → the sorted list of them, keys in increasing order; every list is nonempty, and ties keep all their events.

An absorber is an event that has received influence from the most events at its height: the event of the slice that sees most of the past. [MaximalEmitter]() is the time-reversed reading, the events of largest causal future.

On the diamond lattice the past of (*i*, *j*) has (*i* + 1)(*j* + 1) events, which on the antidiagonal *i* + *j* = *k* is largest in the middle: the absorbers are the one or two events nearest the diagonal *i* = *j*. On the cylinder lattice every event of a row has a past of the same size, so the whole row absorbs.

## Basic Examples

The maximal absorbers of every slice (blue) on the diamond lattice, a sprinkling into two-dimensional Minkowski space and the cylinder lattice.

```wl
GraphicsRow @ Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    InfraSubstrateHighlight[g, {Catenate @ Values @ MaximalAbsorber[g] -> StandardBlue}]],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The maximal absorbers of the sprinkling, slice by slice.

```wl
MaximalAbsorber @ CausalSubstrate["MinkowskiSprinkling2D", "Small"]
```

The absorber of the slice at height 4 of the sprinkling with its causal past.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {v = First @ MaximalAbsorber[g][4]},
  InfraSubstrateHighlight[g, {InfraSlice[4] -> StandardGreen, InfraCausalPast[v] -> StandardBlue, v}]]
```

## Properties and Relations

The keys are the heights of the universal time, and each value is a nonempty part of its slice.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {absorbers = MaximalAbsorber[g]},
    Keys[absorbers] === Range[0, Max @ UniversalTime[g]] &&
      AllTrue[Normal @ absorbers, Apply[{k, vs} |-> vs =!= {} && SubsetQ[RandomInfraSlice[g, k], vs]]]]]
```

The values are exactly the events of the slice with the largest causal past, by brute force.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {size = v |-> Length @ VertexInComponent[g, {v}]},
    AllTrue[Normal @ MaximalAbsorber[g], Apply[{k, vs} |->
      With[{slice = RandomInfraSlice[g, k]}, vs === Sort @ Select[slice, v |-> size[v] == Max[size /@ slice]]]]]]]
```

On the diamond lattice the absorbers of slice *k* are the events (*i*, *j*) of the antidiagonal nearest the diagonal, |*i* − *j*| = 0 for even *k* and 1 for odd *k*, and on the cylinder lattice they are the whole rows.

```wl
With[
  {diamond = CausalSubstrate["DiamondLatticeGraph", "Small"], cylinder = CausalSubstrate["CylinderLatticeGraph", "Small"]},
  AllTrue[Normal @ MaximalAbsorber[diamond], Apply[{k, vs} |-> vs === Sort @ Select[RandomInfraSlice[diamond, k], v |-> Abs[First[v] - Last[v]] == Mod[k, 2]]]] &&
    Values[MaximalAbsorber[cylinder]] === UniversalFoliation[cylinder]]
```

On the diamond lattice, which its reflection (*i*, *j*) ↦ (6 − *i*, 6 − *j*) turns upside down, the absorbers and the emitters coincide.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  MaximalAbsorber[g] === MaximalEmitter[g]]
```
