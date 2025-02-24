async function main() {
  const ArticlePlatform = await ethers.getContractFactory("ArticlePlatform");
  const articlePlatform = await ArticlePlatform.deploy();
  await articlePlatform.deployed();
  console.log("ArticlePlatform deployed to:", articlePlatform.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
