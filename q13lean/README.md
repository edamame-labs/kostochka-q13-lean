# Lean formalisation

`Q13lean/Counterexample.lean` formalises the counterexample to Question 13 of
Kierstead–Kostochka–Xiang for every `k ≥ 2`:

* `Q13.F k` — the forest `K_{1,(k-1)q-1} + K_{1,2k²}`, `q = 2k² + 1`, as a `SimpleGraph`;
* `Q13.L k` — the `k`-list assignment;
* `Q13.alpha_condition` — every vertex lies in an independent set of size `≥ |V| / k`;
* `Q13.no_equitable_L_coloring` — no proper `L`-colouring has all classes `≤ ⌈|V|/k⌉`;
* `Q13.not_SE_L_colorable`, `Q13.question13_false` — the strongly equitable version.

Build (Lean 4.34.0-rc2, Mathlib pinned in `lake-manifest.json`):

```bash
lake exe cache get
lake build
```

The theorems depend only on the axioms `propext`, `Classical.choice`, `Quot.sound`.
