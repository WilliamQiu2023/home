import {ethers} from "ethers";
// import { BrowserProvider,parseUnits } from "ethers";
// import { HDNodeWallet } from "ethers/wallet";
// import pkg from "dotenv";
// const {dotenv} = pkg;
// const c = dotenv.config();
// console.log(c)
/*
const API_URL = process.env.API_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY
const PUBLIC_KEY = process.env.PUBLIC_KEY
*/
//const { createAlchemyWeb3 } = require("@alch/alchemy-web3")
//const web3 = createAlchemyWeb3(API_URL)
const API_URL="https://eth-goerli.gateway.pokt.network/v1/lb/0a7cfffcea931a1befd89f47";
const provider = new ethers.providers.JsonRpcProvider(API_URL);

const signer = provider.getSigner()
console.log(signer);
const blockNum = provider.getBalance("0xb723Eea40eb3d8044236108B1966F17d6eD838e1");
blockNum.then((r)=>{
    console.log(r);
}).catch((e)=>{
    console.error(e)
});
console.log("blockNum", blockNum);