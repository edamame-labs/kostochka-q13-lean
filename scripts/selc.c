/* selc.c — brute-force test of SE k-choosability of a forest.
 * Usage: selc n k p e u1 v1 u2 v2 ... [--first]
 *   Vertices 0..n-1, e edges.  Every vertex gets a k-subset of palette [p]
 *   as its list; vertex 0's list is fixed to {0..k-1} (WLOG by color relabeling).
 *   For every list assignment we search for an SE L-coloring:
 *     no class larger than cap = ceil(n/k), at most r = n mod* k classes of size cap.
 *   Prints every failing list assignment (or only the first with --first),
 *   then a summary line "assignments=<count> failures=<count>".
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXN 16
#define MAXP 12
static int n,k,p,cap,r;
static int adj[MAXN][MAXN], deg[MAXN];
static int order[MAXN];          /* elimination order: each vertex has <=1 earlier neighbour */
static int parent[MAXN];         /* earlier neighbour in 'order', or -1 */
static int subsets[1000][MAXP];  /* all k-subsets of [p] */
static int nsub;
static int lst[MAXN];            /* index of subset chosen for each vertex */
static int col[MAXN], cnt[MAXP], full;
static long long nassign=0, nfail=0;
static int firstonly=0;

static int colorable(int i){
    if(i==n) return 1;
    int v=order[i];
    int pc = parent[v]>=0 ? col[parent[v]] : -1;
    int *L = subsets[lst[v]];
    for(int j=0;j<k;j++){
        int c=L[j];
        if(c==pc) continue;
        if(cnt[c]>=cap) continue;
        if(cnt[c]==cap-1 && full>=r) continue;
        cnt[c]++; if(cnt[c]==cap) full++;
        col[v]=c;
        if(colorable(i+1)){ cnt[c]--; if(cnt[c]==cap-1) full--; return 1; }
        if(cnt[c]==cap) full--; cnt[c]--;
    }
    return 0;
}

static void enumerate(int i){
    if(i==n){
        nassign++;
        memset(cnt,0,sizeof cnt); full=0;
        if(!colorable(0)){
            nfail++;
            printf("FAIL lists:");
            for(int v=0;v<n;v++){ printf(" %d:{",v); for(int j=0;j<k;j++) printf("%d%s",subsets[lst[v]][j], j<k-1?",":""); printf("}"); }
            printf("\n");
            if(firstonly){ printf("assignments=%lld failures=%lld\n",nassign,nfail); exit(0);}
        }
        return;
    }
    for(int s=0;s<nsub;s++){ lst[i]=s; enumerate(i+1); }
}

int main(int argc,char**argv){
    if(argc<5){fprintf(stderr,"usage\n");return 1;}
    n=atoi(argv[1]); k=atoi(argv[2]); p=atoi(argv[3]); int e=atoi(argv[4]);
    int a=5;
    for(int i=0;i<e;i++){ int u=atoi(argv[a++]), v=atoi(argv[a++]); adj[u][deg[u]++]=v; adj[v][deg[v]++]=u; }
    if(a<argc && !strcmp(argv[a],"--first")) firstonly=1;
    cap=(n+k-1)/k; r=n%k; if(r==0) r=k;
    /* BFS order per component so that each vertex has at most one earlier neighbour */
    int seen[MAXN]={0}, m=0;
    for(int s=0;s<n;s++) if(!seen[s]){ seen[s]=1; parent[s]=-1; order[m++]=s; int h=m-1;
        while(h<m){ int v=order[h++]; for(int j=0;j<deg[v];j++){ int w=adj[v][j]; if(!seen[w]){seen[w]=1;parent[w]=v;order[m++]=w;} } } }
    /* all k-subsets of [p], subset 0 = {0..k-1} */
    nsub=0; int c[MAXP];
    for(int j=0;j<k;j++) c[j]=j;
    while(1){ for(int j=0;j<k;j++) subsets[nsub][j]=c[j]; nsub++;
        int j=k-1; while(j>=0 && c[j]==p-k+j) j--; if(j<0) break; c[j]++; for(int t=j+1;t<k;t++) c[t]=c[t-1]+1; }
    lst[0]=0; enumerate(1);
    printf("assignments=%lld failures=%lld\n",nassign,nfail);
    return 0;
}
