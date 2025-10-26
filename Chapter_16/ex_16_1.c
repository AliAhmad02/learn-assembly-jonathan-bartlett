#include <stdio.h>

int array_sum(int array[], int length) {
  int sum = 0;
  for (int i=0; i < length; i++) {
    sum += array[i];
  }
  return sum;
}

int main() { 
  int array[] = {1, 2, 3, 4, 5, 6};
  int length = sizeof(array) / sizeof(int);
  int res = array_sum(array, length);
  fprintf(stdout, "%d\n", res);
  return 0;
}

