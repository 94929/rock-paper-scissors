# RockPaperScissors

A Solidity implementation of a simple smart contract which illustrates the game of rock-paper-scissors.

## Installation

No particular installation is required.

## Usage

1) Go to [Remix](http://remix.ethereum.org) which is an online IDE designed for Solidity. <br/>
2) Copy the source code from RockPaperScissors.sol, locate it under the browser folder. <br/>
3) Compile the code by clicking "Start to compile" button under "Compile" tab on the right pane. <br/>
4) Navigate to "Run" tab, choose JavaScript VM environment. <br/>
5) Press the deploy button in order to deploy the contract. <br/>
6) You will now see a contract under "Deployed Contracts" section. <br/>
7) Then choose any account from "Account" drop-down list. This account will be a player for the game. <br/>
8) After choosing a player, join the game by pressing the "join" button. Make sure you pay the stake of 1 ether. This can be done by typing '1' next to "Value" and choose "ether" in the drop-down menu. <br/>
9) Change account and join the game by repeating the processes 7 and 8 above. <br/>
10) Now press "makeChoice" button to make a choice. A valid choice will be one of "R", "P", "S". <br/>
11) Repeat again for another account we made. <br/>
12) Then disclose the game result. This can be done by pressing "disclose" button. <br/>
13) Once the outcome of the game is disclosed, you will gain/lose 1 ether unless you draw. <br/>
14) When the game is over, you can repeat the processes 7-13 to play the game again. <br/>

## Todo

1) Implement a code for encrypting the user input for security. <br/>
2) Add timeout logic after a player making a choice. <br/>
