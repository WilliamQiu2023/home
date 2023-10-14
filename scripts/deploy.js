async function main() {
    const _factory = await ethers.getContractFactory("ChinaDAO");
    const _contract = await _factory.deploy();
    await _contract.deployed();
    console.log("Contract address of ChinaDAO is :", _contract.address)
}

main()
    .then(()=>{process.exit(0)})
    .catch((e)=>{
        console.error(e);
        process.exit(1);
    })