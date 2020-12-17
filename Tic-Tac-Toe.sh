#!/bin/bash

flag=1
declare -a board
player=1
system=0
count=0

# ** Printing Board **

boardPrint() {
	printf "                                                      \n"
	printf "               ${board[1]} | ${board[2]} | ${board[3]} \n"
	printf "              ---------\n"
	printf "               ${board[4]} | ${board[5]} | ${board[6]} \n"
	printf "              ---------\n"
	printf "               ${board[7]} | ${board[8]} | ${board[9]} \n"
	printf "                                                      \n"
}

# ** Toss for first play **

firstToss() {
	toss=$((RANDOM%2))
	if [ $toss -eq $player ]
	then
		printf "\n"
		printf " * Player Won The Toss And Have Chance To Play First *\n"
	else
		printf "\n\n"
		printf " * System Won The Toss And Have Chance To Play First *\n"
	fi
}

# ** assiginig symbol for player and system **

symbolAssigning() {
	if [ $toss -eq $player ]
	then
		echo -ne "\n"
		read -p " Please Select Symbol (x / o) For Playing Game : " playerSymbol
		if [ "$playerSymbol" == "o" ]
		then
			systemSymbol="x"
		else
			systemSymbol="o"
		fi
	else
		systemSymbolToss=$((RANDOM%2))
		if [ $systemSymbolToss -eq 1 ]
		then
			systemSymbol="o"
			playerSymbol="x"
		else
			systemSymbol="x"
			playerSymbol="o"
		fi
	fi
}

# ** function for comming out of winnigCheck function **

winPlayerName() {
	printf "\n"
	printf "======================[[ *** $winner Is Winner *** ]]=================\n"
        boardPrint
        exit
}

# **checking winning condition **

winnigCheck() {
		symbol=$1
		winner=$2
		if [[ ${board[1]} == $symbol && ${board[2]} == $symbol && ${board[3]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[4]} == $symbol && ${board[5]} == $symbol && ${board[6]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[7]} == $symbol && ${board[8]} == $symbol && ${board[9]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[1]} == $symbol && ${board[4]} == $symbol && ${board[7]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[2]} == $symbol && ${board[5]} == $symbol && ${board[8]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[3]} == $symbol && ${board[6]} == $symbol && ${board[9]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[1]} == $symbol && ${board[5]} == $symbol && ${board[9]} == $symbol ]]
		then
			winPlayerName
		elif [[ ${board[3]} == $symbol && ${board[5]} == $symbol && ${board[7]} == $symbol ]]
		then
			winPlayerName
		fi
}

# ** checking tie condition **

matchTie() {
	for (( count=1;count<10;count++ ))
	do
		if [ -z "${board[count]}" ]
		then
			break
		else
			if (( $count == 9 ))
			then
				boardPrint
				printf "\n"
				printf "=================[[ *** Match Tie *** ]]===============\n"
				exit
			fi
		fi
	done
}

# ** player playing game **

playerPlay() {
	win="player"
	boardPrint
        read -p " * Player Chance : Enter Cell No : " playerPosition
	if [ -z "${board[$playerPosition]}" ]
	then
		if (( $playerPosition >= 1 && $playerPosition <= 9 ))
		then
              		board[$playerPosition]=$playerSymbol
			#symbol=$playerSymbol
                	#boardPrint
                	winnigCheck $playerSymbol $win
			matchTie
		else
			printf "\n"
			printf " ** Invalid Input : Place Already Taken ** \n"
	    		playerPlay
		fi
	else
		printf "\n"
		printf " ** Invalid Input : Place Already Taken ** \n"
		playerPlay
	fi
}

# ** system playing game with help of RANDOM fuction so if system will not have any cell to planed position **

systemRandomPlay() {
	printf "\n"
	printf "============= ** System Chance ** ==============\n"
	win2="System"
        systemPosition=$((RANDOM%9+1))
	if [ -z "${board[$systemPosition]}" ]
	then
        	board[$systemPosition]=$systemSymbol
        	boardPrint
        	winnigCheck $systemSymbol $win2
		matchTie
	else
		systemRandomPlay
	fi
}

# ** System playe like a human by checking opponent places **

systemPlay() {
	printf "\n"
	printf "============== ** System Played ** ==============\n"
	for (( cellNumber=1;cellNumber<10;cellNumber++ ))
	do
		if [ -z "${board[$cellNumber]}" ]
		then
			board[$cellNumber]="$systemSymbol"
			player="system"
			winnigCheck $systemSymbol $player
			matchTie
			board[$cellNumber]=""

		fi
	done
	opponentBlocking

}

# ** function for blacking opponent place where he can win the game **

opponentBlocking() {
	flag2=1
	for (( cellBlock=1;cellBlock<10;cellBlock++ ))
	do
		if [ -z "${board[$cellBlock]}" ]
		then
			board[$cellBlock]="$playerSymbol"
			winningCheckForOpp "$playerSymbol"
			board[$cellBlock]=""

		fi
	done
	if [ $flag2 -eq 1 ]
	then
		cornerApproach
	fi
}

# ** function for Corner Approach for System **

cornerApproach() {
	if [ -z "${board[1]}" ]
	then
		board[1]="$systemSymbol"
	elif [ -z "${board[3]}" ]
	then
		board[3]="$systemSymbol"
	elif [ -z "${board[7]}" ]
        then
                board[7]="$systemSymbol"
	elif [ -z "${board[9]}" ]
        then
                board[9]="$systemSymbol"
	else
		centreApproach
	fi

}

# ** function for Centre approach for system **

centreApproach() {
	if [ -z "${board[5]}" ]
	then
		board[5]="$systemSymbol"
	else
		systemRandomPlay
	fi

}

# ** function for comming out for winningCheckForOpp function **

exitingFromOppBlockingLoop() {
	board[$cellBlock]="$systemSymbol"
        flag2=2
        cellBlock=10
}

# ** fuction to analysing player winning cells for blocking **

winningCheckForOpp() {

        symbol2=$1
        if [[ ${board[1]} == $symbol2 && ${board[2]} == $symbol2 && ${board[3]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[4]} == $symbol2 && ${board[5]} == $symbol2 && ${board[6]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[7]} == $symbol2 && ${board[8]} == $symbol2 && ${board[9]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[1]} == $symbol2 && ${board[4]} == $symbol2 && ${board[7]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[2]} == $symbol2 && ${board[5]} == $symbol2 && ${board[8]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[3]} == $symbol2 && ${board[6]} == $symbol2 && ${board[9]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[1]} == $symbol2 && ${board[5]} == $symbol2 && ${board[9]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	elif [[ ${board[3]} == $symbol2 && ${board[5]} == $symbol2 && ${board[7]} == $symbol2 ]]
        then
		exitingFromOppBlockingLoop
	fi
}

# *** Game started ***

gameStart() {
	if [ $toss -eq $player ]
	then
		while [ $flag -eq 1 ]
		do
			playerPlay
			systemPlay
		done
	else
		while [ $flag -eq 1  ]
		do
			systemPlay
			playerPlay
		done
	fi
}

    #========= Main ========"

#toss function calling
firstToss

#symbolAssigining function calling
symbolAssigning
printf "\n"
printf "* System Symbol : $systemSymbol\n"
printf "* Player Symbol : $playerSymbol\n"

#gameStart function calling
gameStart
