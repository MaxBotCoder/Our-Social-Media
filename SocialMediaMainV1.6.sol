//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

/* This smart contract system was made
 by your's truely me/myself/I */

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
    
    //Report Session Info
    uint public ReportSessionNumber;

    //Moderation System Related Tasks.
    uint public constant MaxmiumStrikes = 10; //Maximum post reports untill cicked out. //Must be changed prior to deployment.
    uint public constant MaximumLevelOffense = 1;
    uint public constant MinimumLevelOffense = 2;
    mapping(address => uint) public StrikesAccumalated;
    mapping(address => string) public ReportThatResultedInBan;

    //Post Info
    uint public PostNumber;
    mapping(uint => bool) public PostConfescated;
    mapping(uint => address) public PostNumeberToAddress;

    //Personal Post Info!
    mapping(address => uint) public PersonalPostNumber;

    //Accounts and various search, validation & moderation related info.
    uint public AccountNumber;
    mapping(address => bool) public ValidAccount;
    mapping(address => bool) public Blacklisted;
    mapping(string => bool) public HandleClaimed;
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
        string PostContents;
        string ModerationStatus; //Only Creator, Super Users or Moderators can change this otherwise the status is set to it's default state.
        uint PersonalPostNumber;
        uint GlobalPostNumber;
    }

    mapping(uint => Post) public PostNumberToPost;
    mapping(address => mapping(uint => Post)) public PersonalPostNumbering;
    mapping(uint => uint) public PersonalPostNumberToGlobalPostNumber;

    //Contrins info related to report created.
    struct ReportTrial {
        string ReportTypeHumanReadable;
        uint ReportType;
        address AddressOfUserToReport; //Only for reporting people.
        uint PostNumberToReport; //Only for posts.
        string ReportSubject;
        string ReportDetails;
        bool ReportTrialCompleted; //Report verdict reached (Please look at this prior to virdict) false = Verdict not reached, true = Verdict reached.
        bool ReportVerdictReached; //Report verdict true = Guilty, false = Innocent or verdict unreached. (Look at virdict reached first)
        uint ReportSeverity;
    }

    mapping(uint => ReportTrial) public ReportTrialInstance;
    mapping(address => mapping(uint => bool)) public PersonalReport; //What a specific user voted.
    mapping(uint => uint) public ReportInteractionNumber; //Counts number of vote interactions within a report trial. (GENERAL)
    mapping(uint => mapping(bool => uint)) public NumberOfReportsInCatagory; //Counts number of votes (CATAGORY) within a report trial.
    mapping(uint => bool) public GlobalReportResultValid; //dictates validity of global report result
    mapping(uint => bool) public GlobalReportResult;
    mapping(uint => mapping(address => mapping(uint => ReportTrial))) public NumberOfVotesForTrialResult;
    
    mapping(address => uint) public NumberOfReportsCollected;
    mapping(address => mapping(uint => bool)) public UserHasVotedReport;
    mapping(uint => bool) public ReportTrialHasBeenCompleted;
    mapping(uint => bool) public ReportTrialVerdict;

    //Shows info related to votes.
    struct VotingSession {
        string VoteTypeHumanReadable;
        uint VoteType;
        uint AddressOfUserToVote; //Only for reporting people.
        uint PostNumberToVote; //Only for posts.
        string VoteSubject;
        string VoteDetails;
        bool VoteVerdictReached; //Report verdict reached (Please look at this prior to virdict) false = Verdict not reached, true = Verdict reached.
        bool VoteVerdictResult; //Report verdict true = Guilty, false = Innocent or verdict unreached. (Look at virdict reached first)
    }

    mapping(uint => ReportTrial) public VotingSessionInstance;
    mapping(address => mapping(uint => bool)) public PersonalVote; //What a specific user voted.
    mapping(uint => uint) public VotingInteractionNumber; //Counts number of vote interactions within a report trial. (GENERAL)
    mapping(uint => mapping(bool => uint)) public NumberOfVotesInCatagory; //Counts number of votes (CATAGORY) within a report trial.
    mapping(uint => bool) public GlobalVotesResultValid; //dictates validity of global report result
    mapping(uint => bool) public GlobalVotestResult;
    mapping(uint => mapping(address => mapping(uint => ReportTrial))) public NumberOfVotesForResult;
    
    mapping(address => uint) public NumberOfVotesCollected;
    mapping(address => mapping(uint => bool)) public UserHasVoted;
    mapping(uint => bool) public VoteHasBeenCompleted;
    mapping(uint => bool) public VoteResult;

    //Ban appeal trial.
    struct BanAppealSession {
        string ReasonForBan;
        
    }

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
        HandleClaimed[_Handle] = true;
    }

     //Create an account
    function CreateAccount (string memory _Handle, string memory _UserName, string memory _About) public payable {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(msg.sender.balance >= SignUpPrice, "Wallet balance too low to complete transaction. Please check your account balance.");
        require(msg.value == SignUpPrice, "Incorrect quantity of funds sent to complete transaction. Transaction cancelled.");
        require(HandleClaimed[_Handle] == false, "Could not claim already claimed handle.");
        AccountNumber++;
        ValidAccount[msg.sender] = true;
        Clearance[msg.sender] = "Standard folk";
        AccountDataWriter[AccountNumberToAddress[AddressToAccountNumber[msg.sender] = HandleToNumber[_Handle] = AccountNumber] = msg.sender][AddressToAccountNumber[msg.sender]][AddressToHandle[HandleToAddress[_Handle] = msg.sender] = AccountNumberToHandle[AddressToAccountNumber[msg.sender]] = _Handle] = AddressToUserName[msg.sender] = AccountNumberToUserName[AddressToAccountNumber[msg.sender]] = HandleToUserName[AddressToHandle[msg.sender]] = _Handle; //Initialize the mappings with some data
        AddressToPage[msg.sender] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        AccountNumberToPage[AddressToAccountNumber[msg.sender]] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        HandleToPage[AddressToHandle[msg.sender]] = ProfilePage( _Handle, _UserName, _About, Clearance[msg.sender]);
        HandleClaimed[_Handle] = true;
        (msg.sender).call{value: msg.value}("");
    }

    //Edit account info.
    function EditAccount(uint _ModificationType, string memory _ModificationData) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        require(_ModificationType == 1 || _ModificationType == 2 || _ModificationType == 3 , "Invalid modification request.");
        require(HandleClaimed[_ModificationData] == false, "Could not claim already claimed handle.");

        if(_ModificationType == 1) { //1 = Handle configuration.

            HandleClaimed[AddressToHandle[msg.sender]] = false;
            AddressToPage[msg.sender].Handle = _ModificationData;
            AccountNumberToPage[AddressToAccountNumber[msg.sender]].Handle = _ModificationData;
            HandleToPage[AddressToHandle[msg.sender]].Handle = _ModificationData;
            HandleToAddress[AddressToHandle[msg.sender] = AccountNumberToHandle[AddressToAccountNumber[msg.sender]] = _ModificationData] = msg.sender;
            HandleClaimed[_ModificationData] = true;
            

        } else if(_ModificationType == 2) { //2 = User name configuration.

            AddressToPage[msg.sender].UserName = _ModificationData;
            AccountNumberToPage[AddressToAccountNumber[msg.sender]].UserName = _ModificationData;
            HandleToPage[AddressToHandle[msg.sender]].UserName = _ModificationData;
            AddressToPage[msg.sender].UserName = _ModificationData;
            AddressToUserName[msg.sender] = AccountNumberToUserName[AddressToAccountNumber[msg.sender]] = HandleToUserName[AddressToHandle[msg.sender]] = _ModificationData;
            
        } else if(_ModificationType == 3) { //3 = About configuration.

            AddressToPage[msg.sender].About = _ModificationData;
            AccountNumberToPage[AddressToAccountNumber[msg.sender]].About = _ModificationData;
            HandleToPage[AddressToHandle[msg.sender]].About = _ModificationData;
            
        }
         
    }

    //For making posts.
    function CreatePost (string memory _PostContents) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        PostNumber++;
        PersonalPostNumbering[msg.sender][PersonalPostNumber[msg.sender] += 1] = PostNumberToPost[PostNumber] = Post( AddressToHandle[msg.sender], AddressToUserName[msg.sender], _PostContents, "All clear", PersonalPostNumber[msg.sender], PostNumber);
        PersonalPostNumberToGlobalPostNumber[PersonalPostNumber[msg.sender]] = PostNumber;
        PostNumeberToAddress[PostNumber] = msg.sender;
    }

    //For editing posts.
    function EditPost ( uint _PersonalPostNumber, string memory _PostData) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        PersonalPostNumbering[msg.sender][_PersonalPostNumber] = PostNumberToPost[PersonalPostNumberToGlobalPostNumber[_PersonalPostNumber]] = Post( AddressToHandle[msg.sender], AddressToUserName[msg.sender], _PostData, "All clear", PersonalPostNumber[msg.sender], PostNumber);
    }

    //For voting normally.
    function VotingPollInteraction (uint _VoteType, uint _VoteSessionNumber, bool _CastVote) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true || AltSuperUser[msg.sender] == true || Moderator[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        require(_VoteType == 1 || _VoteType == 2 || _VoteType == 3 , "Invalid voting option.");
        
        if(_VoteType == 1) { //Vote in moderator.



        } else if (_VoteType == 2) { //Vote in ALT Super User.
            
        } else if (_VoteType == 3) { //Appeal Report

        }
    }

    function ReportTrialVoting ( uint _ReportSessionNumber, bool _CastVote) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true || AltSuperUser[msg.sender] == true || Moderator[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        require(UserHasVotedReport[msg.sender][_ReportSessionNumber] == false, "You already voted.");
        require(ReportInteractionNumber[_ReportSessionNumber] <= 57, "Maximum votes have been reached");

        UserHasVotedReport[msg.sender][_ReportSessionNumber] = true;
        ReportInteractionNumber[_ReportSessionNumber]++;
        PersonalReport[msg.sender][_ReportSessionNumber] = true;
        NumberOfReportsInCatagory[_ReportSessionNumber][PersonalReport[msg.sender][_ReportSessionNumber]]++;

        if(NumberOfReportsInCatagory[_ReportSessionNumber][true] <= 29) {

            //Reports with level 2 severity will be handled here.

            if(ReportTrialInstance[_ReportSessionNumber].ReportType == 1 && ReportTrialInstance[_ReportSessionNumber].ReportSeverity == MinimumLevelOffense) {  //For reporting posts.

            ReportTrialInstance[_ReportSessionNumber].ReportTrialCompleted = true;
            ReportTrialInstance[_ReportSessionNumber].ReportVerdictReached = true;
            GlobalReportResultValid[_ReportSessionNumber] = true;
            GlobalReportResult[_ReportSessionNumber] = true;
            StrikesAccumalated[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport]++;

            if(StrikesAccumalated[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] == MaxmiumStrikes) {
                
                Blacklisted[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] = true;

            }

            PostNumberToPost[ReportTrialInstance[_ReportSessionNumber].PostNumberToReport].PostContents = "Post Contents have been redacted due to violating our polocies.";
            ReportThatResultedInBan[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] = ReportTrialInstance[_ReportSessionNumber].ReportDetails;
            
            } else if (ReportTrialInstance[_ReportSessionNumber].ReportType == 2 && ReportTrialInstance[_ReportSessionNumber].ReportSeverity == MinimumLevelOffense) { //For reporting accounts.

            ReportTrialInstance[_ReportSessionNumber].ReportTrialCompleted = true;
            ReportTrialInstance[_ReportSessionNumber].ReportVerdictReached = true;
            GlobalReportResultValid[_ReportSessionNumber] = true;
            GlobalReportResult[_ReportSessionNumber] = true;
            StrikesAccumalated[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport]++;


            if(StrikesAccumalated[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] == MaxmiumStrikes) {
                
                Blacklisted[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] = true;
                
            }
            
            AddressToPage[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport].UserName = AccountNumberToPage[AddressToAccountNumber[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport]].UserName = HandleToPage[AddressToHandle[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport]].UserName = "Account Suspended.";
            AddressToPage[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport].About = AccountNumberToPage[AddressToAccountNumber[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport]].About = HandleToPage[AddressToHandle[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport]].About = "Account Suspended.";
            ReportThatResultedInBan[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] = ReportTrialInstance[_ReportSessionNumber].ReportDetails;

            } 
            //Reports with level 1 severity will be handled here.

            if( ReportTrialInstance[_ReportSessionNumber].ReportSeverity == MaximumLevelOffense) { //For reporting posts.

            ReportTrialInstance[_ReportSessionNumber].ReportTrialCompleted = true;
            ReportTrialInstance[_ReportSessionNumber].ReportVerdictReached = true;
            GlobalReportResultValid[_ReportSessionNumber] = true;
            GlobalReportResult[_ReportSessionNumber] = true;
            Blacklisted[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] = true;
            ReportThatResultedInBan[ReportTrialInstance[_ReportSessionNumber].AddressOfUserToReport] = ReportTrialInstance[_ReportSessionNumber].ReportDetails;

            } 

        } else if (NumberOfReportsInCatagory[_ReportSessionNumber][false] <= 29) {

            ReportTrialInstance[_ReportSessionNumber].ReportTrialCompleted = true;
            ReportTrialInstance[_ReportSessionNumber].ReportVerdictReached = false;
            GlobalReportResultValid[_ReportSessionNumber] = true;
            GlobalReportResult[_ReportSessionNumber] = false;

        }

    }

    function Report (uint _ReportType, address _AddressOfPersontoReport, uint _NumberOfPostToReport, uint _ReportSeverity, string memory _ReportSubject, string memory _ReportDetails) public {
        require(Blacklisted[msg.sender] == false, "You have been blacklisted.");
        require(ValidAccount[msg.sender] == true || AltSuperUser[msg.sender] == true || Moderator[msg.sender] == true, "We're sorry for the inconvenience, but only people with accounts are allowed to make posts.");
        require(_ReportType == 1 || _ReportType == 2 || _ReportType == 3 || _ReportType == 4 || _ReportType == 5, "Invalid report option.");
        
        if (_ReportType == 1) { //For reporting posts.

            ReportTrialInstance[ReportSessionNumber++].ReportTypeHumanReadable = "Post Report";
            ReportTrialInstance[ReportSessionNumber].ReportType = _ReportType;
            ReportTrialInstance[ReportSessionNumber].PostNumberToReport = _NumberOfPostToReport;
            ReportTrialInstance[ReportSessionNumber].ReportSubject = _ReportSubject;
            ReportTrialInstance[ReportSessionNumber].ReportDetails = _ReportDetails;
            ReportTrialInstance[ReportSessionNumber].ReportSeverity = _ReportSeverity;

            ReportTrialVoting( ReportSessionNumber, true);

        } else if (_ReportType == 2) { //For reporting accounts.

            ReportTrialInstance[ReportSessionNumber++].ReportTypeHumanReadable = "Account Report";
            ReportTrialInstance[ReportSessionNumber].ReportType = _ReportType;
            ReportTrialInstance[ReportSessionNumber].AddressOfUserToReport = _AddressOfPersontoReport;
            ReportTrialInstance[ReportSessionNumber].ReportSubject = _ReportSubject;
            ReportTrialInstance[ReportSessionNumber].ReportDetails = _ReportDetails;
            ReportTrialInstance[ReportSessionNumber].ReportSeverity = _ReportSeverity;

            ReportTrialVoting( ReportSessionNumber, true);

        } else if (_ReportType == 3) { //For reporting mods.

            ReportTrialInstance[ReportSessionNumber++].ReportTypeHumanReadable = "Corrupt or rulebending moderator.";
            ReportTrialInstance[ReportSessionNumber].ReportType = _ReportType;
            ReportTrialInstance[ReportSessionNumber].AddressOfUserToReport = _AddressOfPersontoReport;
            ReportTrialInstance[ReportSessionNumber].ReportSubject = _ReportSubject;
            ReportTrialInstance[ReportSessionNumber].ReportDetails = _ReportDetails;
            ReportTrialInstance[ReportSessionNumber].ReportSeverity = _ReportSeverity;

            ReportTrialVoting( ReportSessionNumber, true);

        } else if (_ReportType == 4) { //For reporting AltSuperuser.

            ReportTrialInstance[ReportSessionNumber++].ReportTypeHumanReadable = "Corrupt or rulebending super user.";
            ReportTrialInstance[ReportSessionNumber].ReportType = _ReportType;
            ReportTrialInstance[ReportSessionNumber].AddressOfUserToReport = _AddressOfPersontoReport;
            ReportTrialInstance[ReportSessionNumber].ReportSubject = _ReportSubject;
            ReportTrialInstance[ReportSessionNumber].ReportDetails = _ReportDetails;
            ReportTrialInstance[ReportSessionNumber].ReportSeverity = _ReportSeverity;

            ReportTrialVoting( ReportSessionNumber, true);

        }
    }

    function AppealBan (uint _AppealJustification ,string memory _Message) public {
        require(Blacklisted[msg.sender] == true, "You're not blacklisted silly!");


    }
}
