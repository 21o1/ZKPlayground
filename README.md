# ZK Playground: Universal zk-SNARK Verifier (Frontend)

 browser-based verifier for zk-SNARK circuits using Circom and SnarkJS, supports verification of multiple circuit types and allows both local and uploaded file usage.
## Trusted Setup & Prove generation (Auto)
Just use the scripts file to run all instructions you need to compile and build your file
## Trusted Setup & Prove generation (MANUALE)
### Compiling:
First of all you need to compile the circuits to obtain a vaild verficiation file 
`circom circuits/{circuit_name}.circom --r1cs --wasm --sym -o build` -> you need to add 'build' folder in addition , to build circ's alter files in
By running this instruction we will get these files:
- `r1sc` General format of the circuit's constraint system
- `wasm` compiled circuit in WebAssembly format (used to generate the witness)
- `sym` symbols of debug
### Power Of Tau:
To generate trusted setup you need first to generate a vaild ptau file which is a universal structured reference string (SRS), allows zksnark proof generation for many circuits using the same elliptic curve parameters , ptau or power of tau file , gained this name because it encodes a secret  `τ` and its powers -> `[1, τ, τ², τ³, ..., τⁿ]` {this sequence used in eliptic curve pairings for proving and verfying}
So to Generate the phase 1 of the trusted setup you need to get this ptau file either local file trusted by your machine only or general one from any popular domain (they’re trusted because of public ceremonies and transparency ) , so in our case we will use local ptau file generated locally
`snarkjs powersoftau new bn128 12 pot12_0000.ptau`

So by this we've already generate phase one ptau file but not fully , to contribute randomness, complete Phase 1 securely we need to:

`snarkjs powersoftau contribute pot12_0000.ptau powersOfTau28_hez_final_10.ptau --name="First Contribution" -v`

### Final Set-up And Key Generation
Now we are ready to get our final trusted setup (circuit-specific Setup, Groth16 Phase 2) And Generate circuit key 
`snarkjs groth16 setup build/vote.r1cs powersOfTau28_hez_final_10.ptau build/vote_setup.zkey` 
By Running this command we will setup  TSU (Trusted SetUp) and Generate the zksnarks proving key for our circuit (im using vote circuit key as example)
### Witness Generation
We need to creat witness file '.wtns' from circuit and input , this file will contain  the vars and intermediate signals and output of our input file and circuit so by it we could prove that the circuit computed correctly without revealing the computation logic or the actual private inputs, so it done by this instruction:
`node build/vote_js/generate_witness.js build/vote_js/vote.wasm input.json build/vote.wtns`
### In Case Of Any Errors 
If you faced this kind of errors `[ERROR] snarkJS: Powers of tau is not prepared.` , In this case you need to prepare the PTAU file before the phase to and this could be done by
`snarkjs powersoftau prepare phase2 powersOfTau28_hez_final_10.ptau powersOfTau28_hez_final_10_prepared.ptau`
then run 
`snarkjs groth16 setup build/vote.r1cs powersOfTau28_hez_final_10.ptau build/vote_setup.zkey`
### Proving 
To prove the input and gain the final result you have to use 
`snarkjs groth16 prove build/vote_setup.zkey build/vote.wtns vote_proof.json vote_public.json`
This will generate:
- `vote_proof.json` zk proof data
- `vote_public.json` public  signals need to verify
### CLI(TUI) 
To verfiy the input in terminal, cmd you could easily 
`snarkjs groth16 verify vote_verification_key.json vote_public.json vote_proof.json`
### Front End Usage
To check in browser you have to export the zkey file first by
`snarkjs zkey export verificationkey build/vote_setup.zkey vote_verification_key.json`
Using snarkjs.groth16.verfy( ) in browser (snarkJs) with these files:
- `vote_verification_key.json`
- `vote_proof.json`
- `vote_public.json`
So this enables real time proof verfication in front end. (USED VOTE CIRCUIT AS EXAMPLE)
Educational Version Only.
## Supported Circuits

- `vote.circom`: verify a binary vote (0 or 1)
- `multiplier.circom`: check a × b = c without revealing a and b
- `ownership.circom`: prove knowledge of a specific value (like password match)
- `hash_preimage.circom`: verify preimage of a SHA256 hash using circomlib

---

## Features

- Circuit selector dropdown
- Upload custom JSON files (`proof.json`, `public.json`, `verification_key.json`)
- Uses SnarkJS to verify Groth16 proofs in-browser
- Built-in input summary field
- Elegant interface with error handling and visual feedback

---

## Additional Usage
1. Place the frontend files into a directory with your circuit outputs.
2. Ensure these files are present for each circuit you want to verify:
    - `{circuit}_proof.json`
    - `{circuit}_public.json`
    - `{circuit}_verification_key.json`
3. Optionally upload these files manually in the UI.
4. Open `index.html` in your browser.
5. Select a circuit, review the input summary, click **Verify Proof**.

If the proof is correct, a green confirmation appears.
If invalid, you'll see an error message and failure details.

---

## File Naming Convention

| Circuit        | Required Files                             |
|----------------|--------------------------------------------|
| `vote`         | vote_proof.json, vote_public.json, vote_verification_key.json |
| `multiplier`   | multiplier_proof.json, multiplier_public.json, multiplier_verification_key.json |
| `ownership`    | ownership_proof.json, ownership_public.json, ownership_verification_key.json |
| `hash_preimage`| hash_preimage_proof.json, hash_preimage_public.json, hash_preimage_verification_key.json |

---



