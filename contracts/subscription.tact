import "@stdlib/deploy";
import "@stdlib/ownable";
import "./models.tact";
import "./messages.tact";

contract Subscription with Deployable, Ownable {
    
    owner: Address;
    collectionAddress: Address;
    itemIndex: Int as int32;
    expirationDate: Int as int32;
    isSendRate: Bool = false;
    
    init(msg: SubscriptionInitMsg) {
        // only subscriptionCollection Can send this message
        self.owner = msg.owner;
        self.collectionAddress = msg.collectionAddress;
        self.itemIndex = msg.itemIndex;
        self.expirationDate = now() + msg.plan.extendTime;
    }

    receive(msg: TransferMsg) {
        self.requireOwner();
        self.owner = msg.new_owner;
    }
}
