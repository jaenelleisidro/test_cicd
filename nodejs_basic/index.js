const express = require('express');

const mongoose = require('mongoose');


const {MONGO_IP,MONGO_PORT,MONGO_USER,MONGO_PASSWORD} = require('./config/config')

const app = express();

const mongoURL = `mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_IP}/?authSource=admin`;
const connectWithRetry = () =>{
	mongoose.connect(mongoURL,{
		// userNewUrlParse: true,
		useUnifiedTopology: true,
		// useFindAndModify: false,
	}).then(()=>{
		console.log('mongodb connection successfull');
	}).catch(e =>{
		console.log(e);
		setTimeout(connectWithRetry,5000);
	});
}
// connectWithRetry();

const port = process.env.PORT || 80;



app.use(express.urlencoded({ extended: false }));


app.get('/',async (req, res) => {
	res.json({status:"success",data:"the server is running!!! trying again if push detects changes"});
});


app.listen(port, () => console.log('Server running on port:'+port));