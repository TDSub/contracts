import "./models.tact";

message DeployCollectionMsg {
    owner: Address;
    plans: map<Int as uint8, SubscriptionPlan>;
}

message SubscriptionInitMsg {
    owner: Address;
    collectionAddress: Address; 
    itemIndex: Int; 
    plan: SubscriptionPlan;
}

message TransferMsg {
    query_id: Int as uint64;
    new_owner: Address;
}

message MintSubscriptionMsg {
    planIndex: Int as uint8;
}