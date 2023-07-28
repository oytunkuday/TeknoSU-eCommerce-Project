 <template>

  <div class="card">
    <div class="card-body">
      <router-link :to="{ name: 'ProductPage', params: { id: product._id } }">
        <p class="card-title">{{ product.name.substring(0, 30) }}...</p>
        <!-- <p class="card-text font-italic">
        {{ product.description.substring(0, 65) }}...
      </p> -->
        <img class="card-img" :src="product.imgs[0]" alt="Product Image" />
      </router-link>

      <div style="display: inline-block">
        <star-rating
          :inline="true"
          :star-size="20"
          :read-only="true"
          :show-rating="true"
          :rating="product.ratingsAvg.toPrecision(2)"
          :round-start-rating="false"
        ></star-rating>
      </div>
      <div v-if="product.price > product.newPrice" class="card-text">
        <span class="discount">${{ product.price }}</span>

        <span class="green">&nbsp; &nbsp; &nbsp;${{ product.newPrice }}</span>
      </div>
      <div v-else>
        <h6 class="card-text green">${{ product.newPrice }}</h6>
      </div>

      <button
        v-if="product.stocks === 0"
        class="button1"
        style="vertical-align: middle"
      >
        <span>Out of Stock</span>
      </button>
      <button
        @click="handleCart(product)"
        v-else-if="!enableRemove"
        class="button"
        style="vertical-align: middle"
      >
        <span>Add to cart </span>
      </button>
      <button
        @click="handleCart(product)"
        v-else-if="enableRemove"
        class="button"
        style="vertical-align: middle"
      >
        <span>Remove from the cart </span>
      </button>
      <span v-if="signedIn">
        <button
          v-if="a"
          @click="
            handleWishlist(product);
            a = !a;
          "
          class="wish"
        >
          🖤
        </button>
        <button
          v-else
          @click="
            handleWishlist(product);
            a = !a;
          "
          class="wish"
        >
          🤍
        </button>
        <!-- <h2>{{wishlist}}</h2> -->
      </span>
    </div>
  </div>
</template>

<script>
import { mapState, useStore } from "vuex";
import axios from "axios";
import StarRating from "vue-star-rating";

export default {
  props: ["product"],
  components: { StarRating },
  data() {
    return {
      body: {
        productId: this.product._id,
        quantity: 1,
      },
      body1: {
        productId: this.product._id,
      },
      wished: false,
    };
  },
  setup(props) {
    const store = useStore();

    if (store.state.signedIn && store.state.wishlist.products) {
      let a = false,
        i = 0,
        len = store.state.wishlist.products.length;
      store.commit("setStatusWishlistFalse");
      for (; i < len; i++) {
        console.log("plsssss");
        console.log(store.state.wishlist.products[i].productId);
        console.log(props.product._id);
        if (store.state.wishlist.products[i].productId === props.product._id) {
          console.log("matchh");
          a = true;
          store.commit("setStatusWishlistTrue");
          return { a };
        }
      }
    }
  },
  methods: {
    handleCart(product) {
      if (!this.signedIn) {
        if (this.enableRemove) {
          this.$store.commit("removeFrom", product._id);
          console.log(this.$store.state.mcProdIds);
        } else {
          this.$store.commit("addToMockCart", product._id);
        }
      } else {
        if (this.enableRemove) {
          //remove from user shopping cart
          axios
            .post(
              "http://localhost:3000/api/v1/cart/removeFromCart",
              this.body1,
              {
                headers: {
                  "Content-Type": "application/json",
                  Authorization: "Bearer " + this.userToken,
                },
              }
            )
            .then(
              (response) => console.log(response),
              console.log("removed product!"),
              this.$store.commit("removeFromTotal", product.price)
            )
            .catch((error) => console.log(error));
        } else {
          //add to user cart
          axios
            .post("http://localhost:3000/api/v1/cart/addToCart", this.body, {
              headers: {
                "Content-Type": "application/json",
                Authorization: "Bearer " + this.userToken,
              },
            })
            .then(
              (response) => console.log(response),
              console.log("added product!"),
              this.$store.commit("addToTotal", product.price),
              console.log(this.product._id)
            )
            .catch((error) => console.log(error));
        }
        console.log(this.body);
        console.log(this.userToken);
      }
    },

    handleWishlist() {
      if (!this.a) {
        (this.wished = true),
          axios
            .post(
              "http://localhost:3000/api/v1/wishlist/addToWishlist",
              this.body1,
              {
                headers: {
                  "Content-Type": "application/json",
                  Authorization: "Bearer " + this.userToken,
                },
              }
            )
            .then(
              (response) => console.log(response),
              console.log("added product to WL!"),
              this.$store.commit("setStatusWishlistTrue")
            )
            .catch((error) => console.log(error));
      } else {
        (this.wished = false),
          axios
            .post(
              "http://localhost:3000/api/v1/wishlist/removeFromWishlist",
              this.body1,
              {
                headers: {
                  "Content-Type": "application/json",
                  Authorization: "Bearer " + this.userToken,
                },
              }
            )
            .then(
              (response) => console.log(response),
              console.log("removed product from WL!"),
              this.$store.commit("setStatusWishlistFalse")
            )
            .catch((error) => console.log(error));
      }
    },
  },

  computed: {
    ...mapState(["enableRemove"]),
    ...mapState(["signedIn"]),
    ...mapState(["userToken"]),
    ...mapState(["wishlist"]),
    ...mapState(["inWishlist"]),
  },
};
</script>

<style scoped>
.embed-responsive .card-img-top {
  object-fit: cover;
}

.card img {
  object-fit: scale-down;
  overflow: hidden;
  width: 100%;
  height: 400px;
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
  height: 600px;
  padding: 3px;
  text-align: center;
  background-color: #fefbfb;
  box-sizing: border-box;
  border: 1px solid rgba(0, 0, 0, 0.125);
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
  border-radius: 1px;
  @media (min-width: 1500px) {
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

.green {
  color: rgb(36, 122, 65);
}

.discount {
  color: rgb(194, 10, 10);
  text-decoration-line: line-through;
}

.card-title:hover {
  font-weight: bold;
}
.card-text {
  font-size: 1rem;
  margin: 10px;
}
#edit-product {
  float: right;
}

.button {
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
}

.button span {
  cursor: pointer;
  display: inline-block;
  position: relative;
  transition: 0.5s;
}

.button span:after {
  content: "\00bb";
  position: absolute;
  opacity: 0;
  top: 0;
  right: -20px;
  transition: 0.5s;
}

.button:hover span {
  padding-right: 25px;
}

.button:hover span:after {
  opacity: 1;
  right: 0;
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
.wish {
  background: #b7d0ff3c;
  border: purple;
  border-radius: 100px;
  margin: 0 0;
}
.wish:hover {
  background: rgba(255, 51, 51, 0.715);
}
</style>
