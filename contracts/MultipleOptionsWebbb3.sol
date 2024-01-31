// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Participant {
  string name;
  uint256 votesAmount;
}

struct Poll {
  uint256 maxDate;
  uint256 numberOfParticipants;
}

struct Vote {
  uint256 choice; // Participant identifier number
  uint256 date;
}

uint256 constant hour = 3600;

contract Webbb3 {
  address owner;

  Poll[] public polls;
  uint256 public currentPoll = 0;

  mapping(uint256 => Participant[]) public participants;
  mapping(uint256 => mapping(address => Vote[])) public votes;

  constructor() {
    owner = msg.sender;
  }

  // VIEW FUNCTIONS --------------------------------------------------

  function getCurrentPoll() public view returns (Poll memory) {
    return polls[currentPoll];
  }

  function getParticipants() public view returns (Participant[] memory) {
    return participants[currentPoll];
  }

  function getVotes() public view returns (Vote[] memory) {
    return votes[currentPoll][msg.sender];
  }

  // TRANSACTIONS ----------------------------------------------------

  function addPoll(string[] memory _participants, uint256 _maxDate) public {
    require(msg.sender == owner, "Invalid sender");
    require(_participants.length != 0, "No participants");

    polls.push(
      Poll({
        maxDate: _maxDate + block.timestamp,
        numberOfParticipants: _participants.length
      })
    );

    for (uint256 i = 0; i < _participants.length; i++) {
      participants[currentPoll].push(
        Participant({name: _participants[i], votesAmount: 0})
      );
    }
  }

  function addVote(uint256 index) public {
    require(index >= 0 && index < getParticipants().length, "Invalid choice");
    require(getCurrentPoll().maxDate > block.timestamp, "No open poll");

    uint256 userVotesNumber = getVotes().length;

    if (userVotesNumber > 0) {
      require(
        block.timestamp - getVotes()[userVotesNumber - 1].date > hour,
        "You already votes in the last hour"
      );
    }

    votes[currentPoll][msg.sender].push(
      Vote({choice: index, date: block.timestamp})
    );
    participants[currentPoll][index].votesAmount++;
  }

  // TODO: Return the winner of the poll and increment currentPoll
  function finishPoll() public {
    currentPoll++;
  }
}
