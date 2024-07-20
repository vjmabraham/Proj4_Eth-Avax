// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    mapping(string => uint256) public itemCost;
    mapping(address => string[]) public playerItem;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        itemCost["Sword"] = 25;
        itemCost["Wand"] = 20;
        itemCost["Shield"] = 15;
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }

    function transferToken(address destination, uint256 amount) external {
        uint256 balance = balanceOf(msg.sender);
        require(balance >= amount, "You do not have enough Degen Tokens");
        _transfer(msg.sender, destination, amount);
    }

    function redeemItem(string memory item) external  {
        uint256 cost = itemCost[item];
        require(cost > 0, "Invalid item");
        uint256 balance = balanceOf(msg.sender);
        require(balance >= cost, "You do not have enough Degen Tokens");
        _burn(msg.sender, cost);
        playerItem[msg.sender].push(item);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burn(uint256 amount) external {
        uint256 balance = balanceOf(msg.sender);
        require(balance >= amount, "You do not have enough Degen Tokens");
        _burn(msg.sender, amount);
    }

    function viewInventory() public view returns (string[] memory) {
        return playerItem[msg.sender];
    }
}