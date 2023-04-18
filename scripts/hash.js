const fs = require("fs");
const { pedersenHash, toHex, stringToLeHex } = require("./utils");
const { byteLengthOfData } = require("./constant");
const { BN } = require("bn.js");

async function main() {
  const dataStringify = fs.readFileSync("./scripts/data.json");
  const data = JSON.parse(dataStringify);
  let totalData = "";

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];

      for (let childKey in parentValue) {
        const value = parentValue[childKey];
        const length = byteLengthOfData[key][childKey];

        const itemLeHex = stringToLeHex(value, length);

        totalData += itemLeHex.slice(2);
      }
    } else {
      const value = data[key];
      const length = byteLengthOfData[key];

      const itemLeHex = stringToLeHex(value, length);

      totalData += itemLeHex.slice(2);
    }
  }

  const buff = new BN(totalData, "hex").toBuffer();
  const hash = toHex(pedersenHash(buff));
  console.log("\nOriginal:");
  console.log(hash);

  const publicZkStr = fs.readFileSync("./proof/zuni/public.json");
  const publicZk = JSON.parse(publicZkStr);
  const hashOfZk = toHex(publicZk[0]);
  console.log("\nProof:");
  console.log(hashOfZk);
}

main().catch((e) => console.log(e.message));
