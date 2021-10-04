//SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

import "./IERC20.sol";
import "./ILendingPool.sol";

contract Lottery {
	mapping(address => bool) public hasTicket;
	address[] ticketPurchasers;
	uint public drawing;
	uint ticketPrice = 100e18;

	ILendingPool pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
	IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3); 
	IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

	constructor() {
		drawing = block.number + 1 weeks;
	}

	function purchase() external {
		require(!hasTicket[msg.sender]);

		dai.transferFrom(msg.sender, address(this), ticketPrice);

		dai.approve(address(pool), ticketPrice);
		pool.deposit(address(dai), ticketPrice, address(this), 0);

		hasTicket[msg.sender] = true;
		ticketPurchasers.push(msg.sender);
	}

	event Winner(address);

	function pickWinner() external {
		require(block.timestamp >= drawing);

		uint totalPurchasers = ticketPurchasers.length;
		uint winnerIdx = uint(blockhash(block.number - 1)) % totalPurchasers;
		address winner = ticketPurchasers[winnerIdx];

		emit Winner(winner);

		uint balance = aDai.balanceOf(address(this));
		aDai.approve(address(pool), balance);
		
		for(uint i = 0; i < ticketPurchasers.length; i++) {
			pool.withdraw(address(dai), ticketPrice, ticketPurchasers[i]);
		}

		uint interest = aDai.balanceOf(address(this));
		pool.withdraw(address(dai), interest, winner);
	}
}
