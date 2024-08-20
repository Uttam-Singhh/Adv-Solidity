// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract BondingCurveToken is ERC20, Ownable {

    uint256 public initial_price = 0.01 ether;
    uint256 public k = 0.1 ether;
    uint256 public reserve;

    event TokenPurchased(address indexed buyer, uint256 amount, uint256 cost);
    event TokenSold(address indexed seller, uint256 amount, uint256 revenue);


    constructor() Ownable(msg.sender) ERC20("BondedToken", "BCT"){}

    function buy(uint256 amount) external payable{
        require(msg.value >= calculatePrice(amount), "Insufficient Ether sent");
        _mint(msg.sender, amount);
        reserve +=  msg.value;

        emit TokenPurchased(msg.sender, amount, msg.value);
    }

    function sell(uint256 amount) public {
        uint256 price = calculatePrice(amount);
        require(reserve >= price, "Not enough Ether in reserve"); 

        _burn(msg.sender, amount);
        reserve -= price;
       (bool success, ) = msg.sender.call{value: price}("");
       require(success, "Transfer Failed");
       emit TokenSold(msg.sender, amount, price);    
    }
    

    function calculatePrice(uint256 amount) public view returns (uint256 price) {
        return initial_price + k * (totalSupply() + amount);
        
    }

}