/*
  Compile and run by running this command
  gcc AOC_2022_03-1.c -o AOC_2022_03-1 && ./AOC_2022_03-1
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char getCommonCharacter(char *s1, char *s2, int length)
{
  for (int i = 0; i < length; i++)
  {
    for (int j = 0; j < length; j++)
    {

      if (s1[i] == s2[j])
      {
        return s1[i];
      }
    }
  }

  return 0;
}

int calculatePriority(char c)
{
  if (c == 0)
  {
    return 0;
  }
  if (c > 96)
  {
    return c - 96;
  }
  return c - 64 + 26;
}

char getPriority(char *line)
{
  int length = strlen(line) - 1;
  int lengthHalf = length / 2;
  char s1[lengthHalf + 1];
  char s2[lengthHalf + 1];
  memcpy(s1, line, lengthHalf);
  memcpy(s2, line + lengthHalf, lengthHalf);

  char commonCharacter = getCommonCharacter(s1, s2, lengthHalf);
  int priority = calculatePriority(commonCharacter);
  return priority;
}

int main(void)
{
  int sum = 0;

  char const *const fileName = "input.txt";
  FILE *file = fopen(fileName, "r");

  char line[255];
  while (fgets(line, sizeof(line), file))
  {
    char commonCharacter = getPriority(line);
    sum += commonCharacter;
  }

  fclose(file);
  printf("%d\n", sum);
  return 0;
}