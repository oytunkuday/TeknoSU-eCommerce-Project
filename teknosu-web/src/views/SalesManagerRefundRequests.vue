<template>
  <h2>REFUND REQUESTS</h2>
  <div>
    <ul>
      <refund-request-box
        v-for="request in refundRequests"
        :key="request.orderId"
        :orderId="request.orderId"
        :productId="request.productId"
      ></refund-request-box>
    </ul>
  </div>
</template>

<script>
import getAllRefundRequests from "../composables/getAllRefundRequests";
import acceptRefund from "../composables/acceptRefund";
import rejectRefund from "../composables/rejectRefund";
import RefundRequestBox from "@/components/RefundRequestBox.vue";
export default {
  components: {
    RefundRequestBox,
  },
  data() {
    return {
      isLoading: false,
      refundRequests: [],
    };
  },
  created() {
    this.loadRequests();
  },
  methods: {
    async loadRequests() {
      this.isLoading = true;
      this.refundRequests = await getAllRefundRequests(
        this.$store.state.userToken
      );
      console.log(this.refundRequests);
      this.isLoading = false;
    },
  },
};
</script>

<style>
ul {
  list-style: none;
}
h2 {
  font-family: "Josefin Sans", sans-serif;
}
</style>
