const fs = require("fs");
const { byteLengthOfData } = require("./constant.js");
const { stringToLeHex } = require("./utils.js");

async function main() {
  console.log("\nAdding new file...");
  const dataStringify = fs.readFileSync("./scripts/data.json");
  const data = JSON.parse(dataStringify);

  const input = {};

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];
      const values = [];

      for (let childKey in parentValue) {
        const value = parentValue[childKey];

        const itemBuf = Buffer.from(value);
        const itemHex = "0x" + itemBuf.toString("hex");

        values.push(itemHex);
      }

      input[key] = values;
    } else {
      const value = data[key];

      const itemBuf = Buffer.from(value);
      const itemHex = "0x" + itemBuf.toString("hex");

      input[key] = itemHex;
    }
  }

  fs.writeFileSync("./inputs/zuni.json", JSON.stringify(input));
  console.log("\nAdded `zuni.json` file to `inputs/`\n");
}

main().catch((e) => console.log(e.message));
