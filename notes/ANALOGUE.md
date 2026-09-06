# Towards the correct SE-list analogue of Theorem 27

Theorem 27 (Chen–Lih, MTK, Chang): a forest T is equitably k-colourable (k ≥ 3) iff
(C) α_v(T) ≥ ⌊n/k⌋ for all v.

For SE k-choosability, (C) is necessary but not sufficient (COUNTEREXAMPLE.md).
What extra condition is needed?

## Necessary conditions we can prove
(C)  α_v ≥ q := ⌊n/k⌋ for all v.                                    [constant lists]
(G)  for every vertex u, every set W of vertices ≠ u and pairwise disjoint
     Y_w ⊆ N(w) − N[u] (w ∈ W):
         d(u) − |W ∩ N(u)| + Σ_{w∈W} ⌊|Y_w| / k²⌋ ≤ n − q.       [STRUCTURE.md, Prop. 4]

(G) with W = ∅ reads d(u) ≤ n − q, which is implied by (C) since α_u ≤ n − d(u).
So (G) is only new when some vertex w has at least k² neighbours outside N[u].

## Candidate characterisation [CONJECTURED — weak evidence]
Conjecture A. For k ≥ 3, a forest T is SE k-choosable iff (C) and (G) hold.

Evidence for: (i) the two-star analysis in COUNTEREXAMPLE.md shows that within
the "one wasted class + forced neighbourhood" mechanism, (G) is exactly the
obstruction; (ii) no other mechanism has been found; (iii) all forests with n ≤ 12
satisfying (C) are SE 3-choosable over palette 4, consistent with A because (G) is
vacuous there (it needs d(w) ≥ 9).
Evidence against / doubts: (i) Kaul–Mudrock–Wagstrom could not characterise even
K_{1,m₁} + K_{1,m₂} for KPW-equitable choosability (their Theorem 7 is a sufficient
condition with a large additive constant, and Question 8 there is open), which
suggests the true condition may be messier; (ii) mechanisms where the blocking
vertex w has its colour forced (rather than free among k values) would give
obstructions with k rather than k² in the denominator, but we could not build one
in a forest because the forcing needs cycles or additional wasted classes.

## A weaker, safer question
Question B. Is a forest T SE k-choosable whenever (C) holds and Δ(T) ≤ n − q − k²?
(Under this degree bound (G) is vacuous.) A positive answer would say the two-star
mechanism is the only one; a negative answer would exhibit a genuinely new obstruction.

## Sanity: single stars
K_{1,m} (n = m+1). (C) ⇔ m ≤ 2k − 2. Known (KPW, quoted in KMW): K_{1,m} is equitably
k-choosable iff m ≤ ⌈(m+1)/k⌉ (k−1). For SE with m ≤ 2k−2 (so q ≤ 1): every SE
L-colouring needs classes ≤ cap with cap = 2 when k ≤ m ≤ 2k−2, at most r' = m+1−k
full classes; the centre's colour c leaves ≥ k−1 colours per leaf; the leaves form a
b-matching problem with capacity (k−1)·1 + r' = m ≥ m. So single stars satisfying (C)
are SE k-choosable — consistent with Conjecture A (G is vacuous for a single star).
