---
Template: Symbol
Name: SimultaneityLine
Context: WolframInstitute`InfraCausality`
ContextPath: [WolframInstitute`InfraGeometry`]
Paclet: WolframInstitute/InfraCausality
URI: WolframInstitute/InfraCausality/ref/SimultaneityLine
Keywords: [simultaneity, line of simultaneity, radar midpoint, Einstein synchronisation, drawing helper, Bondi k-calculus, experimental]
SeeAlso: [SimultaneityConstruction, TimeDilationConstruction, BondiRadarCoordinates, LightDirection, WorldlineNormal]
RelatedGuides: [BondiKCalculus]
RelatedTutorials: [BondiKCalculus]
---

## Usage

<code>[SimultaneityLine]()[*v*, *s*, *φ*, *extent*]</code> gives {left end, base point, right end} of the simultaneity line through the point at arc length *s* on the worldline of velocity *v*: the events whose radar midpoint on that worldline is the base point, along $(\tan\varphi, v)$ with *extent* to each side.

<code>[SimultaneityLine]()[*v*, *s*, *φ*]</code> takes *extent* 1, and <code>[SimultaneityLine]()[*v*, *s*]</code> also *φ* = π/4.

## Details & Options

Experimental: drawing helper. The helpers behind the Bondi figures may change.

Definition: the observer of velocity *v* assigns an event *E* the radar time of the midpoint of the emission and the return of light sent to *E* and echoed back. The events with radar midpoint at the base point $B$ form a line through $B$: with *d* the worldline direction, $E = B + c\,w$ has emission and return at $B \mp c\,d$ exactly when $E - (B - c\,d)$ is rightgoing light and $(B + c\,d) - E$ leftgoing, which gives $w \propto (\tan\varphi\cos\alpha, \sin\alpha/\tan\varphi) \propto (\tan\varphi, v)$ using $\tan\alpha = v\tan\varphi$. The ends are $B \pm$ *extent* times the unit vector along it.

At rest the line is horizontal; at *φ* = π/4 it has slope *v*, the mirror image of the worldline in the light direction. It is not the Euclidean normal ([WorldlineNormal]()) unless *v* = 0.

## Basic Examples

The simultaneity line through the point at arc length 1 on the worldline of velocity 3/5.

```wl
SimultaneityLine[3/5, 1, Pi/4, 1]
```

The simultaneity lines of the velocities 0, 0.3, 0.6 through the point at arc length 1, light at π/4.

```wl
Graphics[Table[With[{c = {StandardBlue, StandardOrange, StandardRed}[[i]], v = {0, 0.3, 0.6}[[i]]},
    {c, AbsoluteThickness[2], Line[{{0, 0}, 1.4 WorldlineDirection[v]}], Dashed, Line[SimultaneityLine[v, 1, Pi/4, 0.5]]}], {i, 3}], ImageSize -> 250]
```

## Properties and Relations

Every point of the line has its radar midpoint at the base point.

```wl
With[{midpoint = {p, v, phi} |-> Mean[Map[right |-> First @ LinearSolve[Transpose[{WorldlineDirection[v, phi], LightDirection[phi, right]}], p], {True, False}]]},
  FullSimplify[midpoint[SimultaneityLine[v, s, phi, c][[3]], v, phi] == s, 0 < v < 1 && 0 < phi < Pi/2 && s > 0 && c > 0] &&
    FullSimplify[Map[p |-> midpoint[p, 3/5, Pi/3], SimultaneityLine[3/5, 2, Pi/3, 1/2]]] === {2, 2, 2}]
```

At the light angle π/4 the line has slope *v*.

```wl
FullSimplify[With[{sl = SimultaneityLine[v, s, Pi/4, 1]}, (sl[[3, 2]] - sl[[2, 2]])/(sl[[3, 1]] - sl[[2, 1]]) == v], 0 < v < 1 && s > 0]
```

The base point is the middle element, and the ends are *extent* away.

```wl
FullSimplify[With[{sl = SimultaneityLine[v, s, phi, c]}, sl[[2]] == WorldlinePoint[v, s, phi] && Norm[sl[[3]] - sl[[2]]] == c && Norm[sl[[1]] - sl[[2]]] == c],
  0 < v < 1 && 0 < phi < Pi/2 && s > 0 && c > 0]
```
