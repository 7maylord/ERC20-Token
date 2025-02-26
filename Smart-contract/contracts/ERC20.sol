// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract ERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address private _owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _from, uint256 _value);
    event Mint(address indexed _to, uint256 _value);
    
    error InvalidAddress();
    error InsufficientFunds();
    error InsufficientAllowance();
    error AllowanceTooLow();
    error OnlyOwnerAllowed();
    error InvalidAmount();

    modifier onlyOwner() {
        if (msg.sender != _owner) revert OnlyOwnerAllowed();
        _;
    }

    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 initialSupply_) {
        _owner = msg.sender;
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = initialSupply_ * 10 ** uint8(_decimals);
        balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function balanceOf(address _account) public view returns (uint256) {
        if (_account == address(0)) revert InvalidAddress();
        return balances[_account];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        if (_to == address(0)) revert InvalidAddress();
        if (_value <= 0) revert InvalidAmount();
        if (balances[msg.sender] < _value) revert InsufficientFunds();
        
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        if (_spender == address(0)) revert InvalidAddress();
        if (_value <= 0) revert InvalidAmount();
        if (balances[msg.sender] < _value) revert InsufficientFunds();
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        if (_to == address(0)) revert InvalidAddress();
        if (_value <= 0) revert InvalidAmount();
        if (balances[_from] < _value) revert InsufficientFunds();
        if (allowances[_from][msg.sender] < _value) revert InsufficientAllowance();

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(address _accountOwner, address _spender) public view returns (uint256) {
        if (_spender == address(0)) revert InvalidAddress();
        return allowances[_accountOwner][_spender];
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
        if (_spender == address(0)) revert InvalidAddress();
        allowances[msg.sender][_spender] += _addedValue;
        emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
        if (_spender == address(0)) revert InvalidAddress();
        if (_subtractedValue <= 0) revert InvalidAmount();
        if (allowances[msg.sender][_spender] < _subtractedValue) revert AllowanceTooLow();

        allowances[msg.sender][_spender] -= _subtractedValue;
        emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
        return true;
    }

    function burn(uint256 _value) public returns (bool) {
        if (balances[msg.sender] < _value) revert InsufficientFunds();
        if (_value <= 0) revert InvalidAmount();

        balances[msg.sender] -= _value;
        _totalSupply -= _value;
        
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    function mint(address _to, uint256 _value) public onlyOwner returns (bool) {
        if (_to == address(0)) revert InvalidAddress();
        if (_value <= 0) revert InvalidAmount();

        _totalSupply += _value;
        balances[_to] += _value;
        
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
        return true;
    }
}
