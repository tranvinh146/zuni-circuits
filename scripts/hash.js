const fs = require("fs");

async function main() {
  const input = {};
  let totalData = "0x";

  for (let key in data) {
    if (typeof data[key] === "object") {
      const parentValue = data[key];
      const values = [];

      for (let childKey in parentValue) {
        const value = parentValue[childKey];
        const length = byteLengthOfData[key][childKey];

        const leHex = stringToLeHex(value, length);

        values.push(leHex);
        totalData += leHex.slice(2);
      }

      input[key] = values;
    } else {
      const value = data[key];
      const length = byteLengthOfData[key];

      const leHex = stringToLeHex(value, length);

      input[key] = leHex;
      totalData += leHex.slice(2);
    }
  }
}

main().catch((e) => console.log(e.message));
