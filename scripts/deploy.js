async function main() {
   
    const _CommLibFac = await ethers.getContractFactory("CommLib");
    const _libContract = await _CommLibFac.deploy();
    await _libContract.deployed();
    console.log("Library address of CommLib is :", _libContract.address)

    const _factory = await ethers.getContractFactory("ChinaDAO",{
        libraries: {
            CommLib :  _libContract.address
        }
    });
    const _contract = await _factory.deploy();
    await _contract.deployed();
    console.log("Contract address of ChinaDAO is :", _contract.address)
}
async function deployPark() {
    const _Fac = await ethers.getContractFactory("Park");
    const _contract = await _Fac.deploy();
    await _contract.deployed();
    console.log("Contract address of Park is :", _contract.address)

}
main()
    .then(()=>{process.exit(0)})
    .catch((e)=>{
        console.error(e);
        process.exit(1);
    })