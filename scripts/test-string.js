async function main() {
  const data = {
    name: "Alice",
    age: 10,
  };
  const dataStr = JSON.stringify(data);
  const dataBuff = Buffer.from(dataStr);
  const dataBase64 = dataBuff.toString("base64");
  console.log(dataBase64);

  const ageStr = `"name":"Alice"`;
  const ageBuff = Buffer.from(ageStr);
  const ageBase64 = ageBuff.toString("base64");
  console.log(ageBase64);
}

main().catch((e) => console.log(e.message));
