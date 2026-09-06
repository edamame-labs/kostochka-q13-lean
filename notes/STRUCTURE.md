# Structure of minimal counterexamples, and a general obstruction

Notation as in STATUS.md: n = kq + r' with 0 ≤ r' ≤ k−1 (ordinary remainder), so
⌊n/k⌋ = q, cap = ⌈n/k⌉ = q + [r' ≥ 1], and at most (n mod* k) classes may be full,
where n mod* k = k if r' = 0 and = r' otherwise. (C) means α_v ≥ q for all v.

## Lemma 1 (leaf extension) [PROVED]
Let v be a leaf of T with stem u and let f be an SE L-colouring of T − v.
(a) If 2 ≤ r' ≤ k−1: forbidden colours for v are f(u) and the ≤ r'−1 full classes
    of f (size q+1 in T − v, which has remainder r'−1). Putting v in a class of size
    ≤ q keeps it ≤ q+1 and creates at most one new full class, so ≤ r' full classes.
    Forbidden ≤ r' ≤ k−1 < |L(v)|: f always extends.
(b) If r' = 1: T − v has kq vertices, so all classes of f have size ≤ q; adding v
    anywhere gives the unique full class. Forbidden = {f(u)}: f always extends.
(c) If r' = 0: T − v has k(q−1) + (k−1) vertices, cap q, ≤ k−1 full classes.
    Forbidden: f(u) and the full classes. f extends unless f has exactly k−1 full
    classes, their colours are exactly L(v) − f(u), f(u) ∈ L(v), and u's class is
    not full. In that case the k−1 full classes hold (k−1)q vertices and the
    other q−1 vertices of T − v (u among them) lie in non-full classes.

## Lemma 2 (twin leaves) [PROVED]
Let T satisfy (C), r' ≥ 1, and let v, v' be two leaves with a common stem u.
Then T − v satisfies (C) with the same q (note ⌊(n−1)/k⌋ = q since r' ≥ 1).
Proof. If not, some w ∈ T − v has α_w(T−v) ≤ q−1 ≤ α_w(T) − 1, so every maximum
independent set I ∋ w of T contains v. Then u ∉ I and I − v + v' is independent
(v' is adjacent only to u), contains w (w ≠ v), and has the same size — a maximum
independent set containing w and avoiding v. Contradiction. ∎

## Corollary 3 [PROVED]
Fix k ≥ 3 and let T be a counterexample to the "if" direction of Q13 with the
minimum number of vertices, and suppose k ∤ n. Then no two leaves of T share a
stem, and T has no K₂ component.
Proof. Twins: by Lemma 2, T − v satisfies (C); by minimality T − v is SE
k-choosable; by Lemma 1(a),(b) every SE colouring of T − v extends, so T is SE
k-choosable — contradiction. K₂ component {u, v}: as in Lemma 2 with I − v + u. ∎
Remark. For k | n, T − v always satisfies (C) (its threshold is q − 1), so a
minimal counterexample with k | n has the property that for EVERY leaf v and
EVERY SE L-colouring f of T − v the blocking configuration of Lemma 1(c) occurs.
For twins v, v' at u this forces L(v) = L(v') = F ∪ {f(u), a} for every SE
colouring f of T − v − v' (F = its k−2 full classes) — a strong but not
contradictory constraint. Our counterexample F_k has k | n and huge twin sets.

## Proposition 4 (general obstruction) [PROVED]
Let T be a forest on n vertices, q = ⌊n/k⌋. Let u be a vertex, W a set of
vertices ≠ u, and for each w ∈ W let Y_w ⊆ N(w) − N[u], with the Y_w pairwise
disjoint. If
      d(u) − |W ∩ N(u)| + Σ_{w∈W} ⌊|Y_w| / k²⌋  >  n − q,
then T is not SE k-choosable.
Proof (adversary). L(u) = [k]; L(x) = [k] for x ∈ N(u) − W; L(w) = D := {k+1,…,2k}
for w ∈ W; split each Y_w into k² parts Y_{w,c,d} (c ∈ [k], d ∈ D) of sizes
⌊|Y_w|/k²⌋ or more, and give y ∈ Y_{w,c,d} the list ([k] − c) ∪ {d}; all other
lists arbitrary. Let f be an SE L-colouring, c = f(u). Every x ∈ N(u) − W is
coloured from [k] − c. For w ∈ W with d = f(w), every y ∈ Y_{w,c,d} is coloured
from [k] − c. In an SE colouring, k−1 colours carry at most (k−1)·cap vertices
with at most (n mod* k) classes full, i.e. at most (k−1)q + r' = n − q vertices.
The forced vertices number d(u) − |W ∩ N(u)| + Σ_w |Y_{w,c,f(w)}| ≥ LHS > n − q. ∎
(For KPW-equitable choosability replace n − q by (k−1)⌈n/k⌉; the same proof works.)

Check on F_k: u = u₀, d(u) = (k−1)q − 1, W = {w₀}, Y = N(w₀), |Y| = 2k², so
LHS = (k−1)q − 1 + 2 = (k−1)q + 1 > (k−1)q = n − q. ✓

Remark. Several w's contribute additively, but each costs a vertex outside N[u],
which enters (C) at u; for star forests one w is optimal (see COUNTEREXAMPLE.md).

## Consequence for the smallest counterexample (k = 3)
- Upper bound 57 (F₃ or the tree T₃).
- Exhaustive search (scripts/search.py): no counterexample with n ≤ 8 over
  palettes of size ≤ 5, nor with n ≤ 12 over palette 4 (k = 3). These are not
  complete lower bounds since a defeating assignment might need a larger palette
  (F₃ uses palette 6).
- Proposition 4 cannot fire for k = 3 unless some vertex w has ≥ 9 neighbours
  outside N[u] (or d(u) ≥ n − q, excluded by (C)); so any counterexample below
  the Proposition-4 regime would need a different mechanism.
