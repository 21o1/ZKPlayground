pragma circom 2.0.0;

template Vote() {
    signal input vote;
    signal output result;

    result <== vote;
}

component main = Vote();
