#!/usr/bin/env python3
"""Exhaustive search for counterexamples to KKX Question 13 on small forests.

For each non-isomorphic forest T on n vertices satisfying alpha_v(T) >= floor(n/k)
for every v, run ./selc (C brute force) over all k-list assignments from a palette
of size p (vertex 0's list fixed WLOG) and report any assignment with no SE L-coloring.

usage: search.py n k p [--first]     (--first: stop at the first failing assignment per forest)
"""
import sys, subprocess, itertools, networkx as nx

def forests(n):
    """All non-isomorphic forests on n vertices via geng (bipartite, <= n-1 edges, acyclic)."""
    out = subprocess.run(["geng","-q","-b",str(n),f"0:{n-1}"],capture_output=True,text=True).stdout
    for line in out.split():
        G = nx.from_graph6_bytes(line.encode())
        if nx.number_of_edges(G) + nx.number_connected_components(G) == n:
            yield G

def alpha_v_all(G):
    """alpha_v for every v, by brute force over subsets (n <= 12)."""
    nodes = list(G.nodes()); n=len(nodes); idx={v:i for i,v in enumerate(nodes)}
    nb = [0]*n
    for u,v in G.edges(): nb[idx[u]] |= 1<<idx[v]; nb[idx[v]] |= 1<<idx[u]
    best=[0]*n
    for S in range(1<<n):
        ok=True; s=S
        while s:
            i=(s&-s).bit_length()-1
            if nb[i]&S: ok=False;break
            s&=s-1
        if ok:
            c=bin(S).count("1"); s=S
            while s:
                i=(s&-s).bit_length()-1
                if c>best[i]: best[i]=c
                s&=s-1
    return best

def main():
    n=int(sys.argv[1]); k=int(sys.argv[2]); p=int(sys.argv[3])
    first = "--first" in sys.argv
    q = n//k
    tot=0; cond=0; bad=0
    for G in forests(n):
        tot+=1
        av = alpha_v_all(G)
        if min(av) < q: continue
        cond+=1
        nodes=list(G.nodes()); idx={v:i for i,v in enumerate(nodes)}
        edges=[(idx[u],idx[v]) for u,v in G.edges()]
        # put a max-degree vertex at index 0 (more symmetry breaking is irrelevant; any vertex works)
        args=["./selc",str(n),str(k),str(p),str(len(edges))]+[str(x) for e in edges for x in e]+(["--first"] if first else [])
        res=subprocess.run(args,capture_output=True,text=True).stdout.strip().split("\n")
        summary=res[-1]
        fails=[l for l in res if l.startswith("FAIL")]
        degs=sorted((d for _,d in G.degree()),reverse=True)
        tag = "COUNTEREXAMPLE" if fails else "ok"
        print(f"n={n} k={k} p={p} forest#{tot} edges={edges} degs={degs} alpha_v={av} {summary} {tag}", flush=True)
        for l in fails[:5]: print("   ",l, flush=True)
        if fails: bad+=1
    print(f"SUMMARY n={n} k={k} p={p}: forests={tot} condition_holds={cond} counterexample_forests={bad}", flush=True)

if __name__ == "__main__":
    main()
