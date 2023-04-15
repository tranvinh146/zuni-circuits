pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/pedersen.circom";

template Zuni() {
    signal input name;              // 32 bytes = 256 bits
    signal input dateOfBirth[3];    // [day, month, year] | [2, 2, 4] bytes => [16, 16, 32] bits
    signal input school;            // 64 bytes = 512 bits
    signal input yearGraduation;    //  4 bytes = 32 bits
    signal input major;             // 64 bytes = 512 bits
    signal input modeOfStudy;       // 16 bytes = 128 bits
    signal input decisionNumber;    // 16 bytes = 128 bits
    signal input classification;    // 16 bytes = 128 bits
    
    signal output commitment;

    var nameBitsLength              = 256;
    var dayOfBirthBitsLength        = 16;
    var monthOfBirthBitsLength      = 16;
    var yearOfBirthBitsLength       = 32;
    var schoolBitsLength            = 512;
    var yearGraduationBitsLength    = 32;
    var majorBitsLength             = 512;
    var modeOfStudyBitsLength       = 128;
    var decisionNumberBitsLength    = 128;
    var classificationBitsLength    = 128;

    var totalBitsLength = nameBitsLength + dayOfBirthBitsLength + monthOfBirthBitsLength + yearOfBirthBitsLength + schoolBitsLength + yearGraduationBitsLength + majorBitsLength + modeOfStudyBitsLength + decisionNumberBitsLength + classificationBitsLength;

    component nameBits              = Num2Bits(nameBitsLength);
    component dayOfBirthBits        = Num2Bits(dayOfBirthBitsLength);    
    component monthOfBirthBits      = Num2Bits(monthOfBirthBitsLength);
    component yearOfBirthBits       = Num2Bits(yearOfBirthBitsLength);
    component schoolBits            = Num2Bits(schoolBitsLength);
    component yearGraduationBits    = Num2Bits(yearGraduationBitsLength);
    component majorBits             = Num2Bits(majorBitsLength);
    component modeOfStudyBits       = Num2Bits(modeOfStudyBitsLength);
    component decisionNumberBits    = Num2Bits(decisionNumberBitsLength);
    component classificationBits    = Num2Bits(classificationBitsLength);

    component commitmentHasher = Pedersen(totalBitsLength);

    var previousLength = 0;

    // name
    nameBits.in <== name;
    for (var i = 0; i < nameBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== nameBits.out[i];
    }
    previousLength += nameBitsLength;

    // day of birth
    dayOfBirthBits.in <== dateOfBirth[0];
    for (var i = 0; i < dayOfBirthBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== dayOfBirthBits.out[i];
    }
    previousLength += dayOfBirthBitsLength;

    // month of birth
    monthOfBirthBits.in <== dateOfBirth[1];
    for (var i = 0; i < monthOfBirthBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== monthOfBirthBits.out[i];
    }
    previousLength += monthOfBirthBitsLength;

    // year of birth
    yearOfBirthBits.in <== dateOfBirth[2];
    for (var i = 0; i < yearOfBirthBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== yearOfBirthBits.out[i];
    }
    previousLength += yearOfBirthBitsLength;

    // school
    schoolBits.in <== school;
    for (var i = 0; i < schoolBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== schoolBits.out[i];
    }
    previousLength += schoolBitsLength;

    // yearGraduation
    yearGraduationBits.in <== yearGraduation;
    for (var i = 0; i < yearGraduationBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== yearGraduationBits.out[i];
    }
    previousLength += yearGraduationBitsLength;

    // major
    majorBits.in <== major;
    for (var i = 0; i < majorBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== majorBits.out[i];
    }
    previousLength += majorBitsLength;

    // model
    modeOfStudyBits.in <== modeOfStudy;
    for (var i = 0; i < modeOfStudyBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== modeOfStudyBits.out[i];
    }
    previousLength += modeOfStudyBitsLength;

    // decisionNumber
    decisionNumberBits.in <== decisionNumber;
    for (var i = 0; i < decisionNumberBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== decisionNumberBits.out[i];
    }
    previousLength += decisionNumberBitsLength;

    // classification
    classificationBits.in   <== classification;
    for (var i = 0; i < classificationBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== classificationBits.out[i];
    }

    commitment <== commitmentHasher.out[0];
}

component main {public [major]} = Zuni();