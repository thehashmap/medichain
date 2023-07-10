const { expect } = require("chai");

describe("MediChain", function () {
  let mediChain;
  let owner;
  let user1;
  let user2;

  beforeEach(async function () {
    const MediChain = await ethers.getContractFactory("MediChain");
    mediChain = await MediChain.deploy();
    await mediChain.deployed();

    [owner, user1, user2] = await ethers.getSigners();
  });

  it("should create a new record", async function () {
    const data = "Sample record data";
    await mediChain.createRecord(data);

    const record = await mediChain.getRecord(1);
    expect(record).to.exist;
    expect(record.id).to.equal(1);
    expect(record.recordData).to.equal(data);
    expect(record.owner).to.equal(owner.address);
  });

  it("should grant and revoke access to a record", async function () {
    const data = "Sample record data";
    await mediChain.createRecord(data);

    await mediChain.grantAccess(1, user1.address);
    let hasAccess = await mediChain.getRecordAccess(1, user1.address);
    expect(hasAccess).to.be.true;

    await mediChain.revokeAccess(1, user1.address);
    hasAccess = await mediChain.getRecordAccess(1, user1.address);
    expect(hasAccess).to.be.false;
  });

  it("should update a record", async function () {
    const initialData = "Initial record data";
    await mediChain.createRecord(initialData);

    const newData = "Updated record data";
    await mediChain.updateRecord(1, newData);

    const record = await mediChain.getRecord(1);
    expect(record.recordData).to.equal(newData);
    expect(record.owner).to.equal(owner.address);
  });

  it("should restrict unauthorized access to a record", async function () {
    const data = "Sample record data";
    await mediChain.createRecord(data);

    // User1 should not have access initially
    let hasAccess = await mediChain.getRecordAccess(1, user1.address);
    expect(hasAccess).to.be.false;

    // User1 cannot retrieve the record
    await expect(mediChain.connect(user1).getRecord(1)).to.be.revertedWith(
      "Unauthorized access to record"
    );

    // Grant access to User1
    await mediChain.grantAccess(1, user1.address);
    hasAccess = await mediChain.getRecordAccess(1, user1.address);
    expect(hasAccess).to.be.true;

    // User1 can now retrieve the record
    const record = await mediChain.connect(user1).getRecord(1);
    expect(record.recordData).to.equal(data);

    // Revoke access from User1
    await mediChain.revokeAccess(1, user1.address);
    hasAccess = await mediChain.getRecordAccess(1, user1.address);
    expect(hasAccess).to.be.false;

    // User1 cannot retrieve the record anymore
    await expect(mediChain.connect(user1).getRecord(1)).to.be.revertedWith(
      "Unauthorized access to record"
    );
  });
});
