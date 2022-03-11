<script>
import { ethers } from 'ethers'

import myERC20Addr from '../../../deployments/dev/MyERC20.json'
import myERC20Abi from '../../../deployments/abi/MyERC20.json'

import bankAddr from '../../../deployments/dev/Vault.json'
import bankAbi from '../../../deployments/abi/Vault.json'

import { premitTypedDate } from "../typedData.js";

export default {

  name: 'erc20',

  data() {
    return {

      recipient: null,
      amount: null,
      balance: null,

      name: null,
      decimal: null,
      symbol: null,
      supply: null,

      stakeAmount: null,
      withdrawAmount:null,

      stakeBalance:null,

    }
  },

  async created() {
    await this.initAccount()
    this.initContract()
    this.getInfo();
  },

  methods: {
    async initAccount(){
      if(window.ethereum) {
        console.log("initAccount");
        try{
          this.accounts = await window.ethereum.enable()
          console.log("accounts:" + this.accounts);
          this.account = this.accounts[0];
          this.currProvider = window.ethereum;
          this.provider = new ethers.providers.Web3Provider(window.ethereum);

          this.signer = this.provider.getSigner()
          let network = await this.provider.getNetwork()
          this.chainId = network.chainId;
          console.log("chainId:", this.chainId);

        } catch(error){
          console.log("User denied account access", error)
        }
      }else{
        console.log("Need install MetaMask")
      }
    },

    async initContract() {
      this.erc20Token = new ethers.Contract(myERC20Addr.address, 
        myERC20Abi.abi, this.signer);

      this.bank = new ethers.Contract(bankAddr.address, 
        bankAbi.abi, this.signer);

    }, 

    getInfo() {
      this.erc20Token.name().then((r) => {
        this.name = r;
      })
      this.erc20Token.decimals().then((r) => {
        this.decimal = r;
      })
      this.erc20Token.symbol().then((r) => {
        this.symbol = r;
      })
      this.erc20Token.totalSupply().then((r) => {
        this.supply = ethers.utils.formatUnits(r, 18);
      })

      this.erc20Token.balanceOf(this.account).then((r) => {
        this.balance = ethers.utils.formatUnits(r, 18);
      })

      this.bank.deposited(this.account).then((r) => {
        this.stakeBalance = ethers.utils.formatUnits(r, 18);
      })
    },

    getNonce() {
      this.erc20Token.nonces(this.account).then(r => {
        this.nonce = r.toString();
        console.log("nonce:" + this.nonce);
      })
    },

    transfer() {
      let amount = ethers.utils.parseUnits(this.amount, 18);
      this.erc20Token.transfer(this.recipient, amount).then((r) => {
        console.log(r);  // 返回值不是true
        this.getInfo();
      })
    },

    stake() {
      let amount =  ethers.utils.parseUnits(this.stakeAmount).toString();
      let approvedAmount
      this.erc20Token.allowance(this.account, bankAddr.address).then((r) => {
        approvedAmount = ethers.utils.formatUnits(r, 18);
        console.log(approvedAmount)
        if (approvedAmount < amount) {
          this.erc20Token.approve(bankAddr.address, ethers.utils.parseUnits("10000000000000000000000000").toString(),{
            from: this.account
          }).then(() => {

            this.bank.deposit(amount, {
              from: this.account
            }).then(() => {
              console.log("质押成功")
              this.getInfo();
            })
          })
        } else {
          this.bank.deposit(amount, {
            from: this.account
          }).then(() => {
            console.log("质押成功")
            this.getInfo();
            console.log(this.stakeBalance)
          })
        }
      })


    },

    extract(){
      let amount =  ethers.utils.parseUnits(this.withdrawAmount).toString();

      this.bank.withdraw(amount, {
        from: this.account
      }).then(() => {
        console.log("取款成功")
        this.getInfo();
      })
    },

    extractAll(){

      this.bank.withdrawAll({
        from: this.account
      }).then(() => {
        this.getInfo();
      })
    },
  }
}


</script>

<template>
  <div >

      <div>
        <br /> Token名称 : {{ name  }}
        <br /> Token符号 : {{  symbol }}
        <br /> Token精度 : {{  decimal }}
        <br /> Token发行量 : {{  supply }}
        <br /> 我的余额 : {{ balance  }}
        <br /> 我的存款 : {{ stakeBalance  }}
      </div>

      <div >
        <br />转账到:
        <input type="text" v-model="recipient" />
        <br />转账金额
        <input type="text" v-model="amount" />
        <br />
        <button @click="transfer()"> 转账 </button>
      </div>

    <div >
      <input v-model="stakeAmount" placeholder="输入质押量"/>
      <button @click="stake">质押存款</button>
    </div>

    <div >
      <input v-model="withdrawAmount" placeholder="输入取款量"/>
      <button @click="extract">取款</button>
    </div>
    <div >
      <button @click="extractAll">全部取款</button>
    </div>

  </div>
</template>

<style scoped>
h1 {
  font-weight: 500;
  font-size: 2.6rem;
  top: -10px;
}

h3 {
  font-size: 1.2rem;
}

.greetings h1,
.greetings h3 {
  text-align: center;
}

div {
  font-size: 1.2rem;
}

@media (min-width: 1024px) {
  .greetings h1,
  .greetings h3 {
    text-align: left;
  }
}
</style>
