// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract MayToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed to, uint256 value);
    
    error InvalidAddress();
    error InsufficientFunds();
    error InsufficientAllowance();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint8(decimals);
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();
        if(balanceOf[msg.sender] <= _value) revert InsufficientFunds();
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        if(_spender == address(0)) revert InvalidAddress();
        if(balanceOf[msg.sender] < _value) revert InsufficientFunds();
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();
        if(balanceOf[_from] <= _value) revert InsufficientFunds();
        if(allowance[_from][msg.sender] <= _value) revert InsufficientAllowance();

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        if(_spender == address(0)) revert InvalidAddress();
        return allowance[_owner][_spender];
    }

   
    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool success) {
        if(_spender == address(0)) revert InvalidAddress();
        allowance[msg.sender][_spender] += _addedValue;
        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool success) {
        if(_spender == address(0)) revert InvalidAddress();
        require(allowance[msg.sender][_spender] >= _subtractedValue, "Allowance too low");

        allowance[msg.sender][_spender] -= _subtractedValue;

        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        if(balanceOf[msg.sender] <= _value) revert InsufficientFunds();

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        emit Transfer(msg.sender, address(0), _value);
        emit Burn(msg.sender, _value);
        return true;
    }

    function mint(address _to, uint256 _value) public onlyOwner returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();

        totalSupply += _value;
        balanceOf[_to] += _value;
        
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
        return true;
    }
}
