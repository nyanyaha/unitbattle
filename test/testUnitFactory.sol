pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/UnitFactory.sol";


contract TestUnitFactory
{
	UnitFactory unitFactory = UnitFactory(DeployedAddresses.UnitFactory());

	function errorPrint(int _code, string memory _str) internal {
			Assert.equal(0, _code, _str);
	}

	function resetUnit() internal returns(int) {
		uint[] memory unitids = unitFactory.getUnitIdByOwner(address(this));
		if( unitids.length <= 0 )
		{
			return 0;
		}

		unitFactory.resetUnit(unitids[0]);
		return 1;
	}

	function testcriateUnit() public {
		// 所持ユニットが残っているかもしれないので初期化
		resetUnit();

		// 作成->削除->作成で複数ユニット生成
		unitFactory.createUnit("test");
		int r = resetUnit();
		if( r <= 0 )
		{
			errorPrint(-1, "unit create error.");
			return;
		}

		// 2体目は削除しないのでrestUnitを呼ばずに直接unitidを取得
		unitFactory.createUnit("test2");
		uint[] memory unitids = unitFactory.getUnitIdByOwner(address(this));
		if( unitids.length <= 0 )
		{
			errorPrint(-2, "unit create error.");
			return;
		}

		uint unitid = unitids[0];

		// 戦闘
		unitFactory.battleStartRandom(unitid);

		// 終わったらイベントを確認したいのでAssertで止める
		uint result = 1;
		Assert.equal(0, result, "finish");
	}

}
