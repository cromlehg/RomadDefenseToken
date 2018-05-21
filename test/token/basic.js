import assertRevert from '../helpers/assertRevert';

export default function (Token, accounts) {
  let token;

  beforeEach(async function () {
    token = await Token.new();
    await token.setSaleAgent(accounts[0]);
  });

  it('should return correct balances after transfer', async function () {
    await token.mint(accounts[0], 100);
    await token.transfer(accounts[1], 100);
    const balance0 = await token.balanceOf(accounts[0]);
    assert.equal(balance0, 0);
    const balance1 = await token.balanceOf(accounts[1]);
    assert.equal(balance1, 100);
  });

  it('should throw an error when trying to transfer more than balance', async function () {
    await token.mint(accounts[0], 100);
    await assertRevert(token.transfer(accounts[1], 101));
  });

  it('should throw an error when trying to transfer to 0x0', async function () {
    await token.mint(accounts[0], 100);
    await assertRevert(token.transfer(0x0, 100));
  });
}
