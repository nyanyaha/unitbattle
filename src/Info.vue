<template>
  <div>
	<h1>召喚獣ステータス</h1>
	<p>Power:{{power}} Level:{{level}}</p>
	<button class="battle" @click="$emit('battle')">ランダム対戦</button><br><br>
	<button class="reset" @click="$emit('reset')">作り直す...</button><br>
	<h2>対戦結果：{{result}}</h2>
  </div>
</template>

<script>
export default {
  props:{
	  power: Object,
	  level: Object, 
	  result: String
  }
}
</script>

<style lang="scss">
h1 {
  font-weight: normal;
}

button.battle {
	width:130px;
	height:40px;
	font-size:16px;
}

button.reset {
	width:80px;
	height:30px;
	font-size:6px;
}
</style>
