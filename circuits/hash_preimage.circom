pragma circom 2.0.0;

include "sha256/sha256.circom";

template HashPreimage() {
    signal input preimage[2];
    signal output hash[2];

    component hasher = Sha256(2);

    // First: set all inputs
    for (var i = 0; i < 2; i++) {
        hasher.in[i] <== preimage[i];
    }

    // Then: read all outputs
    for (var i = 0; i < 2; i++) {
        hash[i] <== hasher.out[i];
    }
}

component main = HashPreimage();
