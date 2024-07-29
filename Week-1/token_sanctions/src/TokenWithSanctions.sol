// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TokenWithSanctions is ERC20, Ownable {

    mapping(address => bool) private isBlackListed;
 
    event Blacklisted(address indexed account);
    event UnBlacklisted(address account);

    constructor(uint256 totalSupply) ERC20("TokenWithSactions", "TWS") Ownable(msg.sender) {
    }

     /**
     * @notice Checks if account is blacklisted.
     * @param _account The address to check.
     * @return True if the account is blacklisted, false if the account is not blacklisted.
     */
    function isBlacklisted(address _account) internal
        virtual
        view
        returns (bool) {
            return isBlackListed[_account];
        }

    /**
     * @notice Adds account to blacklist.
     * @param _account The address to blacklist.
     */
    function blacklist(address _account) external onlyOwner {
        require(!isBlackListed[_account], "account already blacklisted");
        isBlackListed[_account] = true;
        emit Blacklisted(_account);
    }

    /**
     * @notice Removes account from blacklist.
     * @param _account The address to remove from the blacklist.
     */
    function unBlacklist(address _account) external onlyOwner {
        require(isBlackListed[_account], "account already whitelisted");
        isBlackListed[_account] = false;
        emit UnBlacklisted(_account);
    }

    /**
     * Override the _update function in ERC20, to check if to or from address is in blacklist
     * @param from The address to transfer tokens from
     * @param to The address to transfer tokens to
     * @param value the amount of tokensto be transferred
     */
    function _update(address from, address to, uint256 value) internal virtual override {

        require(!isBlackListed[to] && !isBlackListed[from], "Blacklisted");
        super._update(from, to, value);
    }

    //function to destroyblackfunds
}
