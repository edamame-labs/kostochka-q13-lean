#!/usr/bin/env python3
"""CEGIS search for a k-list assignment L (palette [p]) on a given forest G such that G has
NO SE L-colouring.  Existential side (SAT, pysat): variables x[v,a] = [a in L(v)], exactly k per v,
vertex 0's list fixed to {0..k-1}; blocking clauses for every SE colouring found so far.
Universal side: exact SE L-colourability check (backtracking).  If the SAT side becomes UNSAT,
no list assignment from palette [p] defeats G.

usage: cegis.py n k p     (forests from geng via search.py; prints one line per forest)
"""
import sys, itertools, subprocess, networkx as nx
from pysat.solvers import Cadical153
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool

def se_color(n, k, adj, L, cap, r):
    """Backtracking SE L-colouring; returns colouring list or None."""
    order = sorted(range(n), key=lambda v: -len(adj[v]))
    col = [-1]*n; cnt = {}; full = [0]
    def rec(i):
        if i == n: return True
        v = order[i]
        for a in L[v]:
            if any(col[w] == a for w in adj[v]): continue
            c = cnt.get(a, 0)
            if c >= cap or (c == cap-1 and full[0] >= r): continue
            cnt[a] = c+1; col[v] = a
            if c+1 == cap: full[0] += 1
            if rec(i+1): return True
            if c+1 == cap: full[0] -= 1
            cnt[a] = c; col[v] = -1
        return False
    return col if rec(0) else None

def cegis(n, k, p, edges, max_iter=200000, verbose=False):
    adj = [[] for _ in range(n)]
    for u, v in edges: adj[u].append(v); adj[v].append(u)
    cap = -(-n//k); r = n % k or k
    pool = IDPool()
    x = {(v, a): pool.id(('x', v, a)) for v in range(n) for a in range(p)}
    S = Cadical153()
    for v in range(n):
        cnf = CardEnc.equals(lits=[x[v, a] for a in range(p)], bound=k, vpool=pool, encoding=EncType.seqcounter)
        for cl in cnf.clauses: S.add_clause(cl)
    for a in range(p): S.add_clause([x[0, a]] if a < k else [-x[0, a]])
    perms = []
    for p1 in itertools.permutations(range(k)):
        for p2 in itertools.permutations(range(k, p)):
            perms.append(list(p1) + list(p2))
    it = 0
    while S.solve():
        it += 1
        model = set(l for l in S.get_model() if l > 0)
        L = [[a for a in range(p) if x[v, a] in model] for v in range(n)]
        col = se_color(n, k, adj, L, cap, r)
        if col is None:
            return L, it
        # block: every L' must exclude at least one (v, col[v]); also block colour-permuted variants
        # (cheap symmetry boost: the same colouring is blocked under all permutations fixing [k])
        # collect colourings: found one + single-vertex recolourings; block each under all colour
        # permutations fixing {0..k-1} setwise (vertex 0's list is fixed, so these are symmetries).
        cols = [list(col)]
        for v in range(n):
            for a in L[v]:
                if a == col[v] or any(col[w] == a for w in adj[v]): continue
                c2 = list(col); c2[v] = a
                cnt = {}
                for b in c2: cnt[b] = cnt.get(b, 0) + 1
                if max(cnt.values()) <= cap and sum(1 for b in cnt.values() if b == cap) <= r:
                    cols.append(c2)
        seen = set()
        for c2 in cols:
            for perm in perms:
                key = tuple(perm[b] for b in c2)
                if key in seen: continue
                seen.add(key)
                S.add_clause([-x[v, key[v]] for v in range(n)])
        if it >= max_iter: return None, it
    return None, it

if __name__ == "__main__":
    n, k, p = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
    sys.path.insert(0, 'scripts'); sys.path.insert(0, '.')
    from search import forests, alpha_v_all
    q = n // k
    tot = 0
    for G in forests(n):
        tot += 1
        av = alpha_v_all(G)
        if min(av) < q: continue
        nodes = list(G.nodes()); idx = {v: i for i, v in enumerate(nodes)}
        # put a max-degree vertex at index 0
        order = sorted(nodes, key=lambda v: -G.degree(v)); idx = {v: i for i, v in enumerate(order)}
        edges = [(idx[u], idx[v]) for u, v in G.edges()]
        L, it = cegis(n, k, p, edges)
        degs = sorted((d for _, d in G.degree()), reverse=True)
        print(f"n={n} k={k} p={p} forest#{tot} degs={degs} iters={it} {'COUNTEREXAMPLE '+str(L) if L else 'none'}", flush=True)
