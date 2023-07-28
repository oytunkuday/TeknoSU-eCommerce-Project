import { ref } from '@vue/reactivity'
import axios from 'axios'

const getUserCart = (token) => {
    const Cart = ref(null)
    const error = ref(null)
    const load1 = async() => {
    
    try{
        let response = await axios.get('http://localhost:3000/api/v1/cart/getCart',{
            headers: {
                authorization: 'Bearer '+ token,
                'Content-Type': 'application/json',
                },
        })
        console.log(response)
            if(response.status < 400){
                console.log("get cart complete")
                const data = response
                Cart.value = data.data
                //console.log(Cart._rawValue.userId)
                
              }
              else{
                console.log("get cart NOT complete")
                throw Error('that post does no exist')
                
              }
            }
      
              catch(err){

              }
                
        }
    return{
        Cart, error, load1
    }
}

export default getUserCart