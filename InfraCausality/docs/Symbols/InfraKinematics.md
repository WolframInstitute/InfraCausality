---
Template: Symbol
Name: InfraKinematics
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/InfraKinematics
Keywords: [Knuth kinematics, energy, momentum, mass, interval, velocity, chain projection, light-cone coordinates, experimental]
SeeAlso: [ChainProjection, ChainLightReach, RandomInfraTimelikeGeodesic, RandomInfraWorldline, BondiKFactor]
RelatedGuides: [CausalInfrageometry]
---

## Usage

<code>[InfraKinematics]()[*g*, *ref*, {*b1*, *b2*, …}]</code> gives the projections of the chain *ref* onto the target chains *bi* and, for every pair of them, the Knuth energy, momentum, mass, interval and velocity, as an association.

## Details & Options

Experimental: Knuth kinematics. The scalars follow Knuth and Bahreyni (arXiv:1005.4172), where two projections of one chain play the role of the light-cone coordinates *u* = *t* + *x* and *v* = *t* − *x*; which pairs of target chains carry a physical meaning is not settled, so every pair is reported and the reading may change.

Definition: let *pi* = <code>[ChainProjection]()[*g*, *ref*, *bi*]</code>. For each pair (*p*, *q*) of projections, in the order of `Subsets[{p1, p2, …}, {2}]`, the association holds:

| Key | Value |
|---|---|
| `"Projections"` | the list {*p1*, *p2*, …} |
| `"Energy"` | *E* = (*p* + *q*)/2 |
| `"Momentum"` | *P* = (*p* − *q*)/2 |
| `"Interval"` | *I* = *p q* |
| `"Mass"` | *m* = √\|*p q*\| |
| `"Velocity"` | β = (*p* − *q*)/(*p* + *q*), `Indeterminate` when *p* + *q* = 0 |

The scalars satisfy the relations of special-relativistic kinematics in light-cone coordinates: *E*² − *P*² = *I*, *m*² = \|*I*\| and β = *P*/*E*. A pair with a zero projection is massless and has velocity ±1.

| Option | Default | Values |
|---|---|---|
| `Method` | `"Cone"` | passed to [ChainProjection](): `"Cone"` or `"LightRays"` |

## Basic Examples

A longest chain of the diamond lattice, three timelike geodesics from the bottom that end at {3, 3}, {1, 5} and {5, 1}, and the kinematics of the three pairs of targets.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {ref = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
  {targets = Table[(SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[RandomInfraPoint[g, InfraSlice[1]], end]]), {end, {{3, 3}, {1, 5}, {5, 1}}}]},
  InfraKinematics[g, ref, targets]]
```

The same reference chain and targets drawn on the lattice.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {ref = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
  {targets = Table[(SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[RandomInfraPoint[g, InfraSlice[1]], end]]), {end, {{3, 3}, {1, 5}, {5, 1}}}]},
  InfraSubstrateHighlight[g, Prepend[MapThread[InfraWalk[#1] -> #2 &, {targets, {Red, StandardGreen, StandardPurple}}], InfraWalk[ref] -> StandardBlue]]]
```

The projections of a longest chain onto two worldlines of the sprinkling and onto two of the cylinder lattice, with their mass and velocity.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {ref = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]])},
    {targets = (SeedRandom[3]; RandomInfraWorldline[g, InfraWorldline[], 2])},
    KeyTake[InfraKinematics[g, ref, targets], {"Projections", "Mass", "Velocity"}]],
  {name, {"MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

## Properties and Relations

The projections are those of [ChainProjection](), and the scalars satisfy *E*² − *P*² = *I*, *m*² = \|*I*\| and β = *P*/*E* wherever *E* ≠ 0, under either method.

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {ref = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]]), targets = (SeedRandom[2]; RandomInfraWorldline[g, UpTo[5]])},
    AllTrue[{"Cone", "LightRays"}, method |->
      With[{k = InfraKinematics[g, ref, targets, Method -> method]},
        k["Projections"] == (ChainProjection[g, ref, #, Method -> method] & /@ targets) &&
          k["Energy"]^2 - k["Momentum"]^2 == k["Interval"] && k["Mass"]^2 == Abs[k["Interval"]] &&
          And @@ MapThread[{e, p, b} |-> e == 0 || b == p/e, {k["Energy"], k["Momentum"], k["Velocity"]}]]]]]
```

The energy of a pair is the mean of its projections, and every projection lies in [0, 1], so energies lie in [0, 1] and velocities in [−1, 1].

```wl
AllTrue[{"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}, name |->
  With[
    {g = CausalSubstrate[name, "Small"]},
    {ref = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g, InfraTimelikeGeodesic[]]), targets = (SeedRandom[2]; RandomInfraWorldline[g, UpTo[5]])},
    {k = InfraKinematics[g, ref, targets]},
    k["Energy"] == Mean /@ Subsets[k["Projections"], {2}] && AllTrue[k["Energy"], 0 <= # <= 1 &] &&
      AllTrue[DeleteCases[k["Velocity"], Indeterminate], -1 <= # <= 1 &]]]
```
