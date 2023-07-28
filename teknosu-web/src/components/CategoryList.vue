<template>
  <div class="column" v-for="Category in Categories" :key="Category._id">
      <CategoryBox :Category="Category" />
  </div>
</template>

<script>
import CategoryBox from './CategoryBox.vue'

export default {
    props: ['Categories'],
    components: {CategoryBox}
}
</script>

<style scoped>
.column {
  float: right;
  width: 50%;
  padding: 10px 10px;
}

.row {
    margin: 0 -1px;
    }

.row:after {
  content: "";
  display: table;
  clear: both;
}
</style>