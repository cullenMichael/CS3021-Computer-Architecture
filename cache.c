#include <stdio.h>
#include<math.h>
#include <stdbool.h>
#include<string.h>
#include<limits.h>

int add[32] =
  {0x0000, 0x0004,0x000c, 0x2200, 0x00d0, 0x00e0, 0x1130, 0x0028,
0x113c, 0x2204, 0x0010 , 0x0020 , 0x0004 , 0x0040 , 0x2208 , 0x0008 ,
0x00a0 , 0x0004 , 0x1104 , 0x0028 , 0x000c , 0x0084 , 0x000c , 0x3390 ,
0x00b0 , 0x1100 , 0x0028 , 0x0064 , 0x0070 , 0x00d0 , 0x0008 , 0x3394};

int sizes[4][3] = {
  {16,8,1},
  {16,4,2},
  {16,2,4},
  {16,1,8}
};
int hits = 0;
int misses = 0;
int l = 0;
int k = 0;
int n = 0;

struct cache{
  int L;
  int K;
  int N;
};

struct parse{
  int tag;
  int set;
  int offset;
  int add;
};

int find(int tags[k][n], int data[n][l * k], struct parse parse, struct cache cache, int lru[k][n]){

  int tag = parse.tag;
  int set = parse.set;
  int tagind = 0;
  bool notHere = false;
  for(; tagind < cache.K;tagind++){
    if((tags[tagind][set] == tag)&&(lru[tagind][set] != 0)){
      notHere = true;
      lru[tagind][set] = 1;
      break;
    }
  }
  if (notHere == true){
    hits++;
    int shift = (k-1)* log2(l);
    int off = parse.offset/4;
    int ret = data[set][shift + off];
    for(int l = 0; l < cache.K;l++){
      if(tagind == l){
        lru[tagind][set] = 1;
      }else{
        if(lru[l][set] != 0){
          lru[l][set]++;
        }
      }
    }
    return ret;
  }
  else{
    misses++;
    bool full = true;
    int max = 0;
    int maxind = 0;
    int minind = -1;
    for(int j = 0 ; j < k;j++){
      if(lru[j][set] == 0){
        full = false;
        minind = j;
      }else{
        if(max < lru[j][set]){
          max = lru[j][set];
          maxind = j;
        }
        lru[j][set]++;
      }
    }
    int index;
    if(full == false){
      index = minind;
    }else{
      index = maxind;
    }
    tags[index][set] = parse.tag;
    int shift = (k-1)* log2(l);
    int add = parse.add;

    for(int i = 0; i < log2(l); i++){
        data[set][shift] = add;
        shift++;
        add += 0x04;
    }
    lru[index][set] = 1;
    shift = (k-1)* log2(l);
    int off = parse.offset/4;
    return data[set][shift + off];
  }
}

int main(int argc , char * argv[]){
  struct cache cache;
  struct parse parse;

// uncomment for user input
  // cache.L = argv[1];
  // l = cache.L;
  // cache.N = argv[3];
  // n = cache.N;
  // cache.K = argv[2];
  // k = cache.K;

  for(int y = 0; y < 4; y++){ //
    cache.L = sizes[y][0];    //
    l = cache.L;              //
    cache.N = sizes[y][1];    //  COMMENT TO ALLOW USER INPUT
    n = cache.N;              //  REMOVE BRACKET BELOW TO REMOVE LOOP BRACKET
    cache.K = sizes[y][2];    //
    k = cache.K;              //

    int tags [cache.K][cache.N];
    memset( tags, 0, k*n*sizeof(int) );
    int data [cache.N][cache.L * cache.K];
    memset( data, 0, k*n*l*sizeof(int) );
    int lru [cache.K][cache.N];
    memset( lru, 0, k*n*sizeof(int) );
    int setSize;

    for(int q = 0; q < 32; q++){
      unsigned int test = add[q];
      parse.add = test;
      unsigned int mask;
      if(cache.L != 0){
        mask = cache.L -1;
      }else{
        mask  = 0;
      }
      unsigned int offset = test & mask;
      parse.offset = offset;
      test = test >>log2(cache.L);
      if(cache.N != 0){
        setSize = cache.N -1;
      }else{
        setSize  = 0;
      }
      unsigned int set = test & setSize;
      parse.set = set;
      int off = log2(cache.N);
      unsigned int tag = test >> off;
      parse.tag = tag;
      int x = find(tags, data, parse, cache, lru);
    }  /////////// COMMENT OUT FOR USER INPUT
    printf("L: %d\nK: %d\nN: %d\nHits: %d\nMisses: %d\n\n",sizes[y][0], sizes[y][1], sizes[y][2], hits, misses);
    hits = 0;
    misses = 0;
    }
    return 0;
}
