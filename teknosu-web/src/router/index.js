import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import ShoppingCart from "../views/ShoppingCart.vue";
import ProductPage from "../views/ProductPage";
import CategoryPage from "../views/CategoryPage";
import SingleCategory from "../views/SingleCategory";
import SignUp from "../views/SignUp";
import SignIn from "../views/SignIn";
import Profile from "../views/MyProfile";
import SearchPage from "../views/SearchPage";
import ReviewPage from "../views/ReviewPage";
import CreditCard from "../views/CreditCard";
import OrderPage from "../views/CompleteOrder";
import MyOrders from "../views/MyOrders";
import MyWishlist from "../views/Wishlist";
import RatePage from "../views/RatePage";
import SalesManagerHome from "../views/SalesManagerHome";
import SalesManagerRefundRequests from "../views/SalesManagerRefundRequests";
import ProfitPage from "../views/ProfitPage";
import SalesManagerOrders from "../views/SalesManagerOrders";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
  },
  {
    path: "/ShoppingCart",
    name: "ShoppingCart",
    component: ShoppingCart,
  },
  {
    path: "/products/:id",
    name: "ProductPage",
    component: ProductPage,
    props: true,
  },
  {
    path: "/rateproduct/:id",
    name: "RatePage",
    component: RatePage,
    props: true,
  },
  {
    path: "/categories",
    name: "CategoryPage",
    component: CategoryPage,
  },
  {
    path: "/categories/:_id",
    name: "SingleCategory",
    component: SingleCategory,
    props: true,
  },
  {
    path: "/signin",
    name: "SignInPage",
    component: SignIn,
  },
  {
    path: "/signin/signup",
    name: "SignUpPage",
    component: SignUp,
  },
  {
    path: "/myProfile",
    name: "ProfilePage",
    component: Profile,
    props: true,
  },
  {
    path: "/myOrders",
    name: "MyOrdersPage",
    component: MyOrders,
    props: true,
  },
  {
    path: "/search?name=:searchKey",
    name: "Search",
    component: SearchPage,
    props: true,
  },
  {
    path: "/reviews?product=:_id",
    name: "Reviews",
    component: ReviewPage,
    props: true,
  },
  {
    path: "/cardForm",
    name: "CreditCard",
    component: CreditCard,
    props: true,
  },
  {
    path: "/completeOrder",
    name: "OrderPage",
    component: OrderPage,
    //props: true,
  },
  {
    path: "/wishlist",
    name: "Wishlist",
    component: MyWishlist,
  },
  {
    path: "/salesmanager",
    name: "SalesManagerHome",
    component: SalesManagerHome,
  },
  {
    path: "/salesmanrefundrequests",
    name: "RefundRequests",
    component: SalesManagerRefundRequests,
  },
  {
    path: "/profitpage",
    name: "Profit",
    component: ProfitPage,
  },
  {
    path: "/salesmanagerorders",
    name: "SalesManagerOrders",
    component: SalesManagerOrders,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
