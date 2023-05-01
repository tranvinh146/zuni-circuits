pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/pedersen.circom";

// computes Pedersen(Degree)
template CommitmentHasher() {
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
    
    signal output commitment;

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

    component commitmentHasher = Pedersen(totalBitsLength);

    var previousLength = 0;

    // name
    nameBits.in <== name;
    for (var i = 0; i < nameBitsLength; i++) {
        commitmentHasher.in[i] <== nameBits.out[i];
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

    // classification
    classificationBits.in   <== classification;
    for (var i = 0; i < classificationBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== classificationBits.out[i];
    }
    previousLength += classificationBitsLength;

    // model
    modeOfStudyBits.in <== modeOfStudy;
    for (var i = 0; i < modeOfStudyBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== modeOfStudyBits.out[i];
    }
    previousLength += modeOfStudyBitsLength;

    // serialNumber
    serialNumberBits.in <== serialNumber;
    for (var i = 0; i < serialNumberBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== serialNumberBits.out[i];
    }
    previousLength += serialNumberBitsLength;

    // referenceNumber
    referenceNumberBits.in <== referenceNumber;
    for (var i = 0; i < referenceNumberBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== referenceNumberBits.out[i];
    }
    previousLength += referenceNumberBitsLength;

    // day of issue
    dayOfIssueBits.in <== dateOfIssue[0];
    for (var i = 0; i < dayOfIssueBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== dayOfIssueBits.out[i];
    }
    previousLength += dayOfIssueBitsLength;

    // month of issue
    monthOfIssueBits.in <== dateOfIssue[1];
    for (var i = 0; i < monthOfIssueBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== monthOfIssueBits.out[i];
    }
    previousLength += monthOfIssueBitsLength;

    // year of issue
    yearOfIssueBits.in <== dateOfIssue[2];
    for (var i = 0; i < yearOfIssueBitsLength; i++) {
        commitmentHasher.in[i + previousLength] <== yearOfIssueBits.out[i];
    }
    previousLength += yearOfIssueBitsLength;

    // ensure the length correct
    previousLength === totalBitsLength;

    commitment <== commitmentHasher.out[0];
}