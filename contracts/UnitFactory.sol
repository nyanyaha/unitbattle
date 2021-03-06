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
	uint constant DEFAULT_POWER_MAX = 999;		// 生成時の上限、レベルアップで超える

	mapping (uint => address) public unitToOwner;

	// ユニット作成時のイベント
	event CreateUnit(address addr, uint unitid, string code, uint32 power);
	// バトルの勝敗判定用イベント
	event BattleResult(address addr, uint32 from_power, uint32 from_level, uint32 to_power, uint32 to_level, bool is_win);

	// 所有者判定
	modifier onlyOwnerOf(uint _unitid)
	{
		require(msg.sender == unitToOwner[_unitid]);
		_;
	}
	
	// 0〜_modulusまでの乱数取得
	function randMod(uint _nonce, uint _modulus) internal view returns(uint)
	{
		return uint(keccak256(abi.encodePacked(now, msg.sender, _nonce))) % _modulus;
	}

	// 呼び出し元アドレスが既にユニットを所持しているか
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

	// _codeからpowerをランダムにユニット生成
	function createUnit(string memory _code) public
	{
		// 所持確認
		require(!_isExistUnit());

		// 初期文字のハッシュ値から初期パワー計算
		uint rand = uint(keccak256(bytes(_code)));
		uint32 pow = uint32(rand % DEFAULT_POWER_MAX);

		// ユニット作成
		uint id = units.push(Unit(pow, 1/*level*/)) - 1;
		unitToOwner[id] = msg.sender;

		// イベントログ
		emit CreateUnit(msg.sender, id, _code, pow);
	}

	// 指定アドレスの所持ユニットID取得
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
		
		// uintで−１が使用できないのでない場合は空で返す
		uint[] memory result = new uint[](0);
		return result;
	}

	// 所持ユニット削除
	function resetUnit(uint _unitid) external onlyOwnerOf(_unitid)
	{
		// storageの削除は大変なようなのでアドレスだけクリア(Unit自体は残る)
		unitToOwner[_unitid] = address(0x0);
	}

	// 全体のユニット数取得
	function getUnitNum() external view returns(uint)
	{
		return units.length;
	}

	// 対戦開始（対戦相手ランダム）
	function battleStartRandom(uint _unitid) external onlyOwnerOf(_unitid) 
	{
		Unit storage my_unit = units[_unitid];
		Unit memory opponent;

		// 対戦相手選択、登録ユニットからランダムor簡易生成
		uint units_length = units.length;
		if( units_length <= 1 )
		{
			// 他の登録ユニットがいないので生成する
			uint32 pow = uint32(randMod((my_unit.power + my_unit.level), DEFAULT_POWER_MAX));
			opponent = Unit(pow, 1/*level*/);
		}
		else
		{
			// 乱数を自分のユニットのpowerとlevelからハッシュ値で求める
			uint rand_idx = randMod((my_unit.power + my_unit.level), units_length);
			opponent = units[rand_idx];
		}

		// イベント発行のために戦闘前の情報を残しておく
		bool is_win = false;
		uint32 power_log = my_unit.power;
		uint32 level_log = my_unit.level;

		// 戦闘（ひとまずpower値で比較）
		if( my_unit.power >= opponent.power )
		{
			// 勝利したらレベルを上げてpowerに１〜１００加算
			my_unit.power += uint32(randMod(my_unit.power, 100)) + 1; 
			my_unit.level++;
			is_win = true;
		}

		// 勝敗表示のためにイベント発行
		emit BattleResult(msg.sender, power_log, level_log, opponent.power, opponent.level, is_win);
	}

	function getUnitAddr(uint _unitid) external view returns(address)
	{
		return unitToOwner[_unitid];
	}
}
