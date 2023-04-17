#!/bin/bash

NAME=$1
INPUT=$(cat inputs/$1.json)

if [ -z "$2" ] || [ "$2" = "build" ]; then
    echo -e "\n\nBuilding circuit..."
    circom circuits/$NAME.circom --r1cs --wasm -o compilers
fi

if [ -z "$2" ] || [ $2 = "compile" ]; then
    echo -e "\n\nCompiling circuit..."
    cd compilers/"$NAME"_js
    echo $INPUT > input.json
    node generate_witness.js $NAME.wasm input.json witness.wtns
    cd ../..
fi

if [ -z "$2" ] || [ $2 = "setup" ]; then
    echo -e "\n\nSetup verification key..."
    snarkjs groth16 setup compilers/$NAME.r1cs groth16/powersOfTau28_hez_final_13.ptau groth16/"$NAME"_0000.zkey
    # snarkjs zkey contribute "$NAME"_0000.zkey "$NAME"_0001.zkey --name="1st Contributor Name" -v
    snarkjs zkey export verificationkey groth16/"$NAME"_0000.zkey groth16/verification_key.json
fi

if [ -z "$2" ] || [ $2 = "verify" ]; then
    echo -e "\n\nVerifying..."
    mkdir -p proof/$NAME

    if output=$(npx snarkjs groth16 prove groth16/"$NAME"_0000.zkey compilers/"$NAME"_js/witness.wtns proof/$NAME/proof.json proof/$NAME/public.json 2>&1); then
        snarkjs groth16 verify groth16/verification_key.json proof/$NAME/public.json proof/$NAME/proof.json
    else
        echo "$output"
    fi
fi