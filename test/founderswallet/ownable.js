import assertRevert from '../helpers/assertRevert';

export default function (FoundersWallet, accounts) {
  let foundersWallet;

  beforeEach(async function () {
   foundersWallet = await FoundersWallet.new();
  });

  it('should have an owner', async function () {
    const owner = await foundersWallet.owner();
    assert.isTrue(owner !== 0);
  });

  it('changes owner after transfer', async function () {
    const other = accounts[1];
    await foundersWallet.transferOwnership(other);
    const owner = await foundersWallet.owner();
    assert.isTrue(owner === other);
  });

  it('should prevent non-owners from transfering', async function () {
    const other = accounts[2];
    const owner = await foundersWallet.owner();
    assert.isTrue(owner !== other);
    await assertRevert(foundersWallet.transferOwnership(other, {from: other}));
  });

  it('should guard ownership against stuck state', async function () {
    const originalOwner = await foundersWallet.owner();
    await assertRevert(foundersWallet.transferOwnership(null, {from: originalOwner}));
  });
}
