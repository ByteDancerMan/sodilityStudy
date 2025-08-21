//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Voting {

    // contract owner
    address public owner;

    // sender has voted
    mapping(address => bool) public hasVoted;

    // store all address
    address[] public addressList;

    // mapping of candidates and their votes
    mapping(address => uint256) public votes;

    // constractor set owner
    constructor() {
        owner = msg.sender;
    }

    // check is owner
    modifier onlyOwner(){
        require(msg.sender == owner, "you are not owner");
        _;
    }

    // vote for a candidate
    function vote(address candidate) public {
        // check has voted
        require(!hasVoted[msg.sender], "You have already voted");
        // set has voted
        hasVoted[msg.sender] = true;
        // hasVoted[msg.sender]
        if (votes[candidate] == 0) {
            addressList.push(candidate);
        }
        votes[candidate] += 1;
    }

    // get the number of votes for a candidate
    function getVotes(address candidate) public view returns (uint256) {
        // check if candidate exists
        return votes[candidate];
    }

    // reset all votes
    function resetVotes() public onlyOwner{
        for (uint256 i = 0; i < addressList.length; i++) {
            // clear votes
            votes[addressList[i]] = 0;
            // clear hasvoted
            hasVoted[addressList[i]] = false;
        }
            // clear candidate address
            delete addressList;
    }

}