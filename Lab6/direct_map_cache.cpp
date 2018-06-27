#include<cstdio>
#include<iostream>
#include<math.h>
using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
//	unsigned int	data[16];
};

const int K = 1024;


void simulate(int cache_size, int block_size){
    int success[100000];
    int fail[100000];
	unsigned int tag, index, x;

	int offset_bit = (int) log2(block_size);
	int index_bit  = (int) log2(cache_size/block_size);
	int line = cache_size >> (offset_bit);               //entry #

	cache_content *cache = new cache_content[line];
	cout << "cache line:" << line << endl;

	for(int j = 0; j < line; j++)
		cache[j].v = false;

  FILE *fp = fopen("trace.txt","r");					//read file

    int itr = 1;
    int hit = 0;
    int miss = 0;

	while(fscanf(fp,"%x",&x) != EOF){
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		if(cache[index].v && cache[index].tag == tag){
			cache[index].v = true; 			//hit
            success[hit++] = itr;
		}
		else{
			cache[index].v = true;			//miss
			cache[index].tag = tag;
			fail[miss++] = itr;
		}
		itr++;
	}
	fclose(fp);

	double miss_rate;
    cout << "itr : " << itr << endl;
    cout << "hit : " << hit << endl;
    cout << "miss: " << miss << endl;
	//miss_rate = miss/itr
	cout << "miss rate: " << (double)miss / (double)itr << endl;

	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
	simulate(4*K, 32);
}
