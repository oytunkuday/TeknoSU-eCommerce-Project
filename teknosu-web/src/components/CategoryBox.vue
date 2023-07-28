<template>
    <router-link :to="{name: 'SingleCategory', params: {_id: Category._id}}">
    <div class="card">
        <h4>{{Category.name}}</h4>
        <img  :src="Category.photo" alt="Image" class= "img">
    </div>
    </router-link>
</template>

<script>
export default {
    props: ["Category"]
}
</script>

<style scoped>
.card {
    padding: 5px;
    text-align: center;
    background-color: #fefbfb;
    box-sizing: border-box;
    border: 1px solid rgba(0, 0, 0, 0.125);
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
    border-radius: 7px;
}
.card:hover {
    background-color: #3c3939;
    box-shadow: 0 10px 10px 0 rgba(0,0,0,0.2);
    cursor: pointer;
    color: azure;
    font-weight: bold;
}

.card img {
    object-fit: scale-down;
    width: 100%;
    height: 500px;
    padding: 10px;
    margin: -10px;
    border-radius: 15px;
}
h4{
    margin: 7px;
}
</style>