import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import  { ethers } from "hardhat";

async function deployTokenFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("ERC20");
    const token = await Token.deploy("MyToken", "MTK", 18, 1000000);
    await token.waitForDeployment();
    return { token, owner, addr1, addr2 };
}

describe("ERC20 Token", function () {
    it("Should deploy and assign the total supply to the owner", async function () {
        const { token, owner } = await loadFixture(deployTokenFixture);
        const ownerBalance = await token.balanceOf(owner.address);
        expect(ownerBalance).to.equal(ethers.parseUnits("1000000", 18));
    });

    it("Should transfer tokens between accounts", async function () {
        const { token, owner, addr1 } = await loadFixture(deployTokenFixture);
        await token.transfer(addr1.address, ethers.parseUnits("100", 18));
        const addr1Balance = await token.balanceOf(addr1.address);
        expect(addr1Balance).to.equal(ethers.parseUnits("100", 18));
    });

    it("Should fail if sender doesn’t have enough balance", async function () {
        const { token, addr1, addr2 } = await loadFixture(deployTokenFixture);
        await expect(token.connect(addr1).transfer(addr2.address, ethers.parseUnits("100", 18)))
            .to.be.revertedWithCustomError(token, "InsufficientFunds");
    });

    it("Should approve allowance and transferFrom correctly", async function () {
        const { token, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        await token.approve(addr1.address, ethers.parseUnits("50", 18));
        expect(await token.allowance(owner.address, addr1.address)).to.equal(ethers.parseUnits("50", 18));

        await token.connect(addr1).transferFrom(owner.address, addr2.address, ethers.parseUnits("50", 18));
        expect(await token.balanceOf(addr2.address)).to.equal(ethers.parseUnits("50", 18));
    });

    it("Should fail transferFrom if allowance is insufficient", async function () {
        const { token, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        await expect(token.connect(addr1).transferFrom(owner.address, addr2.address, ethers.parseUnits("10", 18)))
            .to.be.revertedWithCustomError(token, "InsufficientAllowance");
    });

    it("Should burn tokens correctly", async function () {
        const { token, owner } = await loadFixture(deployTokenFixture);
        await token.burn(ethers.parseUnits("100", 18));
        expect(await token.totalSupply()).to.equal(ethers.parseUnits("999900", 18));
        expect(await token.balanceOf(owner.address)).to.equal(ethers.parseUnits("999900", 18));
    });

    it("Should mint new tokens only by owner", async function () {
        const { token, owner, addr1 } = await loadFixture(deployTokenFixture);
        await token.mint(addr1.address, ethers.parseUnits("500", 18));
        expect(await token.totalSupply()).to.equal(ethers.parseUnits("1000500", 18));
        expect(await token.balanceOf(addr1.address)).to.equal(ethers.parseUnits("500", 18));
    });

    it("Should revert minting by non-owner", async function () {
        const { token, addr1 } = await loadFixture(deployTokenFixture);
        await expect(token.connect(addr1).mint(addr1.address, ethers.parseUnits("500", 18)))
            .to.be.revertedWithCustomError(token, "OnlyOwnerAllowed");
    });
});
