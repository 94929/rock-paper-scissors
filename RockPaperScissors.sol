pragma solidity ^0.5.0;

// The game of RockPaperScissors
contract RockPaperScissors {
    // There are two players in this game and each of them makes a choice
    address payable private player1;
    address payable private player2;
    string private choiceOfPlayer1;
    string private choiceOfPlayer2;
    bool private hasPlayer1MadeChoice;
    bool private hasPlayer2MadeChoice;
    
    // When a player joins the game, they have to pay a playing fee 
    uint256 public stake; //the stake should be visible to Player2

    // A matrix containing result of the game depedning on its states
    mapping(string => mapping(string => uint8)) private states;

    // The constructor initialise the game environment
    constructor() public {
        states['R']['R'] = 0;
        states['R']['P'] = 2;
        states['R']['S'] = 1;
        states['P']['R'] = 1;
        states['P']['P'] = 0;
        states['P']['S'] = 2;
        states['S']['R'] = 2;
        states['S']['P'] = 1;
        states['S']['S'] = 0;

        stake = 1 ether;
    }
    
    // Modifiers
    
    modifier isJoinable() {
        require(player1 == address(0) || player2 == address(0),
                "The room is full."
        );
        require((player1 != address(0) && msg.value == stake) || (player1 == address(0)), //Player1 can choose the stake, Player2 has to match. 
                "You must pay the stake to play the game."
        );
        _;
    }
    
    modifier isPlayer() {
        require(msg.sender == player1 || msg.sender == player2,
                "You are not playing this game."
        );
        _;
    }
    
    modifier isValidChoice(string memory _playerChoice) {
        require(keccak256(bytes(_playerChoice)) == keccak256(bytes('R')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('P')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('S')) ,
                "Your choice is not valid, it should be one of R, P and S."
        );
        _;
    }
    
    modifier playersMadeChoice() {
        require(hasPlayer1MadeChoice && hasPlayer2MadeChoice,
                "The player(s) have not made their choice yet."
        );
        _;
    }

    // Functions
     
    function join() external payable 
        isJoinable() // To join the game, there must be a free space
    {
        if (player1 == address(0)) {
            player1 = msg.sender;
            stake = msg.value; //Player1 determines the stake
            
        } else
            player2 = msg.sender;
    }
    
    function makeChoice(string calldata _playerChoice) external 
        isPlayer()                      // Only the players can make the choice
        isValidChoice(_playerChoice)    // The choices should be valid 
    {
        if (msg.sender == player1 && !hasPlayer1MadeChoice) {
            choiceOfPlayer1 = _playerChoice;
            hasPlayer1MadeChoice = true;
        } else if (msg.sender == player2 && !hasPlayer2MadeChoice) {
            choiceOfPlayer2 = _playerChoice;
            hasPlayer2MadeChoice = true;
        }
    }
    
    function disclose() external 
        isPlayer()          // Only players can disclose the game result
        playersMadeChoice() // Can disclose the result when choices are made
    {
        // Disclose the game result
        int result = states[choiceOfPlayer1][choiceOfPlayer2];
        if (result == 0) {
            player1.transfer(stake); 
            player2.transfer(stake);
        } else if (result == 1) {
            player1.transfer(address(this).balance);
        } else if (result == 2) {
            player2.transfer(address(this).balance);
        }
        
        // Reset the game
        player1 = address(0);
        player2 = address(0);

        choiceOfPlayer1 = "";
        choiceOfPlayer2 = "";
        
        hasPlayer1MadeChoice = false;
        hasPlayer2MadeChoice = false;
        
        stake = 1 ether;
    }
}
