---
Template: Symbol
Name: VelocityAdditionConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/VelocityAdditionConstruction
Keywords: [velocity addition, k-factor, composition, rapidity, figure, Bondi k-calculus, experimental]
SeeAlso: [KFactor, VelocityFromK, Rapidity, OutgoingRatio, ProperTimeScale, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[VelocityAdditionConstruction]()[*v*1, *v*2]</code> draws three worldlines with Bondi factors *k*1, *k*2 and *k*1 *k*2, illustrating that composing velocities multiplies Bondi factors.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: "Bob" (red) moves at *v*1 relative to the rest observer "Alice" (blue), and "Carol" (green) at *v*2 relative to Bob. One light signal leaves Alice at arc length `"EmitArcLength"`, passes Bob and reaches Carol. Bob receives it at *k*1 times Alice's emission time, and Carol at *k*2 times Bob's reception time, each in the receiver's proper time; so Carol's reception is *k*1 *k*2 times Alice's emission, and Carol's velocity relative to Alice is $v_\oplus$ = <code>[VelocityFromK]()[*k*1 *k*2]</code> = $(v_1 + v_2)/(1 + v_1 v_2)$. The panel on the left prints *k*1, *k*2, *k*1 *k*2 and $v_\oplus$.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"EmitArcLength"` | 0.2 | Alice's emission arc length |
| `ImageSize` | 550 | |

## Basic Examples

Composing the velocities 0.4 and 0.3 gives 0.625, not 0.7.

```wl
VelocityAdditionConstruction[0.4, 0.3]
```

Composing 0.7 and 0.5 with light at the angle 1.

```wl
VelocityAdditionConstruction[0.7, 0.5, "LightAngle" -> 1.0]
```

## Properties and Relations

In proper times, Bob's reception is *k*1 times Alice's emission and Carol's is *k*2 times Bob's.

```wl
AllTrue[Tuples[{{0.4, 0.7}, {0.3, 0.5}, {Pi/4, 1.1}}], Apply[{v1, v2, phi} |->
  With[{d = Cases[VelocityAdditionConstruction[v1, v2, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity],
      vsum = (v1 + v2)/(1 + v1 v2)},
    Abs[ProperTimeScale[v1, phi] Norm[d[[2]]]/d[[1, 2]] - KFactor[v1]] < 10^-9 &&
      Abs[ProperTimeScale[vsum, phi] Norm[d[[3]]]/(ProperTimeScale[v1, phi] Norm[d[[2]]]) - KFactor[v2]] < 10^-9]]]
```

The signal is one light ray: Alice's emission, Bob's reception and Carol's reception are collinear along the rightgoing light direction.

```wl
AllTrue[Tuples[{{0.4, 0.7}, {0.3, 0.5}, {Pi/4, 1.1}}], Apply[{v1, v2, phi} |->
  With[{d = Cases[VelocityAdditionConstruction[v1, v2, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity], ray = LightDirection[phi, True]},
    Max[Abs[Map[p |-> (p - d[[1]])[[1]] ray[[2]] - (p - d[[1]])[[2]] ray[[1]], Rest[d]]]] < 10^-9]]]
```

The k-factors multiply, so the rapidities add.

```wl
FullSimplify[Rapidity[VelocityFromK[KFactor[v1] KFactor[v2]]] == Rapidity[v1] + Rapidity[v2], 0 < v1 < 1 && 0 < v2 < 1]
```
