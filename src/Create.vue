<template>
  <div>
    <h1>好きな呪文を入力してユニットを召喚</h1>
	<input v-model="magic_word" type="text" name="" value="" placeholder="魔法の言葉を入力せよ">
	<button class="create" @click="$emit('create', magic_word)">召喚！</button>
  </div>
</template>


<script>
export default {
  data () {
    return {
  	  magic_word : null,
	}
  }
}
</script>

<style lang="scss">

h1 {
  font-weight: normal;
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
