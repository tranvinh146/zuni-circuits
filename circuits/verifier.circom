pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/eddsa.circom";

template Verifier() {
    signal input pubKey[2];
    
    component pubKeyBits[2];
    
    pubKeyBits[0] = Num2Bits(128);
    pubKeyBits[0].in <== pubKey[0];

    pubKeyBits[1] = Num2Bits(128);
    pubKeyBits[1].in <== pubKey[1];
    
    signal input A[256];
    signal input R8[256];
    signal input S[256];
    
    signal input name;              // 31 bytes
    signal input dateOfBirth[3];    // [day, month, year] | [2, 2, 4] bytes
    signal input school;            // 31 bytes
    signal input yearGraduation;    //  4 bytes
    signal input major;             // 31 bytes
    signal input classification;    // 16 bytes
    signal input modeOfStudy;       // 16 bytes
    signal input serialNumber;      // 16 bytes
    signal input referenceNumber;   // 16 bytes
    signal input dateOfIssue[3];    // [day, month, year] | [2, 2, 4] bytes

    var byteToBits = 8;

    var nameBitsLength              = 31 * byteToBits;
    var dayOfBirthBitsLength        =  2 * byteToBits;
    var monthOfBirthBitsLength      =  2 * byteToBits;
    var yearOfBirthBitsLength       =  4 * byteToBits;
    var schoolBitsLength            = 31 * byteToBits;
    var yearGraduationBitsLength    =  4 * byteToBits;
    var majorBitsLength             = 31 * byteToBits;
    var classificationBitsLength    = 16 * byteToBits;
    var modeOfStudyBitsLength       = 16 * byteToBits;
    var serialNumberBitsLength      = 16 * byteToBits;
    var referenceNumberBitsLength   = 16 * byteToBits;
    var dayOfIssueBitsLength        =  2 * byteToBits;
    var monthOfIssueBitsLength      =  2 * byteToBits;
    var yearOfIssueBitsLength       =  4 * byteToBits;

    var totalBitsLength = nameBitsLength + dayOfBirthBitsLength + monthOfBirthBitsLength + yearOfBirthBitsLength + schoolBitsLength + yearGraduationBitsLength + majorBitsLength + classificationBitsLength + modeOfStudyBitsLength + serialNumberBitsLength + referenceNumberBitsLength + dayOfIssueBitsLength + monthOfIssueBitsLength + yearOfIssueBitsLength;

    component eddsaVerifier = EdDSAVerifier(totalBitsLength);
    for (var i = 0; i < 256; i++) {
        // eddsaVerifier.A[i]  <== A[i];
        if (i < 128) {
            eddsaVerifier.A[i] <== pubKeyBits[0].out[i];
            eddsaVerifier.A[i + 128] <== pubKeyBits[1].out[i];
        }
        eddsaVerifier.R8[i]  <== R8[i];
        eddsaVerifier.S[i]  <== S[i];
    }

    component nameBits              = Num2Bits(nameBitsLength);
    component dayOfBirthBits        = Num2Bits(dayOfBirthBitsLength);    
    component monthOfBirthBits      = Num2Bits(monthOfBirthBitsLength);
    component yearOfBirthBits       = Num2Bits(yearOfBirthBitsLength);
    component schoolBits            = Num2Bits(schoolBitsLength);
    component yearGraduationBits    = Num2Bits(yearGraduationBitsLength);
    component majorBits             = Num2Bits(majorBitsLength);
    component classificationBits    = Num2Bits(classificationBitsLength);
    component modeOfStudyBits       = Num2Bits(modeOfStudyBitsLength);
    component serialNumberBits      = Num2Bits(serialNumberBitsLength);
    component referenceNumberBits   = Num2Bits(referenceNumberBitsLength);
    component dayOfIssueBits        = Num2Bits(dayOfIssueBitsLength);    
    component monthOfIssueBits      = Num2Bits(monthOfIssueBitsLength);
    component yearOfIssueBits       = Num2Bits(yearOfIssueBitsLength);

    var previousLength = 0;

    // name
    nameBits.in <== name;
    for (var i = 0; i < nameBitsLength; i++) {
        eddsaVerifier.msg[i] <== nameBits.out[i];
    }
    previousLength += nameBitsLength;

    // day of birth
    dayOfBirthBits.in <== dateOfBirth[0];
    for (var i = 0; i < dayOfBirthBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== dayOfBirthBits.out[i];
    }
    previousLength += dayOfBirthBitsLength;

    // month of birth
    monthOfBirthBits.in <== dateOfBirth[1];
    for (var i = 0; i < monthOfBirthBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== monthOfBirthBits.out[i];
    }
    previousLength += monthOfBirthBitsLength;

    // year of birth
    yearOfBirthBits.in <== dateOfBirth[2];
    for (var i = 0; i < yearOfBirthBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== yearOfBirthBits.out[i];
    }
    previousLength += yearOfBirthBitsLength;

    // school
    schoolBits.in <== school;
    for (var i = 0; i < schoolBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== schoolBits.out[i];
    }
    previousLength += schoolBitsLength;

    // yearGraduation
    yearGraduationBits.in <== yearGraduation;
    for (var i = 0; i < yearGraduationBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== yearGraduationBits.out[i];
    }
    previousLength += yearGraduationBitsLength;

    // major
    majorBits.in <== major;
    for (var i = 0; i < majorBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== majorBits.out[i];
    }
    previousLength += majorBitsLength;

    // classification
    classificationBits.in   <== classification;
    for (var i = 0; i < classificationBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== classificationBits.out[i];
    }
    previousLength += classificationBitsLength;

    // model
    modeOfStudyBits.in <== modeOfStudy;
    for (var i = 0; i < modeOfStudyBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== modeOfStudyBits.out[i];
    }
    previousLength += modeOfStudyBitsLength;

    // serialNumber
    serialNumberBits.in <== serialNumber;
    for (var i = 0; i < serialNumberBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== serialNumberBits.out[i];
    }
    previousLength += serialNumberBitsLength;

    // referenceNumber
    referenceNumberBits.in <== referenceNumber;
    for (var i = 0; i < referenceNumberBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== referenceNumberBits.out[i];
    }
    previousLength += referenceNumberBitsLength;

    // day of issue
    dayOfIssueBits.in <== dateOfIssue[0];
    for (var i = 0; i < dayOfIssueBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== dayOfIssueBits.out[i];
    }
    previousLength += dayOfIssueBitsLength;

    // month of issue
    monthOfIssueBits.in <== dateOfIssue[1];
    for (var i = 0; i < monthOfIssueBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== monthOfIssueBits.out[i];
    }
    previousLength += monthOfIssueBitsLength;

    // year of issue
    yearOfIssueBits.in <== dateOfIssue[2];
    for (var i = 0; i < yearOfIssueBitsLength; i++) {
        eddsaVerifier.msg[i + previousLength] <== yearOfIssueBits.out[i];
    }
    previousLength += yearOfIssueBitsLength;

    // ensure the length correct
    previousLength === totalBitsLength;
}

component main = Verifier();

