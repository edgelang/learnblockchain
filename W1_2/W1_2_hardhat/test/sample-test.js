const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});

describe("Counter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy(10);
    await counter.deployed();

    expect(await counter.counter()).to.equal(10);

    const setCounterTx = await counter.setCounter(20);

    // wait until the transaction is mined
    await setCounterTx.wait();

    expect(await counter.counter()).to.equal(20);

    const countTx = await counter.count();

    // wait until the transaction is mined
    await countTx.wait();

    expect(await counter.counter()).to.equal(21);
  });
});

describe("CounterDeloyed", function () {
  it("Should return the new greeting once it's changed", async function () {
    const [account] = await ethers.getSigners();
    const counter = await ethers.getContractAt("Counter", "0x49cce04e013eaA5AB54CAEd9C7E749f872a72b4A", account);

    expect(await counter.counter()).to.equal(21);
  });
});