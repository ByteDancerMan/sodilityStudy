//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract BeggingContract {

    address private _owner;

    // timestamp
    uint256 private _timestamp;

    event Donate(address indexed from, uint256 amount);

    // mapping sender address to balance
    mapping(address => uint256) public balances;

    // 捐赠排行榜数组，按捐赠金额从高到低排序
    address[3] private _topDonators;

    // 记录排行榜中每个地址的捐赠金额，用于快速比较
    mapping(address => uint256) private _topDonatorAmounts;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function.");
        _;
    }

    // constructor
    constructor() {
        _timestamp = block.timestamp + 1 days;
        _owner = msg.sender;
    }

    // receive donate from other contract
    function donate() external payable {

        require(block.timestamp < _timestamp, "Donation period has ended.");
        require(msg.value > 0, "Donation amount must be greater than 0.");
        balances[msg.sender] += msg.value;

                // 更新排行榜
        _updateTopDonators(msg.sender, balances[msg.sender]);
        emit Donate(msg.sender, msg.value);
    }

    // withdraw all balance
    function withdrow() external onlyOwner {
        require(address(this).balance > 0, "Insufficient balance.");
        payable(msg.sender).transfer(address(this).balance);
    }

    // get donation amount
    function getDonation(address donator) external view returns (uint256 amount) {
        amount = balances[donator];
    }

        // 获取捐赠排行榜
    function getTopDonators() external view returns (address[3] memory) {
        return _topDonators;
    }

        // 更新排行榜的内部函数
    function _updateTopDonators(address donator, uint256 newAmount) internal {
        // 检查是否已经在排行榜中
        bool inTopList = false;
        for (uint i = 0; i < 3; i++) {
            if (_topDonators[i] == donator) {
                inTopList = true;
                _topDonatorAmounts[donator] = newAmount;
                break;
            }
        }
        
        // 如果已经在排行榜中，只需要重新排序
        if (inTopList) {
            _sortTopDonators();
            return;
        }
        
        // 如果不在排行榜中，检查是否应该加入
        for (uint i = 0; i < 3; i++) {
            // 如果排行榜位置为空，直接加入
            if (_topDonators[i] == address(0)) {
                _topDonators[i] = donator;
                _topDonatorAmounts[donator] = newAmount;
                return;
            }
            
            // 如果当前捐赠金额大于排行榜中某一位的金额，替换该位置
            if (newAmount > _topDonatorAmounts[_topDonators[i]]) {
                // 将后面的地址往后移
                for (uint j = 2; j > i; j--) {
                    _topDonators[j] = _topDonators[j-1];
                }
                // 插入新的捐赠者
                _topDonators[i] = donator;
                _topDonatorAmounts[donator] = newAmount;
                return;
            }
        }
    }

        // 对排行榜进行排序的内部函数
    function _sortTopDonators() internal {
        // 简单的冒泡排序
        for (uint i = 0; i < 2; i++) {
            for (uint j = 0; j < 2 - i; j++) {
                if (_topDonatorAmounts[_topDonators[j]] < _topDonatorAmounts[_topDonators[j+1]]) {
                    address temp = _topDonators[j];
                    _topDonators[j] = _topDonators[j+1];
                    _topDonators[j+1] = temp;
                }
            }
        }
    }
}