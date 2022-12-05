#! /usr/bin/awk -f 

# To run this script 
# awk -f AOC_2022_01-1.awk.awk input.txt

BEGIN {
    max_calories = 0;
    current_calories = 0;
}
{
    if ($1 ~ "^[0-9]+$"){
        current_calories += $1;
        next;
    }

    if (current_calories > max_calories){
        max_calories = current_calories;
    }
    current_calories = 0;
}
END {
    print(max_calories)
}
