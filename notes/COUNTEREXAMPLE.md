# Question 13 has a negative answer  [PROVED — verified by computer for k = 3, 4]

**Theorem.** For every k ≥ 2 there is a forest (indeed a tree) T on n = 2k³ + k
vertices such that α_v(T) ≥ ⌊n/k⌋ for every vertex v (so T is equitably
k-colourable), but T is not equitably k-choosable in the sense of
Kostochka–Pelsmajer–West, hence not SE k-choosable. So the "if" direction of
KKX Question 13 fails for every k ≥ 3.

## Construction
Let q := 2k² + 1 and n := kq = 2k³ + k. Let F_k be the disjoint union of
- a star with centre u₀ and m₁ := (k−1)q − 1 leaves (the set A), and
- a star with centre w₀ and m₂ := 2k² leaves (the set B).

Then |F_k| = 2 + (k−1)q − 1 + 2k² = (k−1)q + q = kq = n. ✓

Index B by triples (c, d, t) with c ∈ [k], d ∈ {k+1, …, 2k}, t ∈ {1, 2}.

## (C) holds and F_k is equitably k-colourable
⌊n/k⌋ = q. α_{u₀} = 1 + |B| = 2k² + 1 = q (u₀ together with all leaves of w₀).
α_{w₀} = 1 + |A| ≥ q. Every leaf lies in an independent set of size ≥ n − 2.
Explicit equitable k-colouring: class 1 := {u₀} ∪ B (size q, independent);
the remaining (k−1)q vertices {w₀} ∪ A form an independent set — split them
into k−1 classes of size q. ∎ (Also follows from Theorem 27.)

## The list assignment L (all lists of size k)
- L(u₀) = [k] and L(a) = [k] for every a ∈ A;
- L(w₀) = {k+1, …, 2k};
- L(b_{c,d,t}) = ([k] − {c}) ∪ {d}  for all c ∈ [k], d ∈ {k+1,…,2k}, t ∈ {1,2}.

## No L-colouring has all classes of size ≤ ⌈n/k⌉ = q
Suppose f is such an L-colouring. Let c := f(u₀) ∈ [k]. Every leaf a ∈ A is
adjacent to u₀ and has list [k], so f(a) ∈ [k] − {c}. These k−1 colours
carry at most (k−1)q vertices in total, and already carry |A| = (k−1)q − 1
leaves; hence at most ONE further vertex of T may receive a colour from
[k] − {c}. Let d := f(w₀) ∈ {k+1,…,2k}. The two leaves b_{c,d,1}, b_{c,d,2}
are adjacent to w₀, so neither may use d; their only other colours are
[k] − {c}. Two vertices need colours from [k] − {c} but only one slot is
free — contradiction. ∎

Since n = kq, an SE L-colouring is exactly an L-colouring with all classes
≤ q (n mod* k = k, so the "≤ r full classes" clause is vacuous). Hence F_k is
not SE k-choosable, and not even equitably k-choosable (KPW).

## Tree variant
Add the edge a₀ b₀ for one leaf a₀ ∈ A and one leaf b₀ ∈ B. This only adds a
constraint, so non-colourability persists. (C) still holds (the independent
sets used above avoid a₀ or b₀ as needed), and the explicit equitable
colouring above can be arranged with a₀ and b₀ in different classes.
So the statement fails even for trees.

## Relation to the literature
Kaul, Mudrock and Wagstrom, *On the equitable choosability of the disjoint
union of stars* (arXiv:2008.06333, 2020), Proposition 22, show that
K_{1,(k−1)(k³−k+2)} + K_{1,k³} (n = k(k³−k+3)) is not equitably k-choosable,
using k leaves per pair (c,d) and slack k−1. That forest also satisfies (C)
(α_{u₀} = k³+1 ≥ k³−k+3), so their proposition already answers Q13
negatively, although it is not phrased that way. The construction above is
the slack-1 version (2 leaves per pair), giving n = 2k³ + k (57 for k = 3
instead of 81).

Why slack 0 is impossible: with |A| = (k−1)q the counting forces
|B| = q − 2, so α_{u₀} = q − 1 < q — exactly the obstruction that makes
Theorem 27 true. Slack S ≥ 1 is forced by (C) at u₀, and S = 1 needs S+1 = 2
stuck leaves per pair (c,d) ∈ [k] × L(w₀), i.e. |B| ≥ 2k², hence q ≥ 2k²+1.

## Computer verification
`scripts/verify_counterexample.py` (exact: enumerate colours of degree-≥2
vertices, max-flow for the leaves with SE capacities) confirms for k = 3, 4:
(C) holds, the explicit equitable colouring is valid, and no SE L-colouring
exists — for F_k, the tree variant T_k, and the KMW forest.
