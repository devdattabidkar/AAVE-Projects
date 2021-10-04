//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import "./interfaces/ILendingPool.sol";

contract Lottery {
	// the timestamp of the drawing event
	uint public drawing;
	// the price of the ticket in DAI (100 DAI)
	uint ticketPrice = 100e18;

	ILendingPool pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
	IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3); 
	IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

	constructor() {
        drawing = block.timestamp + 1 weeks;
	}

	function purchase() external {
        
	}

	event Winner(address);

	function pickWinner() external {
        
	}
}
