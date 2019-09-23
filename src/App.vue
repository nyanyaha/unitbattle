<template>
  <div id="app">
  	<component :is="current_page" @create="createUnit" @battle="battle" @reset="resetUnit" :power="power" :level="level" :result="result"></component>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../build/contracts/UnitFactory.json'
const UnitFactory = contract(artifacts)
import CreatePage from './Create.vue'
import InfoPage from './Info.vue'
export default {
  name: 'app',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
	  account : null,
	  unitid : null,
  	  magic_word : null,
	  power : 0,
	  level : 0,
	  result : null,
	  current_page : 'CreatePage',
    }
  },
  components: {
	  CreatePage,
	  InfoPage
  },

  // 初期化処理
  created() {
	// web3が有効か確認する
	if (typeof web3 !== 'undefined') {
		web3 = new Web3(web3.currentProvider)
	} else {
		console.warn("No web3 detected. Falling back to http://127.0.0.1:7545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")
		web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'))
	}

	//await ethereum.enable()
	web3.currentProvider.enable()
		.then(() => {
			UnitFactory.setProvider(web3.currentProvider)
			// 使用するアカウント情報取得
			web3.eth.getAccounts((error, accounts) => {
				if (error != null) {
					console.error(error)
					this.message = 'There was an error fetching your accounts. Do you have Metamask, Mist installed or an Ethereum node running? If not, you might want to look into that.'
					return
				}
				if (accounts.length === 0) {
					console.error("accounts none")
					this.message = 'Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.'
					return
				}
				this.account = accounts[0]
				web3.eth.defaultAccount = this.account

				// 作成済みのユニットがあるか確認
				this.getUnitIdByOwner()
			})
		})
  },

  // contract呼び出し関連
  methods: {
	  // ユニット生成
	  createUnit (magic_word) {
		  if (magic_word == null) return

		  // 作成済み
		  if (this.unitid != null) {
			  return this.displayUnit()
		  }

		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.createUnit(magic_word, {from:this.account})
					.then(() => {
						console.log(magic_word)
						this.msg = "召喚成功！"
						this.getUnitIdByOwner()
							.then(() => {
								this.displayUnit()
							})
					})
			})
	  },

	  // ユニット描画
	  displayUnit () {
		  if (this.unitid == null) return

		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.units(this.unitid)
					.then((unit) => {
						console.log("display success")
						if (this.level != 0)
						{
							this.result = (this.level < unit.level) ? "勝利！" : "敗北..."
						}
						this.power = unit.power
						this.level = unit.level
					})
			})
	  },

	  // アドレスの保持しているユニットのIDを取得
	  getUnitIdByOwner () {
		  return UnitFactory.deployed()
		  	.then((instance) => {
				console.log(this.account)
				instance.getUnitIdByOwner(this.account, {from:this.account})
					.then((ids) => {
						if (ids.length > 0) {
							console.log(ids[0].toNumber())
							this.unitid = ids[0].toNumber() 
							this.current_page = 'InfoPage'
							// ユニット取得（描画更新）
							this.displayUnit()
						}
					})
			})
	  },

	  // 対戦
	  battle() {
		if (this.unitid == null) return

		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.battleStartRandom(this.unitid, {from:this.account})
					.then(() => {
						console.log("battle success")
						// ユニット取得（描画更新）
						this.displayUnit()
					})
			})
	  },

	  // ユニットの削除
	  resetUnit () {
		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.resetUnit(this.unitid, {from:this.account})
					.then(() => {
						this.unitid = null
						this.power = 0
						this.level = 0
						this.result = null
						this.current_page = 'CreatePage' 
						console.log("reset success")
					})
			})
	  }
  }
}

</script>

<style lang="scss">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}

input {
	width:300px;
	height:30px;
	font-size:16px;
}

button.create {
	width:65px;
	height:30px;
	font-size:16px;
}
</style>
