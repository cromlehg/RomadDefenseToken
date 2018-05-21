import EVMRevert from '../helpers/EVMRevert';

export default function (Token, accounts) {
  let token;

  beforeEach(async function () {
    token = await Token.new();
    await token.setSaleAgent(accounts[1]);
  });

  it('should add accounts to pending list until mint is finished', async function () {
    await token.mint(accounts[2], 100);
    assert.equal(await token.KYCPending(accounts[2]), false);
    await token.addToKYCPending(accounts[2]);
    assert.equal(await token.KYCPending(accounts[2]), true);
    await token.mint(accounts[3], 100);
    assert.equal(await token.KYCPending(accounts[3]), false);
    await token.addToKYCPending(accounts[3], {from: accounts[1]});
    assert.equal(await token.KYCPending(accounts[3]), true);
    await token.addToKYCPending(accounts[4], {from: accounts[2]}).should.be.rejectedWith(EVMRevert);
    await token.finishMinting();
    await token.addToKYCPending(accounts[4]).should.be.rejectedWith(EVMRevert);
    await token.addToKYCPending(accounts[4], {from: accounts[2]}).should.be.rejectedWith(EVMRevert);
  });
}
