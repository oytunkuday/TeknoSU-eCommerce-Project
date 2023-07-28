<template>
  <!-- in vue 2.x you need wrap these buttons in a div -->
  <button class="carousel-control1 left" @click="$emit('prev')">Prev</button>
  <button class="carousel-control1 right" @click="$emit('next')">Next</button>
</template>

<script>
export default {
  emits: ["prev", "next"], // vue v3
};
</script>
<style scoped>
.carousel-control1 {
  background-color: rgba(0, 0, 0, 0.5);
  border: none;
  display: inline-block;
  position: absolute;
  height: 50px;
  width: 70px;
  top: calc(50% - 25px);
  color: #f3f3f3;
  cursor: pointer;
}
.left {
  left: 0;
}
.right {
  right: 0;
}
</style>