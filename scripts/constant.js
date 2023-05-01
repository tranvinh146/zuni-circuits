const byteLengthOfData = {
  name: 31,
  dateOfBirth: {
    day: 2,
    month: 2,
    year: 4,
  },
  school: 31,
  yearGraduation: 4,
  major: 31,
  classification: 16,
  modeOfStudy: 16,
  serialNumber: 16,
  referenceNumber: 16,
  dateOfIssue: {
    day: 2,
    month: 2,
    year: 4,
  },
};

const MERKLE_TREE_HEIGHT = 20;

module.exports = { byteLengthOfData, MERKLE_TREE_HEIGHT };
