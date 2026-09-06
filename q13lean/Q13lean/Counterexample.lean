import Mathlib

/-!
# A counterexample to Question 13 of Kierstead, Kostochka and Xiang

Question 13 of Kierstead–Kostochka–Xiang, *Results and Problems on Equitable Coloring of
Graphs* (arXiv:2504.14711) asks whether, for `k ≥ 3`, an `n`-vertex forest `T` is strongly
equitably (SE) `k`-choosable if and only if `α_v(T) ≥ ⌊n/k⌋` for every vertex `v`.

We formalise the counterexample. Fix `k ≥ 2`, let `q = 2k² + 1` and `n = kq`.
The forest `F k` is the disjoint union of a star with centre `u₀` and `(k-1)q - 1` leaves
(`A`), and a star with centre `w₀` and `2k²` leaves (`B`, indexed by `(c, d, t)` with
`c d : Fin k`, `t : Fin 2`).

* `alpha_condition`: every vertex lies in an independent set of size at least `n / k = q`.
* `no_equitable_L_coloring`: with lists `L u₀ = L a = [k]`, `L w₀ = {k, …, 2k-1}`,
  `L (b (c,d,t)) = ([k] \ {c}) ∪ {k + d}`, every proper `L`-colouring has a colour class of
  size `> q = ⌈n/k⌉`. Hence `F k` is not equitably `k`-choosable (Kostochka–Pelsmajer–West),
  and a fortiori not SE `k`-choosable (`not_SE_L_colorable`).

The proof of the main lemma is the pigeonhole principle: if `f u₀ = c` and `f w₀ = k + d`,
then the `(k-1)q - 1` leaves of `u₀` and the two leaves `b (c,d,0)`, `b (c,d,1)` are all
coloured from the `k - 1` colours `[k] \ {c}`, so some colour is used more than `q` times.
-/

namespace Q13

open Finset

variable (k : ℕ)

/-- `q = 2k² + 1`; we take `n = kq`. -/
def q : ℕ := 2 * k ^ 2 + 1

/-- Number of leaves of `u₀`. -/
def m : ℕ := (k - 1) * q k - 1

/-- Index type of the leaves of `u₀`. -/
abbrev A := Fin (m k)

/-- Index type of the leaves of `w₀`: one pair of leaves for each `(c, d) ∈ [k] × [k]`. -/
abbrev B := Fin k × Fin k × Fin 2

/-- The vertex set: `u₀`, the leaves `A`, `w₀`, the leaves `B`. -/
abbrev V := Unit ⊕ A k ⊕ Unit ⊕ B k

/-- Centre of the first star. -/
def u0 : V k := Sum.inl ()
/-- Leaves of the first star. -/
def a (i : A k) : V k := Sum.inr (Sum.inl i)
/-- Centre of the second star. -/
def w0 : V k := Sum.inr (Sum.inr (Sum.inl ()))
/-- Leaves of the second star. -/
def b (x : B k) : V k := Sum.inr (Sum.inr (Sum.inr x))

/-- Generating relation of the edge set: `u₀ ~ a i` and `w₀ ~ b x`. -/
def R : V k → V k → Prop
  | Sum.inl _, Sum.inr (Sum.inl _) => True
  | Sum.inr (Sum.inr (Sum.inl _)), Sum.inr (Sum.inr (Sum.inr _)) => True
  | _, _ => False

/-- The forest `K_{1,(k-1)q-1} + K_{1,2k²}`. -/
def F : SimpleGraph (V k) := SimpleGraph.fromRel (R k)

lemma adj_u0_a (i : A k) : (F k).Adj (u0 k) (a k i) := by
  simp [F, SimpleGraph.fromRel_adj, u0, a, R]

lemma adj_w0_b (x : B k) : (F k).Adj (w0 k) (b k x) := by
  simp [F, SimpleGraph.fromRel_adj, w0, b, R]

lemma not_adj_u0_b (x : B k) : ¬ (F k).Adj (u0 k) (b k x) := by
  simp [F, SimpleGraph.fromRel_adj, u0, b, R]

lemma not_adj_w0_a (i : A k) : ¬ (F k).Adj (w0 k) (a k i) := by
  simp [F, SimpleGraph.fromRel_adj, w0, a, R]

lemma not_adj_a_a (i j : A k) : ¬ (F k).Adj (a k i) (a k j) := by
  simp [F, SimpleGraph.fromRel_adj, a, R]

lemma not_adj_b_b (x y : B k) : ¬ (F k).Adj (b k x) (b k y) := by
  simp [F, SimpleGraph.fromRel_adj, b, R]

lemma not_adj_a_b (i : A k) (x : B k) : ¬ (F k).Adj (a k i) (b k x) := by
  simp [F, SimpleGraph.fromRel_adj, a, b, R]

lemma a_injective : Function.Injective (a k) := fun _ _ h => by
  simpa [a] using h

lemma b_injective : Function.Injective (b k) := fun _ _ h => by
  simpa [b] using h

/-! ### The list assignment -/

/-- The `k`-list assignment: `[k]` on `u₀` and its leaves, `{k, …, 2k-1}` on `w₀`,
and `([k] \ {c}) ∪ {k + d}` on the leaf `b (c, d, t)`. -/
def L : V k → Finset ℕ
  | Sum.inl _ => range k
  | Sum.inr (Sum.inl _) => range k
  | Sum.inr (Sum.inr (Sum.inl _)) => Ico k (2 * k)
  | Sum.inr (Sum.inr (Sum.inr (c, d, _))) => insert (k + d.val) ((range k).erase c.val)

lemma L_b (c d : Fin k) (t : Fin 2) :
    L k (b k (c, d, t)) = insert (k + d.val) ((range k).erase c.val) := rfl

/-- Every list has exactly `k` colours. -/
lemma card_L (v : V k) : (L k v).card = k := by
  rcases v with _ | i | _ | ⟨c, d, t⟩
  · simp [L]
  · simp [L]
  · simp [L]; omega
  · have hc := c.isLt
    simp only [L]
    rw [card_insert_of_notMem, card_erase_of_mem (mem_range.mpr hc), card_range]
    · omega
    · rw [mem_erase, mem_range]; omega

/-! ### Counting -/

lemma card_B : Fintype.card (B k) = 2 * k ^ 2 := by
  simp only [B, Fintype.card_prod, Fintype.card_fin]; ring

lemma one_le_km1q (hk : 2 ≤ k) : 1 ≤ (k - 1) * q k :=
  Nat.one_le_iff_ne_zero.mpr (Nat.mul_ne_zero (by omega) (by simp [q]))

lemma three_le_q (hk : 2 ≤ k) : 3 ≤ q k := by
  have : 1 ≤ k ^ 2 := Nat.one_le_pow _ _ (by omega)
  unfold q; omega

lemma three_le_km1q (hk : 2 ≤ k) : 3 ≤ (k - 1) * q k :=
  le_trans (three_le_q k hk) (Nat.le_mul_of_pos_left _ (by omega))

lemma k_mul_q (hk : 2 ≤ k) : k * q k = (k - 1) * q k + q k := by
  nth_rewrite 1 [← Nat.sub_add_cancel (show 1 ≤ k by omega)]
  rw [Nat.add_mul, one_mul]

/-- `|V| = kq`. -/
lemma card_V (hk : 2 ≤ k) : Fintype.card (V k) = k * q k := by
  have h1 := one_le_km1q k hk
  have e := k_mul_q k hk
  have hB := card_B k
  have hq : q k = 2 * k ^ 2 + 1 := rfl
  have hA : Fintype.card (A k) = (k - 1) * q k - 1 := Fintype.card_fin _
  rw [show Fintype.card (V k) = Fintype.card Unit + (Fintype.card (A k) +
      (Fintype.card Unit + Fintype.card (B k))) from by
    simp only [Fintype.card_sum]]
  rw [Fintype.card_unit, hA, hB, e]
  generalize (k - 1) * q k = P at *
  omega

lemma card_V_div (hk : 2 ≤ k) : Fintype.card (V k) / k = q k := by
  rw [card_V k hk, Nat.mul_div_cancel_left _ (by omega)]

/-! ### Every vertex lies in an independent set of size `q` -/

/-- The independent set `{u₀} ∪ B`, of size `2k² + 1 = q`. -/
def S1 : Finset (V k) := insert (u0 k) (univ.image (b k))
/-- The independent set `{w₀} ∪ A`, of size `(k-1)q`. -/
def S2 : Finset (V k) := insert (w0 k) (univ.image (a k))
/-- The independent set `A ∪ B` of all leaves, of size `kq - 2`. -/
def S3 : Finset (V k) := univ.image (a k) ∪ univ.image (b k)

lemma u0_notMem_image_b : u0 k ∉ univ.image (b k) := by
  simp [u0, b]

lemma w0_notMem_image_a : w0 k ∉ univ.image (a k) := by
  simp [w0, a]

lemma card_S1 : (S1 k).card = q k := by
  rw [S1, card_insert_of_notMem (u0_notMem_image_b k), card_image_of_injective _ (b_injective k),
    card_univ, card_B, q]

lemma card_S2 (hk : 2 ≤ k) : (S2 k).card = (k - 1) * q k := by
  rw [S2, card_insert_of_notMem (w0_notMem_image_a k), card_image_of_injective _ (a_injective k),
    card_univ, Fintype.card_fin, m]
  have := one_le_km1q k hk
  omega

lemma card_S3 (hk : 2 ≤ k) : (S3 k).card = k * q k - 2 := by
  rw [S3, card_union_of_disjoint, card_image_of_injective _ (a_injective k),
    card_image_of_injective _ (b_injective k), card_univ, card_univ, Fintype.card_fin, m,
    card_B, k_mul_q k hk]
  · have := one_le_km1q k hk
    have hq : q k = 2 * k ^ 2 + 1 := rfl
    generalize (k - 1) * q k = P at *
    omega
  · rw [disjoint_left]
    simp [a, b]

lemma isIndepSet_S1 : (F k).IsIndepSet (S1 k : Set (V k)) := by
  intro v hv w hw hvw
  simp only [S1, coe_insert, coe_image, coe_univ, Set.image_univ, Set.mem_insert_iff,
    Set.mem_range] at hv hw
  rcases hv with rfl | ⟨x, rfl⟩ <;> rcases hw with rfl | ⟨y, rfl⟩
  · exact absurd rfl hvw
  · exact not_adj_u0_b k y
  · exact fun h => not_adj_u0_b k x h.symm
  · exact not_adj_b_b k x y

lemma isIndepSet_S2 : (F k).IsIndepSet (S2 k : Set (V k)) := by
  intro v hv w hw hvw
  simp only [S2, coe_insert, coe_image, coe_univ, Set.image_univ, Set.mem_insert_iff,
    Set.mem_range] at hv hw
  rcases hv with rfl | ⟨x, rfl⟩ <;> rcases hw with rfl | ⟨y, rfl⟩
  · exact absurd rfl hvw
  · exact not_adj_w0_a k y
  · exact fun h => not_adj_w0_a k x h.symm
  · exact not_adj_a_a k x y

lemma isIndepSet_S3 : (F k).IsIndepSet (S3 k : Set (V k)) := by
  intro v hv w hw _
  simp only [S3, coe_union, coe_image, coe_univ, Set.image_univ, Set.mem_union,
    Set.mem_range] at hv hw
  rcases hv with ⟨x, rfl⟩ | ⟨x, rfl⟩ <;> rcases hw with ⟨y, rfl⟩ | ⟨y, rfl⟩
  · exact not_adj_a_a k x y
  · exact not_adj_a_b k x y
  · exact fun h => not_adj_a_b k y x h.symm
  · exact not_adj_b_b k x y

/-- **The hypothesis of Question 13 holds**: every vertex `v` of `F k` lies in an independent
set of size at least `⌊|V|/k⌋ = q`. -/
theorem alpha_condition (hk : 2 ≤ k) (v : V k) :
    ∃ s : Finset (V k), (F k).IsIndepSet (s : Set (V k)) ∧ v ∈ s ∧
      Fintype.card (V k) / k ≤ s.card := by
  rw [card_V_div k hk]
  have hq : q k = 2 * k ^ 2 + 1 := rfl
  rcases v with _ | i | _ | x
  · refine ⟨S1 k, isIndepSet_S1 k, ?_, by rw [card_S1]⟩
    simp [S1, u0]
  · refine ⟨S3 k, isIndepSet_S3 k, ?_, ?_⟩
    · simp [S3, a]
    · rw [card_S3 k hk, k_mul_q k hk]
      have := three_le_km1q k hk
      generalize (k - 1) * q k = P at *
      omega
  · refine ⟨S2 k, isIndepSet_S2 k, ?_, ?_⟩
    · simp [S2, w0]
    · rw [card_S2 k hk]
      exact Nat.le_mul_of_pos_left _ (by omega)
  · refine ⟨S3 k, isIndepSet_S3 k, ?_, ?_⟩
    · simp [S3, b]
    · rw [card_S3 k hk, k_mul_q k hk]
      have := three_le_km1q k hk
      generalize (k - 1) * q k = P at *
      omega

/-! ### No equitable `L`-colouring -/

/-- The colour class of `col` under `f`. -/
def fiber (f : V k → ℕ) (col : ℕ) : Finset (V k) := univ.filter (fun v => f v = col)

/-- **Main lemma.** Every proper `L`-colouring of `F k` has a colour class of size `> q`. -/
theorem exists_big_fiber (hk : 2 ≤ k) (f : V k → ℕ) (hL : ∀ v, f v ∈ L k v)
    (hproper : ∀ v w, (F k).Adj v w → f v ≠ f w) :
    ∃ col, q k < (fiber k f col).card := by
  have hc : f (u0 k) < k := by simpa [L, u0] using hL (u0 k)
  have hd : k ≤ f (w0 k) ∧ f (w0 k) < 2 * k := by simpa [L, w0] using hL (w0 k)
  let cF : Fin k := ⟨f (u0 k), hc⟩
  let dF : Fin k := ⟨f (w0 k) - k, by omega⟩
  -- the pigeons: all leaves of `u₀` and the two leaves `b (c, d, 0)`, `b (c, d, 1)`
  let S : Finset (V k) := univ.image (a k) ∪ {b k (cF, dF, 0), b k (cF, dF, 1)}
  -- the holes: the `k - 1` colours `[k] \ {c}`
  have hmaps : ∀ v ∈ S, f v ∈ (range k).erase (f (u0 k)) := by
    intro v hv
    rw [mem_erase, mem_range]
    simp only [S, mem_union, mem_image, mem_univ, true_and, mem_insert, mem_singleton] at hv
    rcases hv with ⟨i, rfl⟩ | rfl | rfl
    · have h1 : f (a k i) < k := by simpa [L, a] using hL (a k i)
      exact ⟨(hproper _ _ (adj_u0_a k i)).symm, h1⟩
    · have h1 := hL (b k (cF, dF, 0))
      have h2 := hproper _ _ (adj_w0_b k (cF, dF, 0))
      have hcF : cF.val = f (u0 k) := rfl
      have hdF : dF.val = f (w0 k) - k := rfl
      rw [L_b] at h1
      simp only [mem_insert, mem_erase, mem_range] at h1
      rcases h1 with h1 | h1
      · exact absurd (by omega) h2
      · exact h1
    · have h1 := hL (b k (cF, dF, 1))
      have h2 := hproper _ _ (adj_w0_b k (cF, dF, 1))
      have hcF : cF.val = f (u0 k) := rfl
      have hdF : dF.val = f (w0 k) - k := rfl
      rw [L_b] at h1
      simp only [mem_insert, mem_erase, mem_range] at h1
      rcases h1 with h1 | h1
      · exact absurd (by omega) h2
      · exact h1
  have hS : S.card = (k - 1) * q k + 1 := by
    have hdisj : Disjoint (univ.image (a k)) ({b k (cF, dF, 0), b k (cF, dF, 1)} : Finset (V k)) := by
      rw [disjoint_left]
      simp [a, b]
    rw [card_union_of_disjoint hdisj, card_image_of_injective _ (a_injective k), card_univ,
      Fintype.card_fin, card_pair (by simp [b])]
    try simp only [m]
    have := one_le_km1q k hk
    omega
  have hholes : ((range k).erase (f (u0 k))).card * q k < S.card := by
    rw [card_erase_of_mem (mem_range.mpr hc), card_range, hS]
    omega
  obtain ⟨y, -, hy⟩ := exists_lt_card_fiber_of_mul_lt_card_of_maps_to hmaps hholes
  refine ⟨y, lt_of_lt_of_le hy (card_le_card ?_)⟩
  intro v hv
  simp only [mem_filter] at hv
  simp only [fiber, mem_filter, mem_univ, true_and]
  exact hv.2

/-! ### Strongly equitable colourings (Kierstead–Kostochka–Xiang) -/

/-- `⌈n / k⌉`. -/
def cap (n k : ℕ) : ℕ := (n + k - 1) / k

/-- `n mod* k`: the unique `r ∈ {1, …, k}` with `n ≡ r (mod k)`. -/
def modStar (n k : ℕ) : ℕ := if n % k = 0 then k else n % k

/-- An SE colouring of a graph on `n` vertices with `k`-lists: no colour class has more than
`⌈n/k⌉` vertices, and at most `n mod* k` classes are full (have exactly `⌈n/k⌉` vertices). -/
def IsSE {W : Type*} [Fintype W] [DecidableEq W] (k : ℕ) (f : W → ℕ) : Prop :=
  (∀ col, (univ.filter (fun v => f v = col)).card ≤ cap (Fintype.card W) k) ∧
    ((univ.image f).filter
      (fun col => (univ.filter (fun v => f v = col)).card = cap (Fintype.card W) k)).card ≤
      modStar (Fintype.card W) k

lemma cap_V (hk : 2 ≤ k) : cap (Fintype.card (V k)) k = q k := by
  rw [cap, card_V k hk, show k * q k + k - 1 = k * q k + (k - 1) by omega,
    Nat.mul_add_div (by omega), Nat.div_eq_of_lt (by omega), add_zero]

/-- **`F k` is not equitably `k`-choosable** (Kostochka–Pelsmajer–West): there is no proper
`L`-colouring in which every colour class has at most `⌈|V|/k⌉` vertices. -/
theorem no_equitable_L_coloring (hk : 2 ≤ k) :
    ¬ ∃ f : V k → ℕ, (∀ v, f v ∈ L k v) ∧ (∀ v w, (F k).Adj v w → f v ≠ f w) ∧
      ∀ col, (univ.filter (fun v => f v = col)).card ≤ cap (Fintype.card (V k)) k := by
  rintro ⟨f, hL, hproper, hcap⟩
  obtain ⟨col, hcol⟩ := exists_big_fiber k hk f hL hproper
  have := hcap col
  rw [cap_V k hk] at this
  exact absurd hcol (not_lt.mpr this)

/-- **`F k` is not SE `L`-colourable**, hence not SE `k`-choosable. -/
theorem not_SE_L_colorable (hk : 2 ≤ k) :
    ¬ ∃ f : V k → ℕ, (∀ v, f v ∈ L k v) ∧ (∀ v w, (F k).Adj v w → f v ≠ f w) ∧ IsSE k f := by
  rintro ⟨f, hL, hproper, hSE⟩
  exact no_equitable_L_coloring k hk ⟨f, hL, hproper, hSE.1⟩

/-- **Question 13 is false.** For every `k ≥ 2` there is a forest (`F k`, on `kq = 2k³ + k`
vertices) in which every vertex lies in an independent set of size `≥ ⌊n/k⌋`, together with a
`k`-list assignment `L` admitting no SE `L`-colouring. -/
theorem question13_false (hk : 2 ≤ k) :
    (∀ v : V k, ∃ s : Finset (V k), (F k).IsIndepSet (s : Set (V k)) ∧ v ∈ s ∧
        Fintype.card (V k) / k ≤ s.card) ∧
    (∀ v, (L k v).card = k) ∧
    ¬ ∃ f : V k → ℕ, (∀ v, f v ∈ L k v) ∧ (∀ v w, (F k).Adj v w → f v ≠ f w) ∧ IsSE k f :=
  ⟨alpha_condition k hk, card_L k, not_SE_L_colorable k hk⟩

end Q13
