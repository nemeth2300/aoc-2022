#! /bin/bash

# To run this script
# bash AOC_2022_02-1.bash

# Man I *****:) hate bash
# rock -1
# paper 0
# scissors 1
# Game results in a [-1 1] transformed overflow interval are interpreted as such:
# win 1
# draw 0
# lose -1

file_name="input.txt"

total_score=0

IFS=' '
while IFS= read -r line; do
    read -ra arr <<<$line

    opponent_code=${arr[0]}
    opponent_ascii=$(printf "%d" "'$opponent_code")
    opponent_shift=66
    opponent=$(($opponent_ascii - $opponent_shift))

    self_code=${arr[1]}
    self_ascii=$(printf "%d" "'$self_code")
    self_shift=89
    self=$(($self_ascii - $self_shift))

    game_result=$(($self - $opponent))

    the_bruh_score=$(($self + 2))
    the_game_score=0
    if [[ $game_result -eq 0 ]]; then
        the_game_score=3
    elif [[ $game_result -eq 1 ]] || [[ $game_result -eq -2 ]]; then # -2 -> 1 as the under/overflow logic is
        the_game_score=6
    fi

    score=$(($the_game_score + $the_bruh_score))

    total_score=$(($total_score + $score))
done <$file_name

echo $total_score
