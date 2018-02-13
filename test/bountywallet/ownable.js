import assertRevert from '../helpers/assertRevert';

export default function (BountyWallet, accounts) {
  let bountywallet;

  beforeEach(async function () {
   bountywallet = await BountyWallet.new();
  });

  it('should have an owner', async function () {
    const owner = await bountywallet.owner();
    assert.isTrue(owner !== 0);
  });

  it('changes owner after transfer', async function () {
    const other = accounts[1];
    await bountywallet.transferOwnership(other);
    const owner = await bountywallet.owner();
    assert.isTrue(owner === other);
  });

  it('should prevent non-owners from transfering', async function () {
    const other = accounts[2];
    const owner = await bountywallet.owner();
    assert.isTrue(owner !== other);
    await assertRevert(bountywallet.transferOwnership(other, {from: other}));
  });

  it('should guard ownership against stuck state', async function () {
    const originalOwner = await bountywallet.owner();
    await assertRevert(bountywallet.transferOwnership(null, {from: originalOwner}));
  });
}
