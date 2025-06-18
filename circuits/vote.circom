pragma circom 2.0.0;

template Vote() {
    signal input voter_key;
    signal input vote;
    signal output valid;

    // Only allow votes of 0 or 1
    vote * (vote - 1) === 0;

    // valid = vote (1 = valid vote, 0 = invalid)
    valid <== vote;
}

component main = Vote();
