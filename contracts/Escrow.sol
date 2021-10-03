//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import "./interfaces/ILendingPool.sol";

contract Escrow {
    address arbiter;
    address depositor;
    address beneficiary;

    uint256 initialDeposit;

    /*ILendingPool pool;
    IERC20 aDai;
    IERC20 dai;*/

    // the mainnet AAVE v2 lending pool
    ILendingPool pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    // aave interest bearing DAI
    IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3);
    // the DAI stablecoin 
    IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    constructor(address _arbiter, address _beneficiary, uint _amount) {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;

        initialDeposit = _amount;

        dai.transferFrom(msg.sender, address(this), _amount);
        dai.approve(address(pool), _amount);

        pool.deposit(address(dai), _amount, address(this), 0);
    }

    function approve() external view {
        require(msg.sender == arbiter);
        
    }
}