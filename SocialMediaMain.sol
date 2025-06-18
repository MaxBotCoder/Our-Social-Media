//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

/* This smart contract system was made
 by your's truely MaxBotCoder me/myself/I */

contract SocialMediaMain {

    //Signup price (Must be configured prior to depoloyment) << UNCHANGEABLE >>
    uint public constant SignUpPrice = 6;

    //User perissions.
    address public creator;
    mapping(address => bool) public AltSuperUser;
    uint public NumberOfSuperUsers;
    mapping(address => uint) public AltSuperUserNumber;
    mapping(address => bool) public Moderator;
    uint public NumberOfModerators;
    mapping(address => uint) public ModeratorNumber;
    mapping(address => string) public Clearance;

    //Abuse of power failsafe.
    uint public constant MaximumBanningsPerWeek = 200; //Must be configured before deployement << FAILSAFE >> << UNCHANGEABLE >>
    uint public constant AltSuperUserTermLimits = 18; //Represents the number of weeks an Alt SuperUser can have power
    
    //Moderator Voting.
    mapping(address => bool) public ModeratorHasVoted;
    uint public ModeratorVotingSessionNumber;
    mapping(uint => bool) public VotingSessionResult;
    mapping(uint => string) public VotingSessionTopic;

    //Moderator & AltSuperUser Election Storage
    uint public ElectionNumber;
    mapping(uint => bool) public ElectionCompleted; //false = election not concluded & true = election concluded
    mapping(uint => bool) public ElectionCorrupt; //true = election was compromised & false = election went (CORRECTLY) FLASE IS GOOD TRUE IS BAD.
    mapping(uint => bool) public ElectionResult; //true = yay & false = nay

    //Post Info
    uint public PostNumber;
    mapping(uint => bool) public PostConfescated;

    //Personal Post Info!
    mapping(address => uint) public PersonalPostNumber;

    //Accounts and various search, validation & moderation related info.
    uint public AccountNumber;
    mapping(address => bool) public ValidAccount;
    mapping(address => bool) public Blacklisted;
    mapping(address => uint) public AddressToAccountNumber; //Gets input from msg.sender to equal handletonumber (2)
    mapping(address => string) public AddressToHandle; //Takes in address via handle to address and equates to account numebr to handle (4)
    mapping(address => string) public AddressToUserName; //Takes in user name and equates it to account number to username (7)
    mapping(uint => address) public AccountNumberToAddress; //Utilised takes in address to account number in order to inumerate itself and write to mapping. (1)
    mapping(uint => string) public AccountNumberToHandle; //Takes in account number and outputs handle passing it to address to handle as it's value (6) 
    mapping(uint => string) public AccountNumberToUserName; //Takes in handle to user name (8)
    mapping(string => address) public HandleToAddress; //Takes in handle and gives address to address to handle (5)
    mapping(string => uint) public HandleToNumber; //Takes in handle and equals Account Number (3)
    mapping(string => string) public HandleToUserName; //Takes in address to handle and gives Account number to user name value of _Handle (9) "Final Account Creation Step"

    //Account specifics (For writing data easily)
    mapping(address => mapping(uint => mapping(string => string))) AccountDataWriter;

    //Account HomePage/Searchresult
    struct ProfilePage {
        string Handle;
        string UserName;
        string About;
        string Clearance;
    }

    mapping(address => ProfilePage) public AddressToPage;
    mapping(uint => ProfilePage) public AccountNumberToPage;
    mapping(string => ProfilePage) public HandleToPage;

    //Post Creation
    struct Post {
        string Handle;
        string UserName;
        string Post;
        string ModerationStatus; //Only Creator, Super Users or Moderators can change this otherwise the status is set to it's default state.
    }

    mapping(uint => Post) public PostNumberToPost;
    mapping(address => mapping(uint => Post)) PersonalPostNumbering;

    //Prepair contract info
    constructor(string memory _Handle, string memory _UserName, string memory _About) {
        creator = msg.sender;
        AccountNumber++;
        ValidAccount[msg.sender] = true;
        Clearance[msg.sender] = "Creator";
        AccountDataWriter[AccountNumberToAddress[AddressToAccountNumber[msg.sender] = HandleToNumber[_Handle] = AccountNumber] = msg.sender][AddressToAccountNumber[msg.sender]][AddressToHandle[HandleToAddress[_Handle] = msg.sender] = AccountNumberToHandle[AddressToAccountNumber[msg.sender]] = _Handle] = AddressToUserName[msg.sender] = AccountNumberToUserName[AddressToAccountNumber[msg.sender]] = HandleToUserName[AddressToHandle[msg.sender]] = _Handle; //Initialize the mappings with some data
        AddressToPage[msg.sender] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        AccountNumberToPage[AddressToAccountNumber[msg.sender]] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        HandleToPage[AddressToHandle[msg.sender]] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
    }

    //Create an account
    function CreateAccount (string memory _Handle, string memory _UserName, string memory _About) public payable {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(msg.sender.balance >= SignUpPrice, "Wallet balance too low to complete transaction. Please check your account balance.");
        require(msg.value == SignUpPrice, "Incorrect quantity of funds sent to complete transaction. Transaction cancelled.");
        AccountNumber++;
        ValidAccount[msg.sender] = true;
        Clearance[msg.sender] = "Standard folk";
        AccountDataWriter[AccountNumberToAddress[AddressToAccountNumber[msg.sender] = HandleToNumber[_Handle] = AccountNumber] = msg.sender][AddressToAccountNumber[msg.sender]][AddressToHandle[HandleToAddress[_Handle] = msg.sender] = AccountNumberToHandle[AddressToAccountNumber[msg.sender]] = _Handle] = AddressToUserName[msg.sender] = AccountNumberToUserName[AddressToAccountNumber[msg.sender]] = HandleToUserName[AddressToHandle[msg.sender]] = _Handle; //Initialize the mappings with some data
        AddressToPage[msg.sender] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        AccountNumberToPage[AddressToAccountNumber[msg.sender]] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        HandleToPage[AddressToHandle[msg.sender]] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        (msg.sender).call{value: msg.value}("");
    }

    //Edit account info.
    function EditAccount() public {
        
    }

    //For making posts.
    function CreatePost (string memory _PostContents) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        PostNumber++;
        PersonalPostNumbering[msg.sender][PersonalPostNumber[msg.sender] += 1] = PostNumberToPost[PostNumber] = Post( AddressToHandle[msg.sender], AddressToUserName[msg.sender], _PostContents, "All clear");
    }

    function EditPost ( uint _PostNumber, string memory _PostData) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");

    }

    function Report () public {

    }


    function VotingPolls () public {

    }

} 
