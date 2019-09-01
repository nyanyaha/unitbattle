pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/UnitFactory.sol";


contract TestUnitFactory
{
	UnitFactory unitFactory = UnitFactory(DeployedAddresses.UnitFactory());

	function testcriateUnit() public {
		unitFactory.createUnit("test");

		uint[] memory unitid = unitFactory.getUnitIdByOwner(msg.sender);

		uint result = 99999;
		if(unitid.length > 0)
		{
			result = unitid[0];
		}

		//result = uint(unitFactory.getUnitAddr(0));
		//result = unitFactory.getUnitNum();

		Assert.equal(100, result, "unit create test.");
	}

}
