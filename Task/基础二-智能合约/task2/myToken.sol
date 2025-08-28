// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
提示：
使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包
*/
contract myToken {

    address payable private _owner;

    mapping (address => uint256) private _balance;

    mapping (address => mapping (address => uint256)) private _allowance;

    uint256 private _supplies;

    uint256 public constant MAX_SUPPLY = 1000000000 * 10**18; // 最大供应量 10 亿（假设代币有18位小数）

    event Approve(address indexed owner, address indexed spender, uint256 value);

    event Transfer(address indexed owner, address indexed recipient, uint256 amount);

    event TransferFrom(address indexed from, address indexed to, uint256 amount);

    event Mint(address indexed addr, uint256 amount, string name, string symbol);

    constructor(){
        _owner = payable (msg.sender);
    }

   // 代币名称和符号
    string public _name;

    string public _symbol;

    modifier onlyOwner(){
        require(msg.sender == _owner, "you aren't contract owner");
        _;
    }

    // 增发代币
    function mint(address addr, uint256 amount, string memory name, string memory symbol) public onlyOwner {
        require(addr != address(0), "address is 0");
        require(amount > 0, "amount must more than 0");
        require(bytes(name).length > 0 && bytes(symbol).length > 0, "name must not empty");
        // 校验是否超过最大供应量
        uint newSupplies = _supplies + amount;
        require(newSupplies <= MAX_SUPPLY, "Exceed the maximum supply");

        _supplies = newSupplies;
        _balance[addr] += amount;
        _name = name;
        _symbol = symbol;
        emit Mint(addr, amount, name, symbol);
    }

    // 查询账户余额
    function getBalance(address account) public view returns (uint256) {
        return _balance[account];
    }


    // 转账
    function transfer(address recipient, uint256 amount) public {
        // 校验金额
        require(recipient != address(0), "address is 0");
        require(_balance[msg.sender] >= amount, "Insufficient balance");
        // 执行转账操作
        _balance[msg.sender] -= amount;
        _balance[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    // 授权
    function approve(address spender, uint256 amount) public returns (bool) {
        // 授权spender地址可以支配amount数量的代币
        require(spender != address(0), "address is 0");
        require(_balance[msg.sender] >= amount,  "Insufficient balance");
        _allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    // 代扣转账
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        // 校验授权金额
        require(_allowance[from][msg.sender] >= amount, "balance must more than amount");
        // 校验余额
        require(_balance[from] >= amount, "Insufficient balance");
        // 扣除授权金额
        _allowance[from][msg.sender] -= amount;
        _balance[from] -= amount;
        _balance[to] += amount;
        emit TransferFrom(from, to, amount);
        return true;
    }
}