//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// 合并两个有序数组 (Merge Sorted Array)
// 题目描述：将两个有序数组合并为一个有序数组。
contract mergeSortedArray{
    function merge(int[] memory nums1, int[] memory nums2) pure public returns(int[] memory) {

    int[] memory merged = new int[](nums1.length + nums2.length);
    uint i = 0; // nums1的索引
    uint j = 0; // nums2的索引
    uint k = 0; // 合并数组的索引

    while(i < nums1.length && j < nums2.length) {
        if(nums1[i] < nums2[j]) {
            merged[k] = nums1[i];
            i++;
        } else {
            merged[k] = nums2[j];
            j++;
        }
        k++;
    }

    while(i < nums1.length) {
        merged[k] = nums1[i];
        i++;
        k++;
    }

    while(j < nums1.length) {
        merged[k] = nums1[j];
        j++;
        k++;
    }
    return merged;
    }
}