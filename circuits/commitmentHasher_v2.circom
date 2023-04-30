pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template CommitmentHasher_v2() {
    signal input name;              // 31 bytes
    signal input dateOfBirth[3];    // [day, month, year] | [2, 2, 4] bytes
    signal input school;            // 31 bytes
    signal input yearGraduation;    //  4 bytes
    signal input major;             // 31 bytes
    signal input modeOfStudy;       // 16 bytes
    signal input decisionNumber;    // 16 bytes
    signal input classification;    // 16 bytes
    
    signal output commitment;

    component commitmentHasher = Poseidon(10);

    commitmentHasher.inputs[0] <== name;
    commitmentHasher.inputs[1] <== dateOfBirth[0];
    commitmentHasher.inputs[2] <== dateOfBirth[1];
    commitmentHasher.inputs[3] <== dateOfBirth[2];
    commitmentHasher.inputs[4] <== school;
    commitmentHasher.inputs[5] <== yearGraduation;
    commitmentHasher.inputs[6] <== major;
    commitmentHasher.inputs[7] <== modeOfStudy;
    commitmentHasher.inputs[8] <== decisionNumber;
    commitmentHasher.inputs[9] <== classification;

    commitment <== commitmentHasher.out;
}