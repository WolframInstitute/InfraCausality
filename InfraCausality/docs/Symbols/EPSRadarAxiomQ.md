---
Template: Symbol
Name: EPSRadarAxiomQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/EPSRadarAxiomQ
Keywords: [EPS axioms, Ehlers-Pirani-Schild, axiom D2, radar coordinates, coordinatization, observer space, fibration, injective chart, predicate]
SeeAlso: [InfraRadarCoordinates, EPSMessageAxiomQ, InfraMessageFunction, InfraEchoFunction, BondiRadarCoordinates]
RelatedGuides: [EPSAxiomatics]
---

## Usage

<code>[EPSRadarAxiomQ]()[*g*, [InfraRadarCoordinates]()[*a*]]</code> gives `True` if axiom D2 holds on *g*: the radar coordinates of the observer *a* are injective on its radar domain.

<code>[EPSRadarAxiomQ]()[*g*, [InfraRadarCoordinates]()[{*a*, *b*, …}]]</code> gives `True` if the joined radar coordinates of the observers are injective on their common radar domain.

## Details & Options

Statement: with *e* → {(*i* + *j*)/2, (*j* − *i*)/2} the radar coordinates of [InfraRadarCoordinates]() on the radar domain, the axiom holds when two distinct events of the domain never get the same coordinates, so that the coordinates are a chart of the domain. For a list of observers the coordinates are the concatenated vectors on the intersection of the domains.

The axiom is a statement about the observer space, the `"Fibration"` reading of the head: it holds exactly when every fiber is a single event, when the domain has as many coordinate cells as events, and when the observer space is a fiber bundle with a point as fiber. The predicate tests the observers; [`InfraFibrationQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraFibrationQ) and [`InfraFiberBundleQ`](paclet:WolframInstitute/InfraGeometry/ref/InfraFiberBundleQ) test the space they build.

Radar distance is unsigned, so a single observer in 1 + 1 dimensions sees the two sides of its worldline folded onto each other and fails the axiom unless the graph breaks the mirror; a second observer off the first separates the sides. An observer that satisfies the axiom on its own keeps it when more observers are joined, since the coordinates only grow.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| EPS | Axiom D2 | The message and echo functions of finitely many particles give every event of a neighbourhood coordinates that distinguish it from every other event, the radar coordinates. |
| Minkowski space | Radar coordinates | An inertial observer in the plane locates an event up to the mirror in its worldline by the times it sends and receives light reflected there; a second observer off the worldline fixes the side. |

## Basic Examples

The diagonal {(*m*, *m*)} of the diamond lattice folds the lattice along itself and fails the axiom; a staircase worldline breaks the mirror and satisfies it; two observers resolve the fold.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}], staircase = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}], shifted = Table[{m, m + 1}, {m, 0, 5}]},
  {EPSRadarAxiomQ[g, InfraRadarCoordinates[diagonal]], EPSRadarAxiomQ[g, InfraRadarCoordinates[staircase]], EPSRadarAxiomQ[g, InfraRadarCoordinates[{diagonal, shifted}]]}]
```

The domain of the diagonal at its chart positions, distance across and time up: the two halves of the lattice lie on top of each other, the fold the predicate detects.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}]},
  InfraSubstrateHighlight[InfraMeasurement[g, InfraRadarCoordinates[diagonal], "Subgraph"], {InfraWalk[diagonal] -> StandardRed}]]
```

A random timelike geodesic of each substrate: on the lattices its chart is injective, on the sprinkling the observer identifies events.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {EPSRadarAxiomQ[g, InfraRadarCoordinates[a]],
     Length @ InfraMeasurement[g, InfraRadarCoordinates[a], "Domain"], Length @ InfraFibers @ InfraMeasurement[g, InfraRadarCoordinates[a], "Fibration"]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

Joining a second observer of the sprinkling: the common domain, the cells of the first observer on it and the cells of the joined coordinates.

```wl
With[
  {g = CausalSubstrate["MinkowskiSprinkling2D", "Small"]},
  {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
  {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
  {domain = InfraMeasurement[g, InfraRadarCoordinates[{a, b}], "Domain"]},
  {EPSRadarAxiomQ[g, InfraRadarCoordinates[{a, b}]], Length @ domain,
   Length @ Union @ Values @ KeyTake[InfraMeasurement[g, InfraRadarCoordinates[a], "Coordinates"], domain],
   Length @ Union @ Values @ InfraMeasurement[g, InfraRadarCoordinates[{a, b}], "Coordinates"]}]
```

## Properties and Relations

The axiom holds exactly when every fiber of the observer space is one event, and then the space is a fiber bundle with a point as fiber.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}], staircase = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}], shifted = Table[{m, m + 1}, {m, 0, 5}]},
  AllTrue[{InfraRadarCoordinates[diagonal], InfraRadarCoordinates[staircase], InfraRadarCoordinates[{diagonal, shifted}], InfraRadarCoordinates[{diagonal, staircase}]}, chart |->
    With[
      {fib = InfraMeasurement[g, chart, "Fibration"]},
      EPSRadarAxiomQ[g, chart] === AllTrue[InfraFibers[fib], VertexCount[#] == 1 &] && Implies[EPSRadarAxiomQ[g, chart], InfraFiberBundleQ[fib]]]]]
```

The axiom holds exactly when the base graph has one cell per event of the domain.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    EPSRadarAxiomQ[g, InfraRadarCoordinates[a]] === (VertexCount @ InfraMeasurement[g, InfraRadarCoordinates[a], "BaseGraph"] == Length @ InfraMeasurement[g, InfraRadarCoordinates[a], "Domain"])],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

The fibers of the diagonal are the mirror pairs (*i*, *j*), (*j*, *i*): the fold is the whole failure.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {diagonal = Table[{m, m}, {m, 0, 6}]},
  {fibers = VertexList /@ InfraFibers @ InfraMeasurement[g, InfraRadarCoordinates[diagonal], "Fibration"]},
  AllTrue[Values @ fibers, fiber |-> Sort[fiber] === Sort @ DeleteDuplicates @ {First @ fiber, Reverse @ First @ fiber}]]
```
