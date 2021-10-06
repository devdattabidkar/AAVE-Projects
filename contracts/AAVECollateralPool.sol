// SPDX-License-Ientifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import "./interfaces/ILendingPool.sol";

contract CollateralGroup {
	ILendingPool pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
	IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
	IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3); 

	uint depositAmount = 10000e18;
	address[] members;

	constructor(address[] memory _members) {
		members = _members;

		for(uint i = 0; i < _members.length; i++) {
			dai.transferFrom(members[i], address(this), depositAmount);
		}

		uint totalDeposit = _members.length * depositAmount;
		dai.approve(address(pool), totalDeposit);
		pool.deposit(address(dai), totalDeposit, address(this), 0);
	}

	function isMember(address _addr) private returns(bool) {
		for(uint i = 0; i < members.length; i++) {
			if(members[i] == _addr) {
				return true;
			}
		}
		return false;
	}

	function withdraw() external {
		require(isMember(msg.sender));
		uint totalBalance = aDai.balanceOf(address(this));
		uint share = totalBalance / members.length;

		aDai.approve(address(pool), totalBalance);
		
		for(uint i = 0; i < members.length; i++) {
			pool.withdraw(address(dai), share, members[i]);
		}
	}

	function borrow(address asset, uint amount) external {
		require(isMember(msg.sender));
		pool.borrow(asset, amount, 1, 0, address(this));

		(,,,,,uint healthFactor) = pool.getUserAccountData(address(this));
		require(healthFactor > 2e18);

		IERC20(asset).transfer(msg.sender, amount);
	}

	function repay(address asset, uint amount) external {
		IERC20(asset).transferFrom(msg.sender, address(this), amount);

		dai.approve(address(pool), amount);

		pool.repay(asset, amount, 1, address(this));
	}
}