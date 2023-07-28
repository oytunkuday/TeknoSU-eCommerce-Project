import { mount, createLocalVue } from "@vue/test-utils";
import CategoryBox from "../src/components/CategoryBox.vue";
import { mapState, createStore } from "vuex";
import Vuex from "vuex";
import ProductBox from "../src/components/ProductBox.vue";
import ProductBoxOrder from "../src/components/ProductBoxOrder.vue";
import OrderBox from "../src/components/OrderBox.vue";
import MyProfile from "../src/views/MyProfile.vue";
import HomeView from "../src/views/HomeView.vue";
import {
  getCategoryPropsData,
  getProductPropsData,
  getSoldoutProductPropsData,
  getProductOrderData,
  getOrderBoxData,
} from "./test-utils";

describe("Components unit tests: ", () => {
  let storemock;
  beforeEach(() => {
    storemock = createStore({
      state() {
        return {
          productCount: 0,
          mcProdIds: [],
          userToken: "",
          userId: "",
          user: {},
          cartProducts: [],
          signedIn: false,
          enableRemove: false,
          cartTotal: 0,
          actualCart: [],
          currentProduct: {
            quantity: 0,
            productId: "",
            description: "",
            price: 0,
          },
          completeOrderList: [],
          signupResponse: {
            data: {
              user: {
                _id: "629d1573e4c4503f44606e3d",
              },
            },
          },
          wishlist: {},
          inWishlist: false,
          totalActual: 0,
        };
      },
      mutations: {
        addToMockCart(state, prID) {
          state.productCount++;
          state.mcProdIds.push(prID);
        },
        removeFrom(state, prID) {
          state.productCount--;
          state.mcProdIds.pop(prID);
        },
        handleToken(state, token) {
          state.userToken = token;
        },
        handleRemove(state) {
          state.enableRemove = true;
        },
        handleAdd(state) {
          state.enableRemove = false;
        },
        userIn(state) {
          state.signedIn = true;
        },
        setUser(state, userInf) {
          state.user = userInf;
        },
        setUserID(state, _id) {
          state.userId = _id;
        },
        setUserProducts(state, products) {
          state.cartProducts = products;
        },
        addToTotal(state, pricing) {
          state.cartTotal += pricing;
        },
        removeFromTotal(state, pricing) {
          state.cartTotal -= pricing;
        },
        setTotal(state, myTotal) {
          state.cartTotal = myTotal;
        },
        addToActualCart(state, prod) {
          state.actualCart = prod;
        },
        addToOrderList(state, prod) {
          state.completeOrderList.push(prod);
        },
        currentQ(state, q) {
          state.currentProduct.quantity = q;
        },
        currentId(state, _id) {
          state.currentProduct.productId = _id;
        },
        currentDes(state, des) {
          state.currentProduct.description = des;
        },
        currentP(state, pr) {
          state.currentProduct.price = pr;
        },
        setSignUp(state, su) {
          state.signupResponse = su;
        },
        setWishlist(state, wL) {
          state.wishlist = wL;
        },
        setStatusWishlistTrue(state) {
          state.inWishlist = true;
        },
        setStatusWishlistFalse(state) {
          state.inWishlist = false;
        },
        setTotal(state, total) {
          state.totalActual = total;
        },
      },
    });
  });

  test("CategoryBox is a Vue instance", () => {
    const wrapper = mount(CategoryBox, {
      propsData: getCategoryPropsData(),
      global: { plugins: [storemock] },
    });

    expect(wrapper).toBeTruthy();
  });
  test("CategoryBox renders the category name", () => {
    const taskName = "Phones";

    const wrapper = mount(CategoryBox, {
      propsData: getCategoryPropsData(),
      global: { plugins: [storemock] },
    });

    expect(wrapper.html()).toContain(taskName);
  });
  test("CategoryBox renders the category photo", () => {
    const wrapper = mount(CategoryBox, {
      propsData: getCategoryPropsData(),
      global: { plugins: [storemock] },
    });

    const imageof = wrapper.findAll(".card img");
    expect(imageof.length).toBe(1);
  });
  test("ProductBox is a Vue instance", () => {
    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });

    expect(wrapper).toBeTruthy();
  });
  test("ProductBox renders the product name", () => {
    const taskName = "Macbook Pro 16inch 16GB RAM 512GB SSD";

    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });

    expect(wrapper.html()).toContain(taskName.substring(0, 30));
  });
  test("ProductBox renders the product photo", () => {
    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });

    const imageof = wrapper.findAll(".card-img");
    expect(imageof.length).toBe(1);
  });
  test("ProductBox renders the product discounted price", () => {
    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });
    var a = 12800;
    expect(wrapper.html()).toContain("$" + a.toString());
  });
  test("ProductBox renders the product not discounted price", () => {
    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });
    var a = 16000;
    expect(wrapper.html()).toContain("$" + a.toString());
  });
  test("ProductBox renders the avg rating", () => {
    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });
    var a = 3.0;
    expect(wrapper.html()).toContain(a.toString());
  });
  test("calls addToCart when the button is clicked", async () => {
    const handleCart = jest.spyOn(ProductBox.methods, "handleCart");
    const wrapper = mount(ProductBox, {
      propsData: getProductPropsData(),
      global: { plugins: [storemock] },
    });

    await wrapper.vm.$nextTick();
    wrapper.find(".button").trigger("click");

    expect(handleCart).toHaveBeenCalled();
  });
  test("ProductBox renders the out of stock button", () => {
    const taskName = "Out of Stock";
    const wrapper = mount(ProductBox, {
      propsData: getSoldoutProductPropsData(),
      global: { plugins: [storemock] },
    });
    expect(wrapper.html()).toContain(taskName);
  });
  test("ProductBox in Order renders the product price", () => {
    const wrapper = mount(ProductBoxOrder, {
      propsData: getProductOrderData(),
      global: { plugins: [storemock] },
    });
    var a = 16000;
    expect(wrapper.html()).toContain("$" + a.toString());
  });
  test("ProductBox in Order renders the product quantity", () => {
    const wrapper = mount(ProductBoxOrder, {
      propsData: getProductOrderData(),
      global: { plugins: [storemock] },
    });
    var a = 1;
    expect(wrapper.html()).toContain(a.toString());
  });
  test("ProductBox in Order renders the product price correct when wanted to refund", () => {
    const wrapper = mount(ProductBoxOrder, {
      propsData: getProductOrderData(),
      global: { plugins: [storemock] },
    });
    var a = "Refund this Product! ($16000 will be refunded.)";
    expect(wrapper.html()).toContain(a);
  });
  test("ProductBox in Order calls function when wanted to refund", async () => {
    const refund = jest.spyOn(ProductBoxOrder.methods, "refund");
    const wrapper = mount(ProductBoxOrder, {
      propsData: getProductOrderData(),
      global: { plugins: [storemock] },
    });

    await wrapper.vm.$nextTick();
    wrapper.find("#refundtext").trigger("click");

    expect(refund).toHaveBeenCalled();
  });

  test("OrderBox renders the order no correct", () => {
    const wrapper = mount(OrderBox, {
      propsData: getOrderBoxData(),
      global: { plugins: [storemock] },
    });
    var a = "62ab2a916ccc05375cd62a97";
    expect(wrapper.html()).toContain(a);
  });
  test("OrderBox renders the order date correct", () => {
    const wrapper = mount(OrderBox, {
      propsData: getOrderBoxData(),
      global: { plugins: [storemock] },
    });
    var a = "2022-06-16 13:05";
    expect(wrapper.html()).toContain(a);
  });
  test("OrderBox renders the order status correct", () => {
    const wrapper = mount(OrderBox, {
      propsData: getOrderBoxData(),
      global: { plugins: [storemock] },
    });
    var a = "Processing";
    expect(wrapper.html()).toContain(a);
  });
  test("OrderBox renders the order price correct", () => {
    const wrapper = mount(OrderBox, {
      propsData: getOrderBoxData(),
      global: { plugins: [storemock] },
    });
    var a = "0";
    expect(wrapper.html()).toContain(a);
  });
  test("OrderBox shows the cancel button only when processing", () => {
    const wrapper = mount(OrderBox, {
      propsData: getOrderBoxData(),
      global: { plugins: [storemock] },
    });
    var a = "Cancel Order";
    expect(wrapper.html()).toContain(a);
  });
  test("OrderBox cancel order button functions", async () => {
    const cancelOrder = jest.spyOn(OrderBox.methods, "cancelOrder");
    const wrapper = mount(OrderBox, {
      propsData: getOrderBoxData(),
      global: { plugins: [storemock] },
    });

    await wrapper.vm.$nextTick();
    wrapper.find("myButton").trigger("click");

    expect(cancelOrder).toHaveBeenCalled();
  });
  test("myProfile is a Vue instance", () => {
    const wrapper = mount(MyProfile, {
      global: { plugins: [storemock] },
    });

    expect(wrapper).toBeTruthy();
  });
  test("myProfile renders the unauthorized members correctly", () => {
    const wrapper = mount(MyProfile, {
      global: { plugins: [storemock] },
    });
    var a = "You are not signed in!";
    expect(wrapper.html()).toContain(a);
  });
  test("myProfile Sign in here functions correctly", () => {
    const wrapper = mount(MyProfile, {
      global: { plugins: [storemock] },
    });
    var a = "Sign in here";
    expect(wrapper.html()).toContain(a);
  });
  test("myProfile Sign in here functions correctly", () => {
    const wrapper = mount(MyProfile, {
      global: { plugins: [storemock] },
    });
    var a = "Sign in here";
    expect(wrapper.html()).toContain(a);
  });
  test("HomeView header functions correctly", () => {
    const wrapper = mount(HomeView, {
      global: { plugins: [storemock] },
    });
    var a = "TeknoSU";
    expect(wrapper.html()).toContain(a);
  });

  test("HomeView is a Vue instance", () => {
    const wrapper = mount(HomeView, {
      global: { plugins: [storemock] },
    });
    expect(wrapper.html()).toBeTruthy();
  });
  test("HomeView search bar renders", () => {
    const wrapper = mount(HomeView, {
      global: { plugins: [storemock] },
    });
    var a = "Search for a product...";
    expect(wrapper.html()).toContain(a);
  });
  test("HomeView carousel renders", () => {
    const wrapper = mount(HomeView, {
      global: { plugins: [storemock] },
    });
    var a = "Next";
    expect(wrapper.html()).toContain(a);
  });
});
