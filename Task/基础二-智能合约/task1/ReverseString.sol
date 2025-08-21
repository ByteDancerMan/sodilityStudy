//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract ReverseString {

    // reverse string eg: "hello" -> "olleh", but not for char 
    function reverseString(string memory _str) public pure returns (string memory){
        bytes memory charArray = bytes(_str);
        bytes memory reverse = new bytes(charArray.length);

        for(uint i = 0; i < charArray.length; i++){
            reverse[i] = bytes(_str)[charArray.length - i - 1];
        }
        return string(reverse);
    }
}
