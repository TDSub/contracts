import { Blockchain, SandboxContract } from '@ton-community/sandbox';
import { toNano } from 'ton-core';
import { Subscription } from '../wrappers/Subscription';
import '@ton-community/test-utils';

describe('Subscription', () => {
    let blockchain: Blockchain;
    let subscription: SandboxContract<Subscription>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        subscription = blockchain.openContract(await Subscription.fromInit());

        const deployer = await blockchain.treasury('deployer');

        const deployResult = await subscription.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: subscription.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and subscription are ready to use
    });
});
