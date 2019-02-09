pragma solidity ^0.5.0;

// The game of RockPaperScissors
contract RockPaperScissors {
    // There are two players in this game and each of them makes a choice
    address payable public player1;
    address payable public player2;
    string public choiceOfPlayer1;
    string public choiceOfPlayer2;
    bool public hasPlayer1MadeChoice;
    bool public hasPlayer2MadeChoice;
    
    // When a player joins the game, they have to pay a playing fee 
    uint256 private stake;

    // A matrix containing result of the game depedning on its states
    mapping(string => mapping(string => uint8)) private states;

    // The constructor initialise the game environment
    constructor() public {
        states["R"]["R"] = 0;
        states["R"]["P"] = 2;
        states["R"]["S"] = 1;
        states["P"]["R"] = 1;
        states["P"]["P"] = 0;
        states["P"]["S"] = 2;
        states["S"]["R"] = 2;
        states["S"]["P"] = 1;
        states["S"]["S"] = 0;

        stake = 1 ether;
        
        reset();
    }
    
    event GameStarted();
    
    modifier joinable() {
        require(player1 == address(0) || player2 == address(0), "The room is full.");
        require(msg.value == stake, "You must pay 1 ETH to play the game.");
        _;
    }
    
    modifier hasJoined() {
        require(player1 != address(0) && player2 != address(0));
        _;
    }
    
    modifier isValidChoice(string memory _playerChoice) {
        require(keccak256(bytes(_playerChoice)) == keccak256(bytes('R')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('P')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('S'))
        );
        _;
    }
    
    modifier playersMadeChoice() {
        require(hasPlayer1MadeChoice && hasPlayer2MadeChoice);
        _;
    }
    
    modifier gameOver() {
        require(address(this).balance == 0 wei, "The game is not over yet.");
        _;
    }

    function join() external payable joinable() {
        if (player1 == address(0))
            player1 = msg.sender;
        else
            player2 = msg.sender;
            
        if (player1 != address(0) && player2 != address(0))
            emit GameStarted();
    }
    
    function play(string calldata _playerChoice) external hasJoined() {
        // each player makes their own choice (e.g. Rock, Paper, Scissors)
        makeChoice(_playerChoice);
        
        // after making the choices, they disclose the result
        disclose();
        
        // when the game is finished, it is reset
        reset();
    }
    
    function makeChoice(string memory _playerChoice) private isValidChoice(_playerChoice) {
        if (msg.sender == player1 && !hasPlayer1MadeChoice) {
            choiceOfPlayer1 = _playerChoice;
            hasPlayer1MadeChoice = true;
        } else if (msg.sender == player2 && !hasPlayer2MadeChoice) {
            choiceOfPlayer2 = _playerChoice;
            hasPlayer2MadeChoice = true;
        }
    }
    
    function disclose() private playersMadeChoice() {
        int result = states[choiceOfPlayer1][choiceOfPlayer2];
        if (result == 0) {
            player1.transfer(stake); 
            player2.transfer(stake);
        } else if (result == 1) {
            player1.transfer(address(this).balance);
        } else if (result == 2) {
            player2.transfer(address(this).balance);
        }
    }
    
    function reset() private gameOver() {
        player1 = address(0);
        player2 = address(0);

        choiceOfPlayer1 = "";
        choiceOfPlayer2 = "";
        
        hasPlayer1MadeChoice = false;
        hasPlayer2MadeChoice = false;
    }
}

