pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/pedersen.circom";

template Hash() {
    signal input data;             
    signal output commitment;

    var dataBitsLength = 4 * 8;
    component dataBits = Num2Bits(dataBitsLength);
    component commitmentHasher = Pedersen(dataBitsLength);

    dataBits.in <== data;
    for (var i = 0; i < dataBitsLength; i++) {
        commitmentHasher.in[i] <== dataBits.out[i];
    }

    commitment <== commitmentHasher.out[0];
}

component main {public [data]} = Hash();