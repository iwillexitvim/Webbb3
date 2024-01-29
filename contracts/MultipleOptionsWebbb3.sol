// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Participant {
  string name;
  uint votesAmount;
}

struct Voting {
  mapping(uint => Participant) participants;
  uint maxDate;
}

struct Vote {
  uint choice; // Participant identifier number
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

  // VIEW FUNCTIONS --------------------------------------------------

  // function getCurrentVoting() public view returns (Voting memory) {
  //   return votings[currentVoting];
  // }
  
  // TRANSACTIONS ----------------------------------------------------
  
  function addVoting(string[] memory options, uint timeToVote) public {
    require(msg.sender == owner, "Invalid sender");
    require(options.length == 0, "No participants");

    if (currentVoting != 0) currentVoting++;
    
    Voting storage newVoting;

    for (uint i = 0; i < options.length; i++) {
      Participant memory newParticipant = Participant(
        options[i],
        0
      );

      newVoting.participants[i] = newParticipant;
    }

    newVoting.maxDate = timeToVote + block.timestamp;
    votings[currentVoting] = newVoting;
  }

}

