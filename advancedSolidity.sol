// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mapping {
    mapping (address => string) public moods;
    // access someone's mood


    function getMood(address user) public view returns (string memory) {
        return moods[user];
    }
    // 0xb2A8AD84EA6CbF50F824e5cB28059F957DF37Fee
    function setMood(string memory mood) public {
        moods[msg.sender] = mood;
    }

    // Excited moof for account 2 0x86CA442a6Ae7A478024Cb18802D6ffA1B6040F1b
    // happy mood for account 4 0xfF9d51b70E27f1B67F16d80Da187384bD323b468

    
}

contract Enum {

    enum Status {
        ToDo,
        IN_PROGRESS,
        DONE,
        CANCELLED
    }

    mapping(uint256 => Status) todos;

    function addTask(uint256 id) public {
        todos[id] = Status.ToDo;
    }

    // function updateStatus(unit256 id, Status newStatus) public {
    //     todos[id] = newStatus;
    // }

    function markTaskInProgress(uint256 id) public {
        todos[id] = Status.IN_PROGRESS;
    }

    function getStatus(uint256 id) public view returns (Status) {
        return todos[id];
    }
}

contract Structs {
    // it is a way of grouping items that are related together to work with them. 
    // Things that don't have to be seperated to work with.
    // It also optimizes gas.
    
     enum Status {
        ToDo,
        IN_PROGRESS,
        DONE,
        CANCELLED
    }

    struct Task {
        string title;
        string description;
        Status status;
    }

    mapping(uint256 => Task) tasks;

    function deleteTask(uint256 id) public {
        delete tasks[id];
    }

    function editTaskTitle(uint256 id, string memory newTitle) public {
        tasks[id].title = newTitle;
    }

    function addTask(uint256 id, string memory title, string memory description) public {
        // 3 ways to initialize struct variable

        // method 1 n/b: if not arrange accordinly, it will compile buh you can get wrong valuse
        // tasks[id] = Task(title, description, Status.ToDo);

        // method 2
        tasks[id] = Task({
            title: title,
            description: description,
            status: Status.ToDo
        });

        // // method 3
        // Task memory task;
        // task.title = title;
        // task.description = description;
        // task.status = Status.ToDo;

        // tasks[id] = task;
    }
}

contract ViewAndPureFunctions {

    // 3 kinds of keywords  to indicate side-effeects of a function
    // first kind - no keyword
    // second kind - 'view' keyword
    // third kind - 'pure' keyword 
    uint y;

    // first kinda function with no keyword
    // you can read or write
    function someFunction() public {
        uint x = 0;
        x = 5; // Not a  side effect
        y = 5; // Is a side effect
    }

    // view function
    // reads from state but does not write to it
    function getY() public view returns (uint) {
        return y;
    }

    // pure function
    // it does not read or write to state
    function addTwoNumbers(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    // N/B view and pure functions do not cost gas
    // other functions that modify the state cost gas


}

contract Modifiers {
    // Modifiers are pieces of code that can be run before or
    // after any other function call

    address owner;

    constructor() {
        // Set the contract deployer as the owner of the contract
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
        //  if we put _; before the message above,
        //  it will make the modifier run after the function call
        // _; means run the rest of the code here
    }

    // these 4 functions should be called by the owner only
    function someFunction1() public onlyOwner {
        //  run rest of the code
    }

    function someFunction2() public onlyOwner {
        //  run rest of the code
    }

    function someFunction3() public onlyOwner {
        //  run rest of the code
    }

    function someFunction4() public onlyOwner {
        //  run rest of the code
    }

}

contract EthSender {
    function mirror() public payable {
        // msg.sender is tbe person we are getting the ETH from
        // and also person we send it back to

        // msg.value is the amount of ETH we recieve 
        // and amount we send back

        address payable target = payable(msg.sender);
        uint amount = msg.value;

        // (payable address).call{ value: amount }("");
        // .call() returns two variables
        // the first is a bool indicating success or failure
        // second is some bytes which have data

        (bool success, bytes memory data) = target.call{ value: amount }("");
        require(success, "FAILURE");

    }
}

library SafeMath {
    // we manually created a library that adds 2 numbers together
    // Libraries are similar to contracts in Solidity, with a few limitations. 
    // Libraries cannot contain any state variables, and cannot transfer ETH.
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        // make sure an overflow did not occur
        require(z >= x, "overflow happened");
        require(z >= y, "overflow happened");
        return z;
    }

    // Integer overflow example

    // Imagine we have a uint8. it can hold values from 0 to (2 ^ 8)-1 i.e 0-255
    // uint8 a = 254;
    // uint8 b = 5;

    // PRE SOLIDITY 0.8

    // uint8 c = a + b;
    // 254 + 5 = 259
    // the value of c, after this statement, wwould actually be 4
    // but you epected it to be 259
}


contract Libraries {
    // we called the library we created above to do the 
    // addition for in this function
    function testAddition(uint x, uint y) public pure returns (uint) {
        return SafeMath.add(x, y);   
    }
}