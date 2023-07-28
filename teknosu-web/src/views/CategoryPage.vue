<template>
  <CategoryList :Categories="Categories"/>
</template>

<script>
// import { mapGetters } from 'vuex'
// import { mapState } from 'vuex'
import CategoryList from '../components/CategoryList.vue'
import getCategories from '../composables/getCategories'


export default {
    components: {CategoryList},

    // computed: {
    //   ...mapGetters([
    //     'returnCount'
    //   ]),
    //   ...mapState(['count'])
    // },
  
    setup(){
    const {Categories, error1, load1} = getCategories()
    load1()

    return{Categories, error1}
    }
}
</script>

<style>

</style>