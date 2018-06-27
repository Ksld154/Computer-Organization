//Subject:     CO project 6 - Cache
//--------------------------------------------------------------------------------
//Writer:      0516215 林亮穎
//----------------------------------------------
#include<cstdio>
#include<cstdlib>
#include<iostream>
#include<math.h>
#include<queue>
using namespace std;

struct cache_content{
	bool v;
	unsigned int tag;
    unsigned int last_access; 
//  unsigned int data[16];
};

const int K = 1024;

void simulate(int n, int cache_size, int block_size){   // n: n-way associative
    int success[100000];
    int fail[100000];
	unsigned int tag, index, x;

	int offset_bit = (int) log2(block_size);
	int index_bit  = (int) log2(cache_size/block_size/n);
    //cout << "index bits: " << index_bit << endl;
    //cout << "offset bits: " << offset_bit << endl; 
	//int line = cache_size >> (offset_bit);               //entry #
    int line =  cache_size / block_size / n;

    cache_content **cache;
    cache = new cache_content*[line];
    for(int i = 0; i < line; i++)
        cache[i] = new cache_content[n]; 
    
    for(int i = 0; i < line; i++){
        for(int j = 0; j < n; j++){
            cache[i][j].v = false;
            cache[i][j].last_access = 0;
        }
    }
	//cache_content *cache = new cache_content[line][n];
	//cout << "cache line:" << line << endl;

/*
    for(int i = 0; i < line; i++)
    	for(int j = 0; j < n; j++)
	    	cache[i][j].v = false;
*/
  FILE *fp = fopen("trace.txt","r");					//read file

    int itr = 1;
    int hit_cnt = 0;
    int miss_cnt = 0;
    //int miss2 = 0;
	while(fscanf(fp, "%x", &x) != EOF){
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);          
		tag = x >> (index_bit + offset_bit);
        bool hit = 0;
        bool miss1 = 0;
        
        for(int i = 0; i < n; i++){                          //hit
            if(cache[index][i].v && cache[index][i].tag == tag){
                cache[index][i].v = true; 			
                cache[index][i].last_access = itr;
                success[hit_cnt++] = itr;
                hit = 1;
                //cout << itr << " ";
                break;
            }
        }
        for(int i = 0; i < n; i++){                
            if(cache[index][i].v == false && !hit){          //miss, but there's still empty space in the set  
                cache[index][i].v = true;
                cache[index][i].tag = tag; 			
                cache[index][i].last_access = itr;
                fail[miss_cnt++] = itr;
                miss1 = 1;
                break;
            }
        }
        if(!hit && !miss1){                               //miss, set is full => LRU replacement!
            int oldest_block = 0;
            int oldest_last_access = 99999999;
            //find least-recently-accessd block
            for(int i = 0; i < n; i++){
                if(cache[index][i].last_access < oldest_last_access && cache[index][i].v == true){
                    oldest_last_access = cache[index][i].last_access;
                    oldest_block = i;
                }
            }
            /*do LRU replacement */
            cache[index][oldest_block].v = true;
            cache[index][oldest_block].tag = tag;
            cache[index][oldest_block].last_access = itr;
            fail[miss_cnt++] = itr;
        }
		itr++;
	}
	fclose(fp);

    cout << "Hits instructions:" << endl;
    for(int i = 0; i < hit_cnt; i++){
        cout << success[i] << ", ";
    }
    cout << endl;

    cout << "Misses instructions: " << endl;
    for(int i = 0; i < miss_cnt; i++){
        cout << fail[i] << ", ";
    }
    cout << endl;

    cout << "Miss rate: " <<(double)miss_cnt/(double)(itr-1) << endl;
	delete [] cache;
}

int main(){
	// Let us simulate 4KB n-way associative cache with 32B blocks
	
    //Part A: Direct mapped cache with different cache size and block size
    for(int i = 0; i <= 8; i++){
        int n = pow(2, i);
        cout << n << "KB cache" << endl;
        simulate(1, n*K, 16);
        simulate(1, n*K, 32);
        simulate(1, n*K, 64);
        simulate(1, n*K, 128);
        simulate(1, n*K, 256);
    }
    

    //Part B: Caches with different associativity and cache size
    //fixed block size: 32Byte
    for(int i = 0; i <= 8; i++){
        int n = pow(2, i);
        cout << n << "KB cache" << endl;
        simulate(1, n*K, 32);        // 1-way (Direct-mapped)
        simulate(2, n*K, 32);        // 2-way
        simulate(4, n*K, 32);
        simulate(8, n*K, 32);
        simulate(n*K/32, n*K, 32);   //fully associative
    }
    
   //simulate(1, 1*K, 32);
}
