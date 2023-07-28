<template>
  <div class="card">
    <div class="card-body">
      <p class="card-title">Total profit:{{ totalprof }}</p>
      <p class="card-title">Total revenue: {{ totalrev }}</p>
      <div class="card-body">
        <DxChart
          id="chart"
          :data-source="dictionary"
          palette="Harmony Light"
          title="Profits"
        >
          <DxCommonSeriesSettings argument-field="date" />
          <DxSeries
            name="profit"
            value-field="profit"
            axis="frequency"
            type="bar"
            color="#fac29a"
          />

          <DxArgumentAxis>
            <DxLabel overlapping-behavior="stagger" />
          </DxArgumentAxis>

          <DxValueAxis :tick-interval="10000" name="frequency" position="left" />


          <DxTooltip
            :enabled="true"
            :shared="true"
            :customize-tooltip="customizeTooltip"
          />

          <DxLegend :visible="false" />
        </DxChart>
      </div>
    </div>
  </div>
  <div>
    <button @click="printdict">click</button>
  </div>
</template>

<script>
import DxChart, {
  DxArgumentAxis,
  DxCommonSeriesSettings,
  DxLabel,
  DxLegend,
  DxSeries,
  DxTooltip,
  DxValueAxis,
  DxConstantLine,
} from "devextreme-vue/chart";

export default {
  props: ["data"],
  components: {
    DxChart,
    DxArgumentAxis,
    DxCommonSeriesSettings,
    DxLabel,
    DxLegend,
    DxSeries,
    DxTooltip,
    DxValueAxis,
    DxConstantLine,
  },
  created() {
    this.totalrev = this.data.totalRevenue;
    this.totalprof = this.data.totalprofit;
    const formatted = [];
    for (var key in this.data.dict) {
      formatted.push({
        date: key,
        profit: this.data.dict[key],
      });
    }
    this.dictionary = formatted;
    console.log(this.totalprof);
    console.log(this.totalrev);
  },
  data() {
    return {
      totalrev: 0,
      totalprof: 0,
      dictionary: null,
    };
  },
  methods: {
    printdict() {
      console.log(this.dictionary);
    },
  },
};
</script>
<style scoped>
.embed-responsive .card-img-top {
  object-fit: cover;
}

.card img {
  object-fit: scale-down;
  overflow: scroll;
  width: 50%;
  height: 200px;
  padding: 10px;
  margin: -2px;
  border-radius: 10px;
}
.card img:hover {
  padding: 5px;
}

a {
  text-decoration: none;
}
.card {
  padding: 1px;
  margin: auto;
  width: 93%;
  text-align: center;
  background-color: #fefbfb;
  box-sizing: border-box;
  overflow: auto;
  border: 1px solid rgba(0, 0, 0, 0.125);
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
  border-radius: 30px;

  margin-bottom: 20px;
  @media (min-width: 150px) {
    max-width: 300px;
  }
}

.card:hover {
  box-shadow: 0 10px 15px 0 rgba(69, 51, 69, 0.32);
}
.card-title {
  color: #484848;
  font-size: 1.1rem;
  font-weight: 400;
}

.card-tit {
  text-align: right;
  color: #484848;
  font-size: 1.1rem;
  font-weight: 400;
}
.green {
  color: rgb(36, 122, 65);
}

.red {
  color: rgb(230, 60, 26);
}
.card-text {
  font-size: 1rem;
  margin: 10px;
}
#edit-product {
  float: right;
}

.buttonred {
  background: rgb(156, 13, 13);
  border: 0;
  width: 30%;
  padding: 10px 20px;
  margin-top: 20px;
  color: white;
  border-radius: 10px;
}
.buttonred:hover {
  cursor: pointer;
}

.buttongreen {
  background: rgb(24, 149, 10);
  border: 0;
  width: 30%;
  padding: 10px 20px;
  margin-top: 20px;
  color: white;
  border-radius: 10px;
}
.buttongreen:hover {
  cursor: pointer;
}

.button1 {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #ffffff;
  text-align: center;
  font-size: 10px;
  padding: 10px;
  width: 60%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
  cursor: not-allowed;
}

.myButton {
  box-shadow: inset 0px 39px 0px -24px #e67a73;
  background-color: #e4685d;
  border-radius: 4px;
  border: 1px solid #ffffff;
  display: inline-block;
  cursor: pointer;
  color: #ffffff;
  font-family: Arial;
  font-size: 15px;
  padding: 6px 15px;
  text-decoration: none;
  text-shadow: 0px 1px 0px #b23e35;
  float: inline-start;
}
.myButton:hover {
  background-color: #eb675e;
}
.myButton:active {
  position: relative;
  top: 1px;
}
.modal1 {
  width: 50%;
  color: white;
  padding: 20px;
  margin: 10px auto;
  background: rgb(0, 0, 0);
  border-radius: 8px;
  position: fixed;
  z-index: 999;
  top: 20%;
  left: 25%;
  align-content: center;
  text-align: center;
  font-weight: bold;
  font-size: 20px;
}

.modal1 p {
  font-style: normal;
}

.modal1 .actions {
  font-style: oblique;
  text-align: center;
  margin: 20px 0 10px 0;
  color: rgb(0, 0, 0);
  padding: 8px;
  border: 1px solid rgb(223, 181, 181);
  border-radius: 4px;
  text-decoration: none;
  margin: 10px;
  width: 50%;
  background-color: rgb(255, 255, 255);
}

.modal1 .actions:hover {
  text-decoration: aqua;
  border: 2px solid rgb(0, 0, 0);
}
.errorMsg {
  color: red;
}
.overlay {
  position: fixed;
  left: 0;
  top: 0;
  width: 100vw;
  height: 100vh;
  display: block;
  background-color: #000;
  opacity: 0;
}
</style>
