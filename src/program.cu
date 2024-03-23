#include "stdio.h"

__global__
void saxpy(
    int n,
    float a,
    float *x, // pointer
    float *y // pointer
) {

    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n) {

        y[i] = a * x[i] + y[i];
    }

    // return;
}

int main(void) {

    int N = 1 << 20;

    float *x, *y, *d_x, *d_y;

    x = (float *)malloc(N * sizeof(float));
    y = (float *)malloc(N * sizeof(float));

    cudaMalloc(&d_x, N * sizeof(float)); // cudaMalloc - is from CUDA Runtime API
    cudaMalloc(&d_y, N * sizeof(float));

    for (int i = 0; i < N; i++) {

        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);

    saxpy<<<(N + 255) / 256, 256>>>(N, 2.0f, d_x, d_y); // <<<number_of_thread_blocks, number_of_treads_per_block>>> - execution configuration

    cudaMemcpy(y, d_y, N * sizeof(float), cudaMemcpyDeviceToHost);

    float maxError = 0.0f;
    for (int i = 0; i < N; i++) {

        maxError = max(maxError, abs(y[i] - 4.0f));
    }

    printf("Max error: %f\n", maxError);

    cudaFree(d_x);
    cudaFree(d_y);
    free(x);
    free(y);
}
