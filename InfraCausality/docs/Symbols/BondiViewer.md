---
Template: Symbol
Name: BondiViewer
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/BondiViewer
Keywords: [viewer, Bondi k-calculus, interactive, Manipulate, figures, experimental]
SeeAlso: [BondiClock, DopplerConstruction, TimeDilationConstruction, SimultaneityConstruction, LengthContractionConstruction, VelocityAdditionConstruction, LightClockConstruction]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[BondiViewer]()[]</code> gives a `Manipulate` over the seven Bondi k-calculus constructions with sliders for the velocity, the light angle, the number of bounces and a second velocity.

## Details & Options

Experimental: viewer. The interface of the viewers may change.

Definition: the frame draws the chosen construction with the slider values, at image size 480:

| Construction | Frame |
|---|---|
| Clock | <code>[BondiClock]()[*β*, *n*, "LightAngle" -> *φ*]</code> |
| Doppler | <code>[DopplerConstruction]()[*β*, *n*, "LightAngle" -> *φ*]</code> |
| Time Dilation | <code>[TimeDilationConstruction]()[*β*, "LightAngle" -> *φ*]</code> |
| Simultaneity | <code>[SimultaneityConstruction]()[*β*, "LightAngle" -> *φ*]</code> |
| Length Contraction | <code>[LengthContractionConstruction]()[*β*, "LightAngle" -> *φ*]</code> |
| Velocity Addition | <code>[VelocityAdditionConstruction]()[*β*, *β*2, "LightAngle" -> *φ*]</code> |
| Light Clock | <code>[LightClockConstruction]()[*β*, *n*, "LightAngle" -> *φ*]</code> |

The sliders are the velocity *β* ∈ [0.05, 0.9] (initially 0.4), the light angle *φ* ∈ [0.15, π/2 − 0.05] (initially π/4), the bounces or pulses *n* ∈ {3, …, 15} (initially 8) and the second velocity *β*2 ∈ [0.05, 0.85] (initially 0.3), used by the velocity addition only. The result has `SaveDefinitions -> True`, so it keeps working in a fresh session.

## Basic Examples

The viewer, opening on the Bondi clock.

```wl
BondiViewer[]
```

The seven frames at the initial slider values, drawn without the viewer.

```wl
GraphicsGrid[Partition[{BondiClock[0.4, 8], DopplerConstruction[0.4, 8], TimeDilationConstruction[0.4], SimultaneityConstruction[0.4],
  LengthContractionConstruction[0.4], VelocityAdditionConstruction[0.4, 0.3], LightClockConstruction[0.4, 8], Graphics[{}]}, 4], ImageSize -> 800]
```

## Properties and Relations

Over the slider ranges the Bondi clock frame keeps its identity: the reflections on the moving worldline grow by $k^2$.

```wl
AllTrue[Tuples[{{0.05, 0.4, 0.9}, {0.15, Pi/4, Pi/2 - 0.05}}], Apply[{v, phi} |->
  With[{bob = Select[Cases[BondiClock[v, 8, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity], c |-> c[[1]] > 0]},
    Max[Abs[Ratios[Map[Norm, bob]] - BondiKFactor[v]^2]] < 10^-6]]]
```

Over the slider ranges the velocity addition frame composes the velocities: Carol's reception is $k_1 k_2$ times Alice's emission in proper time.

```wl
AllTrue[Tuples[{{0.05, 0.4, 0.9}, {0.05, 0.3, 0.85}, {0.15, Pi/4, Pi/2 - 0.05}}], Apply[{v1, v2, phi} |->
  With[{d = Cases[VelocityAdditionConstruction[v1, v2, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity]},
    Abs[ProperTimeScale[(v1 + v2)/(1 + v1 v2), phi] Norm[d[[3]]]/d[[1, 2]] - BondiKFactor[v1] BondiKFactor[v2]] < 10^-6]]]
```
