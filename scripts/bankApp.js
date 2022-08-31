// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

//define our main function
async function main() {
    const signers = await hre.ethers.getSigners();
    // console.log("Signers::", signers) //shows hexa list

    // select particular address, the first address(index 0) in this case
    const account0 = signers[0].address;
    const BankApp = await hre.ethers.getContractFactory("BankApp");
    //parse parameters to the constructor if any
    const bankApp = await BankApp.deploy("unknown");
    await bankApp.deployed();

    //register user
    await bankApp.register(account0,
        234,
        "Jael",
        "DGH87683gh",
        0)

    // log in the user
    await bankApp.connect(signers[0]).login()

    // deposit
    await bankApp.deposit(2300)

    //check balance
    await bankApp.balanceOf(account0)
}

// function to excecute when you run the script
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});