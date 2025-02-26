# ERC-20 Token Smart Contract

## Overview
This repository contains an ERC-20 token implementation written in Solidity. The contract provides standard functionalities such as token transfers, approvals, allowances, minting, and burning, while incorporating additional security checks and error handling.

- **Contract Address**: 0x94080B43fA5Fc8C6Ffd3306c6D0541D80a870E98
- **Token Address**: https://sepolia-blockscout.lisk.com/address/0x94080B43fA5Fc8C6Ffd3306c6D0541D80a870E98#code

## Features
- **Standard ERC-20 Functions**
  - `transfer()`
  - `approve()`
  - `transferFrom()`
  - `balanceOf()`
  - `allowance()`
  - `increaseAllowance()`
  - `decreaseAllowance()`
- **Minting & Burning**
  - Only the owner can mint new tokens.
  - Any user can burn their own tokens.
- **Error Handling using Custom Errors**
  - More gas-efficient than using `require` strings.
- **Access Control**
  - Only the contract owner can mint tokens.
- **Security Features**
  - Prevents invalid addresses (zero address checks).
  - Ensures sufficient balance and allowance checks.
  - Reverts on invalid amounts.

## Installation & Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/7maylord/ERC20-Token.git
   cd ERC20-Token
   cd Smart-contract
   ```
2. Install dependencies:
   ```sh
   yarn install
   ```
3. Compile the smart contracts:
   ```sh
   npx hardhat compile
   ```
   
## Contract Details

### Constructor
The constructor initializes the token with the following parameters:
```solidity
constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 initialSupply_)
```
- `name_`: Token name
- `symbol_`: Token symbol
- `decimals_`: Number of decimal places
- `initialSupply_`: Initial token supply (scaled by `10^decimals`)

### State Variables
- `_name`: Token name
- `_symbol`: Token symbol
- `_decimals`: Token decimal places
- `_owner`: Address of the contract owner
- `_totalSupply`: Total token supply
- `balances`: Mapping of account balances
- `allowances`: Mapping of allowances per account

### Events
- `Transfer(address indexed from, address indexed to, uint256 value)`
- `Approval(address indexed owner, address indexed spender, uint256 value)`
- `Burn(address indexed from, uint256 value)`
- `Mint(address indexed to, uint256 value)`

## Functions

### Public Functions
#### `name()`
Returns the name of the token.
#### `symbol()`
Returns the token symbol.
#### `decimals()`
Returns the number of decimals the token uses.
#### `totalSupply()`
Returns the total supply of the token.
#### `owner()`
Returns the owner of the contract.
#### `balanceOf(address _account)`
Returns the balance of a given account.
#### `allowance(address _accountOwner, address _spender)`
Returns the amount an account is allowed to spend on behalf of another account.
#### `transfer(address _to, uint256 _value)`
Transfers `_value` tokens from the sender to `_to`. Reverts on insufficient balance or invalid address.
#### `approve(address _spender, uint256 _value)`
Approves `_spender` to spend `_value` tokens on behalf of the sender.
#### `transferFrom(address _from, address _to, uint256 _value)`
Transfers `_value` tokens from `_from` to `_to`, using the allowance mechanism.
#### `increaseAllowance(address _spender, uint256 _addedValue)`
Increases the allowance for `_spender`.
#### `decreaseAllowance(address _spender, uint256 _subtractedValue)`
Decreases the allowance for `_spender`.
#### `burn(uint256 _value)`
Burns `_value` tokens from the sender’s balance.
#### `mint(address _to, uint256 _value)` (Only Owner)
Mints `_value` tokens and assigns them to `_to`.

## Deployment
To deploy the contract, use Hardhat and ensure you have some lisk-sepolia:
```solidity
npx hardhat run scripts/deploy.ts --network lisk_sepolia
```

## License
This project is licensed under the **UNLICENSED** license.


## Author
Developed by **[MayLord](https://github.com/7maylord)**. Feel free to contribute and improve the project!

---

Happy coding! 🚀
