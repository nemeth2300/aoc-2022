#! /usr/bin/awk -f 

# To run this script 
# awk -f AOC_2022_01-2.awk input.txt

BEGIN {
    toplist_length = 3;
    toplist[toplist_length]
    for (i = 0; i<  toplist_length; i++){
        toplist[i] =0;
    }
    
    current_element = 0;
}
{
    # is not number
    if ($1 ~ "^[0-9]+$"){
        current_element += $1;
        next;
    }

    if (current_element > toplist[toplist_length-1]){
        for (i = 0; i < toplist_length; i++){
            element = toplist[i];

            if (current_element > element){
                for (j = i+1; j < toplist_length; j++){
                    toplist[j] = toplist[j-1]
                }
                toplist[i] = current_element
                    for (i = 0; i< toplist_length; i++){
                        element = toplist[i];
                        print(element)
                    }
                continue;
            }
        }   
        print("\n")
    }
    current_element = 0;
}
END {
    sum = 0;
    for (i = 0; i< toplist_length; i++){
        element = toplist[i];
        # print(element)
        sum += element;
    }

    print(sum)
}
