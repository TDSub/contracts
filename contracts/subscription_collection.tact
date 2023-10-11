import "@stdlib/deploy";
import "@stdlib/ownable";
import "./models.tact";
import "./messages.tact";
import "./subscription.tact";

contract SubscriptionCollection with Deployable, Ownable {
    owner: Address;
    creator: Address;
    next_item_index: Int as uint32 = 0;
    rate_count: Int as uint32 = 0;
    rate_sum: Int as uint64 = 0;
    plans: map<Int as uint8, SubscriptionPlan>;

    init(information: DeployCollectionMsg) {
        self.owner = information.owner;
        self.creator = sender();
        self.plans = information.plans;
    }

    receive(msg: MintSubscriptionMsg) {
        let subscriptionInit: StateInit = self.getSubscriptionInit(msg.planIndex);
        send(SendParameters{
            to: contractAddress(subscriptionInit),
            value: context().value,
            mode: SendIgnoreErrors,
            body: TransferMsg{
                query_id: 0,
                new_owner: sender()
            }.toCell(),
            code: subscriptionInit.code
        });

        self.next_item_index = self.next_item_index + 1;
        // can't mint if subscription_red_flag is true
        // everyone can mint subscription based on plans
        // plans price must be based on ton but we add other jettons later
    }

    receive("Withdraw") {
        // can't mint if subscription_red_flag is true
        // withdraw money based on a specific period for example monthly 
    }

    receive("Rate") {
        // only receive message from subscription contract 
        // each subscription can only send rate message once
        // increase the rate_count by 1
        // increase rate_sum by rate of rate message
    }

    receive("RedFlagNumber") {
        // only receive message from subscription contract 
        // returns current red flag number
    }

    receive("RedFlag") {
        // only receive message from subscription contract 
        // each subscription can only send one RedFlag message by red flag number 
    }

    get fun plans(): map<Int as uint8, SubscriptionPlan> {
        return self.plans;
    }

    get fun getSubscriptionInit(planIndex: Int): StateInit {
        return initOf Subscription(SubscriptionInitMsg{
            owner: self.owner, 
            collectionAddress: myAddress(), 
            itemIndex: self.next_item_index, 
            plan: self.getPlan(planIndex)
        });
    }

    get fun getPlan(planIndex: Int): SubscriptionPlan {
        let plan: SubscriptionPlan? = self.plans.get(planIndex);
        require(plan != null, "plan index is wrong");
        return plan!!;
    }
}