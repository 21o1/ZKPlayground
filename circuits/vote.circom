pragma circom 2.0.0;

template Vote() {
    signal input voter_key;
    signal input vote;
    signal output valid;

    
    vote * (vote - 1) === 0;

   
    valid <== vote;
}

component main = Vote();
