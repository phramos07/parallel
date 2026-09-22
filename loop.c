#include <stdio.h>

#define N 64

int main(void) {
    int v[N];

    for (int i = 0; i < N; i++)
        v[i] = 0;

    /* Simple counted loop — a good candidate for auto-vectorization. */
    for (int i = 1; i <= N; i++)
        v[i - 1] += i;

    /* Loop with an early exit — harder / impossible to vectorize. */
    int found = -1;
    for (int i = 0; i < N; i++) {
        if (v[i] > 0) {
            found = i;
            break;
        }
    }

    printf("v[0]=%d v[63]=%d found=%d\n", v[0], v[63], found);
    return 0;
}
