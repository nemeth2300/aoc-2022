/*
  Compile and run by running this command
  gcc AOC_2022_03_2.c -o AOC_2022_03_2 && ./AOC_2022_03_2
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char getCommonCharacter(char *s1, char *s2, char *s3)
{
    int l1 = strlen(s1);
    int l2 = strlen(s2);
    int l3 = strlen(s3);
    printf("%d %s\n", l1, s1);
    printf("%d %s\n", l2, s2);
    printf("%d %s\n\n\n", l3, s3);
    for (int i = 0; i < l1; i++)
    {
        for (int j = 0; j < l2; j++)
        {
            for (int k = 0; k < l3; k++)
            {
                if (s1[i] == s2[j] && s2[j] == s3[k])
                {
                    return s1[i];
                }
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

int main(void)
{
    int sum = 0;

    char const *const fileName = "input.txt";
    FILE *file = fopen(fileName, "r");

    char line[255];
    while (fgets(line, sizeof(line), file))
    {
        char secondLine[255];
        fgets(secondLine, sizeof(line), file);
        char thirdLine[255];
        fgets(thirdLine, sizeof(line), file);

        char commonCharacter = getCommonCharacter(line, secondLine, thirdLine);
        int priority = calculatePriority(commonCharacter);
        // printf("%c %d\n", commonCharacter, priority);
        sum += priority;
    }

    fclose(file);
    printf("%d\n", sum);
    return 0;
}