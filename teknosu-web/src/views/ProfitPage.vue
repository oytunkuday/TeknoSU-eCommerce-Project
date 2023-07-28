<template>
  <h2>PROFITS</h2>
  <div>
    <form @submit.prevent.="getProfit">
      <h2>Enter dates for profit and revenue to be calculated</h2>
      <div>
        <div>
          <label>starting date</label>
          <input type="text" placeholder="start-date" v-model="startDate" />
        </div>
      </div>
      <div>
        <div>
          <label>ending date</label>
          <input type="text" placeholder="end-date" v-model="endDate" />
        </div>
      </div>
      <div>
        <button>Calculate</button>
      </div>
    </form>
    <div v-if="dataisHere">
      <profit-box :data="data"></profit-box>
    </div>
  </div>
</template>

<script>
import ProfitBox from "@/components/ProfitBox.vue";
import getProfitBetweenDates from "../composables/getProfitBetweenDates";
export default {
  components: { ProfitBox },
  data() {
    return {
      startDate: "",
      endDate: "",
      data: {},
      dataisHere: false,
    };
  },
  methods: {
    async getProfit() {
      this.data = await getProfitBetweenDates(
        this.startDate,
        this.endDate,
        this.$store.state.userToken
      );
      this.startDate = "";
      this.endDate = "";
      this.dataisHere = true;
      console.log(this.data);
    },
  },
};
</script>

<style scoped>
h2 {
  font-family: "Josefin Sans", sans-serif;
}

input {
  margin: 5px;
}
</style>
