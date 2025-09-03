//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract binarySearch {


    function binarySearchFunc(int[] memory arr, int target) public pure returns (int) {
        uint left = 0;
        uint right = arr.length - 1;
        while(left <= right) {
            uint mid = (left + right) / 2;
            if (arr[mid] == target) {
                return arr[mid];
            } else if (arr[mid] > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return -1;
    }
}