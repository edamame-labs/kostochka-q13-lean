# AGENTS.md — Kierstead–Kostochka–Xiang Question 13 (forests)

Research workspace for **Question 13** of H. A. Kierstead, A. V. Kostochka and
Z. Xiang, *Results and Problems on Equitable Coloring of Graphs*,
arXiv:2504.14711 (Sum(m)it 280, Bolyai Soc. Math. Studies 32, 2026).
Read this file first.

## 1. The question

**Question 13 (KKX).** Does the claim of Theorem 27 hold for SE list coloring?
That is: for each k ≥ 3, is every n-vertex forest T SE k-choosable if and only
if α_v(T) ≥ ⌊n/k⌋ for every vertex v of T?

**Theorem 27 (Chen–Lih 1994; Miyata–Tokunaga–Kaneko 1994; short proof Chang 2009).**
For a forest T of order n and k ≥ 3, T is equitably k-colorable iff
α_v ≥ ⌊n/k⌋ for every v ∈ V(T).

## 2. Definitions (verbatim semantics from arXiv:2411.08372 §1.2 and the survey §4)

- α_v(G): size of a largest independent set of G containing v.
- k-list assignment L: |L(v)| = k for all v. An L-coloring is a proper coloring
  with f(v) ∈ L(v).
- n mod* k: the unique r ∈ {1,…,k} with n ≡ r (mod k). So (kq) mod* k = k.
- A color class X is **full** if |X| = ⌈n/k⌉, **overfull** if |X| > ⌈n/k⌉.
- (KPW 2003) An L-coloring is *list-equitable* if it has no overfull class;
  G is *equitably k-choosable* if it has one for every k-list assignment.
- (KKX) An L-coloring is **strongly equitable (SE)** if it has no overfull
  class and at most n mod* k full classes. G is **SE L-colorable** if such a
  coloring exists, **SE k-choosable** if SE L-colorable for every k-list
  assignment L.
- Facts: SE k-choosable ⇒ equitably k-choosable and equitably k-colorable.
  When all lists equal [k], an SE L-coloring is exactly an equitable k-coloring
  (write n = kq + r, 1 ≤ r ≤ k: r classes of size q+1 and k−r of size q).
  Hence the "only if" direction of Q13 is immediate; the content is "if".
- Note: an SE L-coloring may use more than k colors. Class sizes are bounded
  above only; a class may be tiny. The binding constraints are the per-color
  cap ⌈n/k⌉ and the global bound of n mod* k full classes.

## 3. Repository layout

```
AGENTS.md      this file
README.md      short description
logs/          one log per session (mandatory), logs/INDEX.md lists them
notes/         mathematics: STATUS.md, lemmas with [PROVED]/[SKETCH]/[CONJECTURED]/[FALSE]
lit/           bibliography.md (verified) and fetch.sh for plain text of the KKX papers
scripts/       computational experiments (C + Python; nauty's geng/gentreeg available)
```

## 4. Conventions

- Log every session in `logs/YYYY-MM-DD_HHMM_<slug>.md`; never rewrite old logs.
- A lemma is `[PROVED]` only after a full write-up re-read adversarially.
- Computational claims: script in `scripts/`, exact command + output in the log.
- Distinguish literature results / our results / conjectures. No fabricated citations.
- Keep `notes/STATUS.md` current.
