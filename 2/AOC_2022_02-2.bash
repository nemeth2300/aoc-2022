#! /bin/bash

# To run this script
# bash AOC_2022_02-2.bash

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

    # do reverse transform overflow
    self_decision=$(($opponent + $self))
    if [[ $self_decision -eq 2 ]]; then
        self_decision=-1
    elif [[ $self_decision -eq -2 ]]; then
        self_decision=1
    fi

    game_result=$(($self_decision - $opponent))
    if [[ $game_result -eq -2 ]]; then
        game_result=1
    elif [[ $game_result -eq 2 ]]; then
        game_result=-1
    fi

    the_bruh_score=$(($self_decision + 2))
    the_game_score=0
    if [[ $game_result -eq 0 ]]; then
        the_game_score=3
    elif [[ $game_result -eq 1 ]]; then
        the_game_score=6
    fi

    score=$(($the_game_score + $the_bruh_score))

    total_score=$(($total_score + $score))
done <$file_name

echo $total_score
