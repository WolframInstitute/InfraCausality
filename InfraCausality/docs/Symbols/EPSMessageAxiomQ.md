---
Template: Symbol
Name: EPSMessageAxiomQ
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/EPSMessageAxiomQ
Keywords: [EPS axioms, Ehlers-Pirani-Schild, axiom D1, message function, echo function, EPS defects, observer, clock, predicate]
SeeAlso: [InfraMessageFunction, InfraEchoFunction, InfraMessageFunctionQ, InfraEchoFunctionQ, EPSRadarAxiomQ, RandomInfraMessageFunction]
RelatedGuides: [EPSAxiomatics]
---

## Usage

<code>[EPSMessageAxiomQ]()[*g*, [InfraMessageFunction]()[*a*, *b*]]</code> gives `True` if axiom D1 holds exactly on *g*: every tick of *a* has one message image on *b*, and the images strictly increase along *a*.

<code>[EPSMessageAxiomQ]()[*g*, [InfraEchoFunction]()[*a*, *b*]]</code> gives `True` if every tick of *a* has one echo via *b*, and the echoes strictly increase along *a*.

## Details & Options

Statement: with *M*(*v*) = *E*⁺(*v*) ∩ *b* the message relation of [InfraMessageFunction](), the pair of observers satisfies axiom D1 on the window *a'* of *a* when \|*M*(*v*)\| = 1 for every *v* in *a'* and the position of the image on *b* strictly increases along *a'*; the relation is then a monotone injection of the window into *b*, the message function of two inertial observers in Minkowski space. For [InfraEchoFunction]() the relation is *v* → Echo(*v*), with the echoes anywhere on *a*.

The predicate tests the pair of observers; [InfraMessageFunctionQ]() and [InfraEchoFunctionQ]() test a candidate map against the pair. When the axiom holds the relation has one member, the map itself, and the two tests agree on it.

| Option | Default | Effect |
|---|---|---|
| `"Margin"` | 0 | the window is *a* with that many ticks dropped at each end; the images stay in the whole of *b* |

The predicate is the vanishing of the four defects of the head read with the same `"Margin"`: `"DomainDefect"` 0 is every window tick with an image, `"FunctionDefect"` 0 is at most one image each, `"InjectivityDefect"` 0 with these is distinct images, and `"OrderDefect"` 0 with these is images in weakly increasing order, which with distinctness is strictly increasing. On an empty window the axiom holds vacuously.

Corresponding notions:

| System | Name | Statement |
|---|---|---|
| EPS | Axiom D1 | The message from a particle *P* to a particle *Q* is a smooth monotone map of the clock of *P* into the clock of *Q*; so is the echo, its composition with the message back. |
| Minkowski space | Light signal | A light ray from an inertial worldline meets a second inertial worldline at exactly one event, later on its clock for a later emission. |

## Basic Examples

The lattice observers at rest, {(*m*, *m*)} and {(*m*, *m* + 2)}, exchange their ticks one to one on the interior window, both ways and in the echo.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  EPSMessageAxiomQ[g, #, "Margin" -> 2] & /@ {InfraMessageFunction[a, b], InfraMessageFunction[b, a], InfraEchoFunction[a, b], InfraEchoFunction[b, a]}]
```

Without the margin the two top ticks of {(*m*, *m*)} send their light out of the lattice, so the axiom fails from that chain and holds towards it.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  {EPSMessageAxiomQ[g, InfraMessageFunction[a, b]], EPSMessageAxiomQ[g, InfraMessageFunction[b, a]]}]
```

Each light ray from the staircase meets the shifted staircase in two consecutive ticks, so the axiom fails on every window.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {b = Select[(# + {0, 2}) & /@ a, Max[#] <= 6 &]},
  Table[EPSMessageAxiomQ[g, InfraMessageFunction[a, b], "Margin" -> k], {k, 0, 4}]]
```

Two random timelike geodesics on each substrate: a light ray from a tick rarely meets the other observer in exactly one tick, and the axiom fails for messages and echoes on all three.

```wl
Table[
  With[
    {g = CausalSubstrate[name, "Small"]},
    {a = (SeedRandom[1]; RandomInfraTimelikeGeodesic[g])},
    {b = (SeedRandom[1]; RandomInfraTimelikeGeodesic[VertexDelete[g, a]])},
    {EPSMessageAxiomQ[g, InfraMessageFunction[a, b]], EPSMessageAxiomQ[g, InfraEchoFunction[a, b]]}],
  {name, {"DiamondLatticeGraph", "MinkowskiSprinkling2D", "CylinderLatticeGraph"}}]
```

## Options

### Margin

The window of `"Margin" -> k` is *a* with *k* ticks removed at each end; for a message head the answer equals the answer for the head whose first observer is the window.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  Table[EPSMessageAxiomQ[g, InfraMessageFunction[a, b], "Margin" -> k] === EPSMessageAxiomQ[g, InfraMessageFunction[a[[k + 1 ;; -k - 1]], b]], {k, 0, 2}]]
```

## Properties and Relations

The predicate is the vanishing of the four defects read with the same margin.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}], s = Append[Catenate @ Table[{{i, i}, {i + 1, i}}, {i, 0, 5}], {6, 6}]},
  {t = Select[(# + {0, 2}) & /@ s, Max[#] <= 6 &]},
  AllTrue[Catenate @ Table[{head, k}, {head, {InfraMessageFunction[a, b], InfraMessageFunction[b, a], InfraEchoFunction[a, b], InfraMessageFunction[s, t], InfraEchoFunction[t, s]}}, {k, 0, 2}],
    Apply[{head, k} |-> EPSMessageAxiomQ[g, head, "Margin" -> k] ===
      AllTrue[{"DomainDefect", "FunctionDefect", "InjectivityDefect", "OrderDefect"}, d |-> InfraMeasurement[g, head, d, "Margin" -> k] == 0]]]]
```

When the axiom holds, the relation has exactly one member, and [InfraMessageFunctionQ]() accepts it.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}], b = Table[{m, m + 2}, {m, 0, 4}]},
  {EPSMessageAxiomQ[g, InfraMessageFunction[b, a]], InfraMeasurement[g, InfraMessageFunction[b, a], "Cardinality"],
   InfraMessageFunctionQ[g, InfraMessageFunction[b, a], First /@ InfraMeasurement[g, InfraMessageFunction[b, a], "Relation"]]}]
```

On the lattice the chain {((*p* + 1)*m*, *pm*)} of velocity 1/(2*p* + 1) signals the resting chain {(*m*, *m*)} tick for tick, while the resting chain reaches only every *p*-th tick of it.

```wl
With[
  {g = CausalSubstrate["DiamondLatticeGraph", "Small"]},
  {a = Table[{m, m}, {m, 0, 6}]},
  Table[
    With[
      {b = Table[{(p + 1) m, p m}, {m, 1, Floor[6/(p + 1)]}]},
      {EPSMessageAxiomQ[g, InfraMessageFunction[b, a]], EPSMessageAxiomQ[g, InfraMessageFunction[a, b], "Margin" -> 1],
       InfraMeasurement[g, InfraMessageFunction[a, b], "DomainDefect", "Margin" -> 1]}],
    {p, 2}]]
```
