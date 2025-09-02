//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


// 用 solidity 实现罗马数字转数整数
// 题目描述在 https://leetcode.cn/problems/integer-to-roman/description/

contract RomanToNumber {

    function romanToInt(string memory s) public pure returns (int) {
        // spit string to char array
        int account = 0;
        bytes memory charArray = bytes(s);

        for (uint i = 0; i < charArray.length; i++) {
            bool hasNext = i + 1 < charArray.length;
            bytes1 nextString;
            if(hasNext){
                nextString = charArray[i+1];
            }

            if(charArray[i] == "M") {
                account += 1000;
                continue;
            } else if(charArray[i] == "D") {
                account += 500;
                continue;
            } else if(charArray[i] == "C") {
                account += 100;
                // CD = 400 (需要减去200，因为后面会加500)
                // CM = 900 (需要减去200，因为后面会加1000)
                if (hasNext && (nextString == "D" || nextString == "M")) {
                    account -= 200;
                }
                continue;
            } else if(charArray[i] == "L") {
                account += 50;
                continue;
            } else if(charArray[i] == "X") {
                account += 10;
                // XL = 40 (需要减去20，因为后面会加50)
                // XC = 90 (需要减去20，因为后面会加100)
                if (hasNext && (nextString == "L" || nextString == "C")) {
                    account -= 20;
                }
                continue;
            } else if(charArray[i] == "V") {
                account += 5;
                continue;
            } else if(charArray[i] == "I") {
                account += 1;
                // IV = 4 (需要减去2，因为后面会加5)
                // IX = 9 (需要减去2，因为后面会加10)
                if (hasNext && (nextString == "V" || nextString == "X")) {
                    account -= 2;
                }
            }
        }
        return account;

    }
}