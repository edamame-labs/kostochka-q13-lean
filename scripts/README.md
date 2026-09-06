# Scripts

Requirements: Python 3.9+, `networkx`, `python-sat` (for `cegis.py`), a C compiler,
and nauty's `geng` on the PATH (`brew install nauty`).

| file | purpose |
|---|---|
| `verify_counterexample.py` | Exact check of the counterexamples for k = 3, 4: α_v condition, explicit equitable colouring, and non-existence of an SE L-colouring (enumerate colours of non-leaf vertices, max-flow for leaves with SE capacities). Run: `python3 verify_counterexample.py`. |
| `selc.c` | Brute force: for a given forest, enumerate all k-list assignments from a palette [p] (vertex 0's list fixed) and test SE L-colourability by backtracking. |
| `search.py` | Drives `selc` over all non-isomorphic forests on n vertices (via `geng`) that satisfy the α_v condition. Run: `python3 search.py n k p [--first]`. |
| `run_exhaustive.sh` | The exhaustive runs reported in the note. |
| `cegis.py` | SAT-based counterexample-guided search for a defeating list assignment on each forest (CaDiCaL via `python-sat`). Run: `python3 cegis.py n k p`. |
| `run_cegis.sh` | Background CEGIS runs; output in `out/cegis_*.txt`. |

All outputs are written to `out/` (git-ignored).
