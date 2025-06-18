pragma circom 2.0.0;

template Ownership() {
    signal input owner;
    signal input check;
    signal output verified;

    verified <== 1 - (owner - check)*(owner - check);
}

component main = Ownership();
