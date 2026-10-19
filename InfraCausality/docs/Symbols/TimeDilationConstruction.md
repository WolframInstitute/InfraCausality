---
Template: Symbol
Name: TimeDilationConstruction
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/TimeDilationConstruction
Keywords: [time dilation, Lorentz factor, radar time, proper time, figure, Bondi k-calculus, experimental]
SeeAlso: [LorentzFactor, BondiRadarCoordinates, ProperTimeScale, LightClockConstruction, BondiViewer]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[TimeDilationConstruction]()[*v*]</code> draws the radar construction of one event on the worldline of velocity *v*, illustrating the time dilation $\gamma = (k + 1/k)/2$.

## Details & Options

Experimental: figure. The figure's layout and options may change.

Definition: the event $B$ at arc length `"EventArcLength"` on the worldline of velocity *v* ("Bob", red) is radar-located by the rest observer ("Alice", blue): she sends light at $\tau_{emit}$, it reaches $B$ and returns at $\tau_{return}$, and her radar time of $B$ is $\tau_{radar} = (\tau_{emit} + \tau_{return})/2$. The dashed orange line is Alice's line of simultaneity from $\tau_{radar}$ through $B$. Bob's own clock reads $\tau_B$ = <code>[ProperTimeScale]()[*v*, *φ*]</code> times the arc length at $B$, and $\tau_{radar} = \gamma\,\tau_B$ with γ = <code>[LorentzFactor]()[*v*]</code>, printed in the corner.

Both worldlines carry proper-time ticks at equal steps; by default the step is a quarter of $\tau_B$, so $B$ is Bob's fourth tick, and Alice's ticks run γ times as many steps to $\tau_{radar}$. The worldlines are drawn past $B$ and past the return, and every tick lies on them.

| Option | Default | |
|---|---|---|
| `"LightAngle"` | π/4 | the angle *φ* of light to the time axis |
| `"EventArcLength"` | 0.6 | the arc length of $B$ on the moving worldline |
| `"TickSpacing"` | `Automatic` | the proper-time step of the ticks; `Automatic` is $\tau_B / 4$ |
| `ImageSize` | 500 | |

## Basic Examples

The time dilation of the velocity 0.4.

```wl
TimeDilationConstruction[0.4]
```

The velocity 0.8 with light at the angle 1.2: Alice's ticks are denser because γ = 5/3.

```wl
TimeDilationConstruction[0.8, "LightAngle" -> 1.2]
```

## Properties and Relations

Alice's radar time of the event is γ times Bob's proper time of it, and her three marked events are its emission, return and radar time.

```wl
AllTrue[Tuples[{{0.2, 0.4, 0.8}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{disks = Cases[TimeDilationConstruction[v, "LightAngle" -> phi], Disk[c_, _] :> c, Infinity]},
    {b = First @ Select[disks, c |-> c[[1]] > 0]},
    {r = BondiRadarCoordinates[b, phi]},
    Abs[b[[2]]/(ProperTimeScale[v, phi] Norm[b]) - LorentzFactor[v]] < 10^-9 &&
      Max[Abs[Sort[Select[disks, c |-> c[[1]] == 0][[All, 2]]] - Sort[{r["EmitArcLength"], r["RadarTime"], r["ReturnArcLength"]}]]] < 10^-9]]]
```

The ticks on the moving worldline are equal proper-time steps, the event is the fourth, and every tick lies on the drawn worldline.

```wl
AllTrue[Tuples[{{0.2, 0.4, 0.8, 0.95}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{g = TimeDilationConstruction[v, "LightAngle" -> phi], d = Through[{Sin, Cos}[WorldlineAngle[v, phi]]], cross = {a, b} |-> a[[1]] b[[2]] - a[[2]] b[[1]]},
    {taus = Sort @ Map[pq |-> ProperTimeScale[v, phi] Norm[Mean[pq]],
      Select[Cases[g, Line[pq : {_, _}] :> pq, Infinity], pq |-> Abs[(pq[[2]] - pq[[1]]) . d] < 10^-9 && Abs[cross[Mean[pq], d]] < 10^-9]],
     drawn = Max @ Map[Norm, Select[Cases[g, Line[{{0 | 0., 0 | 0.}, q_}] :> q, Infinity], q |-> Abs[cross[q, d]] < 10^-9]]},
    Length[taus] >= 4 && Max[Abs[taus/First[taus] - Range[Length[taus]]]] < 10^-9 &&
      Abs[taus[[4]] - 0.6 ProperTimeScale[v, phi]] < 10^-9 && Max[taus]/ProperTimeScale[v, phi] <= drawn]]]
```

The dashed line starts at Alice's radar time of the event and runs through the event.

```wl
AllTrue[Tuples[{{0.2, 0.4, 0.8, 0.95}, {0.3, Pi/4, 1.2}}], Apply[{v, phi} |->
  With[{g = TimeDilationConstruction[v, "LightAngle" -> phi]},
    {b = First @ Select[Cases[g, Disk[c_, _] :> c, Infinity], c |-> c[[1]] > 0],
     now = First @ Cases[g, {Dashed, ___, Line[pts_]} :> pts, Infinity]},
    Max[Abs[First[now] - {0, b[[2]]}]] < 10^-9 && Abs[Last[now][[2]] - b[[2]]] < 10^-9 && Last[now][[1]] > b[[1]]]]]
```
