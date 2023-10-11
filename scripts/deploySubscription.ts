import { toNano } from 'ton-core';
import { Subscription } from '../wrappers/Subscription';
import { NetworkProvider } from '@ton-community/blueprint';

export async function run(provider: NetworkProvider) {
    const subscription = provider.open(await Subscription.fromInit());

    await subscription.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(subscription.address);

    // run methods on `subscription`
}
