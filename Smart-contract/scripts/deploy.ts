import { ethers, run, network } from "hardhat";
import * as dotenv from "dotenv";

dotenv.config();

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(`Deploying contracts with account: ${deployer.address}`);

    // Deploy ERC20 Token
    const Token = await ethers.getContractFactory("ERC20");
    const token = await Token.deploy("MayToken", "MTK", 18, 100000);
    await token.waitForDeployment();
    const tokenAddress = await token.getAddress();
    console.log(`ERC20 token deployed at: ${tokenAddress}`);

    // Wait for a few confirmations before verification
    if (network.name !== "hardhat") {
        console.log("Waiting for transactions to confirm...");
        await new Promise((resolve) => setTimeout(resolve, 30000));

        try {
            console.log("Verifying ERC20 token contract...");
            await run("verify:verify", {
                address: tokenAddress,
                constructorArguments: ["MayToken", "MTK", 18, 100000],
            });
            console.log("ERC20 token verified successfully!");
        } catch (error) {
            console.error("Verification failed:", error);
        }

        // Check owner's balance
        const ownerBalance = await token.balanceOf(deployer.address);
        console.log(`Owner's balance: ${ethers.formatUnits(ownerBalance, 18)} MTK`);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
