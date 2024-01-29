// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Voting {
  string option1;
  uint votes1;
  string option2;
  uint votes2;
  uint maxDate;
}

struct Vote {
  uint choice; // 1 or 2
  uint date;
}

contract Webbb3 {
  address owner;
  uint public currentVoting = 0; 
  Voting[] public votings;
  mapping(uint => mapping(address => Vote)) public votes;

  constructor() {
    owner = msg.sender;
  }

  // view functions do not cost gas fee
  // they are not real transactions
  function getCurrentVoting() public view returns (Voting memory) {
    return votings[currentVoting];
  }

  function getUserVote() public view returns (Vote memory) {
    return votes[currentVoting][msg.sender];
  }

  function addVoting(
    string memory option1, 
    string memory option2, 
    uint timeToVote
  ) public {
    require(msg.sender == owner, "Invalid sender");
    
    if (currentVoting  != 0) currentVoting++;

    Voting memory newVoting;
    newVoting.option1 = option1;
    newVoting.option2 = option2;
    newVoting.maxDate = timeToVote + block.timestamp;
    votings.push(newVoting);
  }

  function addVote(uint choice) public {
    require(choice == 1 || choice == 2, "Invalid choice");
    require(getCurrentVoting().maxDate > block.timestamp, "No open voting");
    require(votes[currentVoting][msg.sender].date == 0, "You already voted");

    votes[currentVoting][msg.sender].choice = choice;
    votes[currentVoting][msg.sender].date = block.timestamp;

    if (choice == 1) votings[currentVoting].votes1++;
    else votings[currentVoting].votes2++;
  }
}
