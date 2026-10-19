---
Template: Symbol
Name: DopplerConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/DopplerConstruction
Keywords: [Doppler effect, k-factor, light pulses, figure, Bondi k-calculus, experimental]
SeeAlso: [BondiKFactor, OutgoingRatio, ProperTimeScale, BondiClock, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[DopplerConstruction]()[*v*, *n*]</code> draws *n* evenly spaced light pulses from the rest worldline to the worldline of velocity *v*, showing the Bondi factor as a ratio of pulse spacings.

<code>[DopplerConstruction]()[*v*]</code> draws 6 pulses.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: the rest observer ("Alice", blue) emits *n* pulses at the arc lengths $s_0, s_0 + \Delta, \dots$, equally spaced in her proper time; each pulse runs to the right at the light angle and is received by the observer of velocity *v* ("Bob", red) at arc length <code>[OutgoingRatio]()[*v*, *φ*]</code> times its emission. The received pulses are equally spaced too, and in Bob's proper time (arc length times [ProperTimeScale]()) their spacing is $k\Delta$: the k-factor is the ratio of received to emitted period, the relativistic Doppler factor. The first spacing is marked on both worldlines, "Δτ" and "k Δτ".

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"EmitStart"` | 0.15 | the first emission $s_0$ |
| `"PulseSpacing"` | 0.12 | the emission spacing Δ |
| `ImageSize` | 500 | |

## Basic Examples

Six pulses to the observer of velocity 0.4.

```wl
DopplerConstruction[0.4]
```

Four pulses to the observer of velocity 0.7, light at the angle 1.

```wl
DopplerConstruction[0.7, 4, "LightAngle" -> 1.0]
```

## Properties and Relations

The receptions lie on the moving worldline, and their spacing in proper time is *k* times the emission spacing.

```wl
AllTrue[Tuples[{{0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{disks = Cases[DopplerConstruction[v, 6, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity]},
    {alice = Select[disks, c |-> c[[1]] == 0], bob = Select[disks, c |-> c[[1]] > 0]},
    Length[bob] == 6 && Max[Abs[bob - Map[Norm, bob] Table[Through[{Sin, Cos}[WorldlineAngle[v, phi]]], 6]]] < 10^-9 &&
      Max[Abs[Differences[ProperTimeScale[v, phi] Map[Norm, bob]] - BondiKFactor[v] Differences[alice[[All, 2]]]]] < 10^-9]]]
```

Each pulse runs along the rightgoing light direction.

```wl
AllTrue[Tuples[{{0.2, 0.5, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{disks = Cases[DopplerConstruction[v, 6, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity]},
    Max[Abs[Map[Normalize, Select[disks, c |-> c[[1]] > 0] - Select[disks, c |-> c[[1]] == 0]] - Table[{Sin[phi], Cos[phi]}, 6]]] < 10^-9]]]
```
