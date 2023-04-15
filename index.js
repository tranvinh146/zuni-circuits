const { BN } = require("bn.js");
const fs = require("fs");

async function main() {
  const data = {
    name: "Nguyen Van A",
    dateOfBirth: {
      day: "10",
      month: "11",
      year: "2023",
    },
    yearGraduation: "2019",
    school: "Truong dai hoc CNTT",
    major: "CNTT",
    modeOfStudy: "Chinh quy",
    decisionNumber: "178/QĐ_ĐHCNTT",
    classification: "Very good",
  };

  const input = {};

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];
      const values = [];

      for (let childKey in parentValue) {
        const itemBytes = Buffer.from(parentValue[childKey].toString());
        const itemBN = new BN(itemBytes, "hex");

        values.push(itemBN.toString());
      }

      input[key] = values;
    } else {
      const itemBytes = Buffer.from(data[key]);
      const itemBN = new BN(itemBytes, "hex");

      input[key] = itemBN.toString();
    }
  }

  fs.writeFileSync("example_input.json", JSON.stringify(input));
}

main().catch((e) => console.log(e.message));
