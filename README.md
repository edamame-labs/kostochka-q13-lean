# Kierstead–Kostochka–Xiang Question 13 for forests

**Question 13** of Kierstead, Kostochka and Xiang, *Results and Problems on Equitable
Coloring of Graphs* ([arXiv:2504.14711](https://arxiv.org/abs/2504.14711)), asks whether,
for k ≥ 3, an n-vertex forest T is strongly equitably (SE) k-choosable if and only if
α_v(T) ≥ ⌊n/k⌋ for every vertex v, in analogy with the Chen–Lih / Miyata–Tokunaga–Kaneko
characterisation of equitably k-colourable forests.

**The independence condition is necessary but not sufficient, for every k ≥ 3, even for
trees.** With q = 2k² + 1, the forest K₁,(k−1)q−1 ∪ K₁,2k² on n = kq = 2k³ + k vertices
satisfies the independence condition (it is equitably k-colourable), but a specific k-list
assignment admits no colouring with all classes of size ≤ ⌈n/k⌉, so it is not equitably
k-choosable even in the weaker sense of Kostochka–Pelsmajer–West. Joining a leaf of each
star by an edge gives a tree with the same properties. The condition fails by a single
vertex, so a modified characterisation may still exist; the note formulates a general
obstruction and the resulting open questions. A larger example of the same type appears in
Kaul–Mudrock–Wagstrom ([arXiv:2008.06333](https://arxiv.org/abs/2008.06333), Prop. 22),
constructed there for a different purpose.

## Contents

| path | what |
|---|---|
| `docs/index.html` | Interactive tutorial: every definition from scratch, then the counterexample taken apart. Deployed to GitHub Pages. |
| `paper/note.tex`, `paper/note.pdf` | Short note with the construction, proof, a general obstruction, and open questions. |
| `q13lean/` | Lean 4 + Mathlib formalisation of the counterexample for all k ≥ 2 (`Q13.question13_false`); no `sorry`. See `q13lean/README.md`. |
| `scripts/` | Exact verification (`verify_counterexample.py`), exhaustive and SAT-based searches for small counterexamples. See `scripts/README.md`. |
| `notes/` | Working mathematics: `COUNTEREXAMPLE.md` (proof), `STRUCTURE.md` (minimal-counterexample lemmas, general obstruction), `ANALOGUE.md` (candidate corrected characterisation), `STATUS.md`. |
| `lit/` | Verified bibliography; `fetch.sh` regenerates plain text of the KKX papers locally. |
| `logs/` | Dated session logs, including dead ends. |
| `AGENTS.md` | Definitions and working conventions for this repository. |

## Tutorial

An interactive walkthrough of the background and the proof, aimed at a reader with
undergraduate graph theory: **<https://edamame-labs.github.io/kostochka-q13-lean/>**

It is a single self-contained file, `docs/index.html` — no build step, no dependencies
beyond a web font. `.github/workflows/pages.yml` publishes `docs/` on every push to `main`.
To view it locally, open the file in a browser, or:

```bash
python3 -m http.server -d docs 8000   # then http://localhost:8000
```

## Reproduce

```bash
# exact check of the counterexamples for k = 3, 4 (needs python3 + networkx)
python3 scripts/verify_counterexample.py

# Lean proof (needs elan; downloads the Mathlib cache)
cd q13lean && lake exe cache get && lake build

# note
cd paper && tectonic note.tex
```

## Status

The smallest counterexample is not known (at most 57 vertices for k = 3). Whether the
independence condition together with the general obstruction of the note characterises
SE k-choosability of forests is open. See `notes/STATUS.md`.

## License

MIT, see `LICENSE`.
