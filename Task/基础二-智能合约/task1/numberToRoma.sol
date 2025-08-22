//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


contract numberToRoma {

    // enum RomanNumerals {IV, IX, XL, XC, CD, CM}
    function checkSpecial(uint number) public pure returns (string memory roma) {
        if (number == 4) {
            return "IV";
        } else if (number == 9) {
            return "IX";
        } else if (number == 40) {
            return "XL";
        } else if (number == 90) {
            return "XC";
        } else if (number == 400) {
            return "CD";
        } else if (number == 900) {
            return "CM";
        }
        return "0";
    }

        // 比较字符串
    function isEqual(string memory str, string memory str1) public pure returns (bool) {
        return keccak256(abi.encodePacked(str)) == keccak256(abi.encodePacked(str1));
    }


    function convertor(uint number) public pure returns (string memory roma) {

        require(number > 0 && number < 4000, "number is illegal");

        string memory specialRoma = checkSpecial(number);

        if (!isEqual(specialRoma, "0")) {
            return specialRoma;
        }

        bytes memory romaBytes;
        
        if (number / 1000 != 0) {
            for (uint i = 0; i < number / 1000; i++) {
                romaBytes = abi.encodePacked(romaBytes, "M");
            }
            number -= (number / 1000) * 1000; // remove thousand
        }
        
        if (number / 500 != 0) {
            romaBytes = abi.encodePacked(romaBytes, "D");
            number -= 500; // remove five hundred
        }
        
        if (number / 100 != 0) {
            for (uint i = 0; i < number / 100; i++) {
                romaBytes = abi.encodePacked(romaBytes, "C");
            }
            number -= (number / 100) * 100; // remove hundred
        }

        if (number / 50 != 0) {
            romaBytes = abi.encodePacked(romaBytes, "L");
            number -= 50; // remove fity
        }

        if (number / 10 != 0) {
            for (uint i = 0; i < number / 10; i++) {
                romaBytes = abi.encodePacked(romaBytes, "X");
            }
            number -= (number / 10) * 10; // remove ten
        }

        if (number / 5 != 0) {
            romaBytes = abi.encodePacked(romaBytes, "V");
            number -= 5; // remove five
        }

        if (number / 1 != 0) {
            for (uint i = 0; i < number / 1; i++) {
                romaBytes = abi.encodePacked(romaBytes, "I");
            }
            number -= number / 1; // remove ten
        }

        return string(romaBytes);
    }
}