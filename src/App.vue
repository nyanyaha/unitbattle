<template>
  <div id="app">
    <h1>{{ msg }}</h1>
    <ul>
      <li><a href="https://vuejs.org" target="_blank">Core Docs</a></li>
      <li><a href="https://forum.vuejs.org" target="_blank">Forum</a></li>
      <li><a href="https://chat.vuejs.org" target="_blank">Community Chat</a></li>
      <li><a href="https://twitter.com/vuejs" target="_blank">Twitter</a></li>
    </ul>
    <h1>好きな呪文を入力してユニットを召喚</h1>
	<input v-model="magic_word" type="text" name="" value="" placeholder="魔法の言葉を入力せよ">
	<button @click="createUnit">召喚！</button>
	<p>Power:{{power}} Level:{{level}}</p>
	<button @click="getUnit">getUnit</button>
	<button @click="getUnitIdByOwner">getUnitIdByOwner</button>
	<button @click="getUnitnum">getUnitnum</button>
	<button @click="getUnitOwner">getUnitOwner</button>
	<button @click="resetUnit">resetUnit</button>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../build/contracts/UnitFactory.json'
const UnitFactory = contract(artifacts)
export default {
  name: 'app',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
	  account : null,
	  unitid : null,
  	  magic_word : null,
	  power : 0,
	  level : 0
    }
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

				//UnitFactory.deployed()
				//	.then((instance) => {
						//console.error(instance)
						//instance.createUnit("test",{from:this.account})
				//		instance.getUnitNum()
				//			.then(() => this.msg = "create")
				//	})
			})
		})
  },

  methods: {
	  // ユニット生成
	  createUnit () {
		  if (this.magic_word == null) return

		  // 作成済み
		  if (this.unitid != null) {
			  return this.getUnit()
		  }

		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.createUnit(this.magic_word, {from:this.account})
					.then(() => {
						this.msg = "召喚成功！"
						this.getUnitIdByOwner()
							.then(() => {
								this.getUnit()
							})
					})
			})
	  },

	  // ユニット取得
	  getUnit () {
		  if (this.unitid == null) return

		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.units(this.unitid)
					.then((unit) => {
						console.log("getUnit success")
						this.power= unit.power
						this.level= unit.level
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
						}
					})
			})
	  },

	  getUnitnum () {
		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.getUnitNum({from:this.account})
					.then((num) => {
						console.log(num.toNumber())
					})
			})
	  },

	  getUnitOwner () {
		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.unitToOwner(0)
					.then((unit) => {
						console.log(unit)
					})
			})
	  },

	  resetUnit () {
		  return UnitFactory.deployed()
		  	.then((instance) => {
				instance.resetUnit(this.unitid, {from:this.account})
					.then(() => {
						this.unitid = null
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
</style>
