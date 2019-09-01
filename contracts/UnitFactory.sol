pragma solidity ^0.5.8;

// ユニット生成
contract UnitFactory 
{
	// ユニット
	struct Unit
	{
		uint32 power;
		uint32 level;
	}

	Unit[] public units;
	uint constant DEFAULT_POWER_MAX = 999;

	mapping (uint => address) public unitToOwner;


	modifier onlyOwnerOf(uint _unitid)
	{
		require(msg.sender == unitToOwner[_unitid]);
		_;
	}

	function _isExistUnit() internal view returns(bool)
	{
		for( uint i = 0; i < units.length; ++i )
		{
			if( unitToOwner[i] == msg.sender )
			{
				return true;
			}
		}

		return false;
	}

	// ユニット生成
	function createUnit(string memory _code) public
	{
		// 所持確認
		require(!_isExistUnit());

		// 初期文字のハッシュ値から初期パワー計算
		uint rand = uint(keccak256(bytes(_code)));
		uint32 pow = uint32(rand % DEFAULT_POWER_MAX);

		// ユニット作成
		uint id = units.push(Unit(pow, 1/*level*/));
		unitToOwner[id] = msg.sender;
	}

	// 所持ユニットID取得
	function getUnitIdByOwner(address _owner) external view returns(uint[] memory)
	{
		for( uint i = 0; i < units.length; ++i )
		{
			if( unitToOwner[i] == _owner )
			{
				uint[] memory result = new uint[](1);
				result[0] = i;
				return result;
			}
		}
		
		uint[] memory result = new uint[](0);
		return result;
	}

	// 所持ユニット削除
	function resetUnit(uint _unitid) external onlyOwnerOf(_unitid)
	{
		// storageの削除は大変なようなのでアドレスだけクリア(Unit自体は残る)
		unitToOwner[_unitid] = address(0x0);
	}

	// ユニット数取得
	function getUnitNum() external returns(uint)
	{
		return units.length;
	}

	function getUnitAddr(uint _unitid) external returns(address)
	{
		return unitToOwner[_unitid];
	}
}
