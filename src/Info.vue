<template>
  <div>
	<h1>召喚獣ステータス</h1>
	<p>Power:{{power}} Level:{{level}}</p>
  </div>
</template>

<script>
export default {
  props:{
	  power: Object,
	  level: Object 
  }
}
</script>

<style lang="scss">
h1 {
  font-weight: normal;
}
</style>
