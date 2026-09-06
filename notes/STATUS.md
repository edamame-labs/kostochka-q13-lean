# STATUS — KKX Question 13 for forests

Last updated: 2026-09-06 (session 2)

## Statement
Q13 (arXiv:2504.14711): for k ≥ 3, is an n-vertex forest T SE k-choosable
⇔ α_v(T) ≥ ⌊n/k⌋ for every v?  "⇒" is trivial (constant lists [k]).

## RESULT: the answer is NO, for every k ≥ 3 (even k ≥ 2), even for trees.
See `notes/COUNTEREXAMPLE.md` [PROVED, computer-verified for k = 3, 4].
Smallest example found: n = 2k³ + k (k = 3: the forest K_{1,37} + K_{1,18},
or the tree obtained by joining a leaf of each star), which is equitably
k-colourable but not even equitably k-choosable in the KPW sense.
Kaul–Mudrock–Wagstrom (arXiv:2008.06333, Prop. 22) already contains a larger
example of the same type (n = k⁴ − k² + 3k), not noticed in the KKX survey.

## Searches, no counterexample found (all forests satisfying (C)):
- exhaustive (scripts/search.py + selc.c): k=3: n ≤ 12 (palette 4), n ≤ 8 (palette 5);
  k=4: n ≤ 11 (palette 5), n = 7 (palette 6); k=5: n ≤ 10 (palette 6).
- CEGIS (scripts/cegis.py, SAT): k=3: n ≤ 10 (palette 5); n = 9 with palette 6 in progress.
Caveat: a defeating assignment may need a larger palette (F_k uses 2k colours), so these
are not lower bounds on the smallest counterexample.

## Open follow-ups
1. Smallest counterexample for k = 3? Lower bound: none with n ≤ 8 (palette ≤ 5).
   Upper bound 57. The two-star analysis (COUNTEREXAMPLE.md, "why slack 0 is
   impossible") suggests 2k² stuck leaves are needed for star forests, but other
   tree shapes were not analysed.
2. What is the right SE-list analogue of Theorem 27? See notes/ANALOGUE.md:
   necessary conditions (C) + (G) [PROVED], Conjecture A that they suffice [CONJECTURED].
3. Does Q13 hold for trees/forests with bounded maximum degree relative to k,
   e.g. Δ ≤ 2k−2 (KPW: forests with k ≥ 1+Δ/2 are equitably k-choosable)?
4. Lean formalisation: DONE for the counterexample — `q13lean/Q13lean/Counterexample.lean`
   (Lean 4.34.0-rc2 + Mathlib; `lake build` succeeds; no sorry; axioms propext/choice/Quot.sound).
   Main theorem `Q13.question13_false`. Not formalised: Theorem 27 itself, the tree variant.
5. Draft note: `paper/note.tex` → `paper/note.pdf` (tectonic). Includes the general
   obstruction (Prop. 4 of notes/STRUCTURE.md).
6. Candidate corrected characterisation: notes/ANALOGUE.md (Conjecture A: (C) + (G)).
7. Smallest counterexample: notes/STRUCTURE.md (minimal-counterexample lemmas) and the
   CEGIS search `scripts/cegis.py` (results in scripts/out/cegis_*.txt).

## Partial positive results (kept for follow-up 3)
Lemma 1 (leaf extension) in the previous version of this file: an SE
L-colouring of T − v (v a leaf) always extends to T when n mod k ∉ {0};
when k | n it fails only in a very specific configuration. See git history /
log 2026-09-05 for details. Superseded as a route to Q13 (which is false).
