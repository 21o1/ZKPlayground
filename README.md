---
title: "ZKPlayground"
description: "A complete zero-knowledge proof system using Circom and SnarkJS"
---

# ZKPLAYGROUND — ZERO-KNOWLEDGE PROOF SYSTEM

ZKPlayground is a hands-on implementation of a zero-knowledge proof system using [Circom](https://docs.circom.io) and [SnarkJS](https://github.com/iden3/snarkjs). It walks through the full pipeline of zk-SNARKs, from circuit design to proof generation and browser-based verification.

The goal of this project is to offer a working template for developers and researchers interested in building or understanding zk-SNARK applications.

---

## OVERVIEW

Zero-knowledge proofs allow someone to prove knowledge of information without revealing the actual data. In zk-SNARKs (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge), this is done through cryptographic protocols that result in compact, verifiable proofs.

This project demonstrates:
- Writing Circom circuits to encode logic
- Running a local trusted setup (Groth16)
- Generating and verifying zk-SNARKs using CLI and browser
- Exporting verifiers for smart contracts or web apps

---

## CIRCUITS INCLUDED

### multiplier.circom
Proves that `a * b = c` without revealing the inputs directly.

### ownership.circom
Verifies whether two private values are equal, useful for identity or access checks.

### hash_preimage.circom
Demonstrates proving knowledge of a preimage to a SHA256 hash. Requires `circomlib`.

---

## SETUP AND USAGE (CLI WORKFLOW)

### 1. Install Requirements

```bash
npm install -g snarkjs
cargo install --locked --git https://github.com/iden3/circom circom
```

Verify:
```bash
circom --version
snarkjs --version
```

---

### 2. Compile a Circuit

```bash
circom circuits/multiplier.circom --r1cs --wasm --sym -o build
```

Outputs:
- `multiplier.r1cs`: Circuit representation
- `multiplier.wasm`: Wasm used for witness generation
- `multiplier.sym`: Debug symbols for circuits

---

### 3. Trusted Setup

#### Phase 1 (powers of tau):

```bash
snarkjs powersoftau new bn128 12 pot12_0000.ptau
snarkjs powersoftau contribute pot12_0000.ptau powersOfTau28_hez_final_10.ptau --name="Your Name" -v
snarkjs powersoftau prepare phase2 powersOfTau28_hez_final_10.ptau powersOfTau28_hez_final_10_prepared.ptau
```

#### Phase 2 (Groth16 setup):

```bash
snarkjs groth16 setup build/multiplier.r1cs powersOfTau28_hez_final_10_prepared.ptau build/multiplier_setup.zkey
snarkjs zkey export verificationkey build/multiplier_setup.zkey verification_key.json
```

---

### 4. Create Inputs

Prepare an `input.json`:
```json
{
  "a": "3",
  "b": "11"
}
```

---

### 5. Generate Witness

```bash
node build/multiplier_js/generate_witness.js build/multiplier_js/multiplier.wasm input.json build/multiplier.wtns
```

---

### 6. Generate and Verify Proof

```bash
snarkjs groth16 prove build/multiplier_setup.zkey build/multiplier.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json
```

Expected output:
```
OK
```

---

## FRONTEND VERIFICATION (BROWSER)

To verify zk-SNARK proofs in the browser, follow these steps:

### 1. Generate your proof (from project root):

```bash
snarkjs groth16 prove build/multiplier_setup.zkey build/multiplier.wtns proof.json public.json
snarkjs zkey export verificationkey build/multiplier_setup.zkey verification_key.json
```

### 2. Copy the generated files into your frontend folder:

```bash
cp proof.json public.json verification_key.json frontend/
```

### 3. Launch a local HTTP server:

```bash
cd frontend
python3 -m http.server 8000
```

### 4. Open your browser at:

```
http://localhost:8000
```

Click the "Verify Proof" button in the interface. If the files are correct and valid, it will display:
```
Proof is valid!
```

---

## FOLDER STRUCTURE

```
ZKPlayground/
├── circuits/               # Circom source files
├── build/                  # Compiled outputs: .r1cs, .wasm, .wtns, .zkey
├── frontend/               # Browser-based verification
├── input.json              # Circuit input for testing
├── powersOfTau*.ptau       # Trusted setup files
├── proof.json              # zk-SNARK proof
├── public.json             # Public input used in verification
└── verification_key.json   # Key used to verify proof
```

---

## EXTENDING THE PROJECT

- Add new `.circom` files to `circuits/`
- Adjust `input.json` structure based on circuit inputs
- Replace `multiplier` naming in commands with your new circuit name
- Use `snarkjs zkey export solidityverifier` to get a smart contract for on-chain verification

---

## RECOMMENDED USE CASES

- Private voting
- Anonymous credential verification
- Identity/authentication with zero-knowledge
- Blockchain on-chain verification (using exported Solidity verifier)

---

## CREDITS

- Circom and SnarkJS by iden3
- SHA256 circuits by circomlib
- Inspired by the zk community

For questions or suggestions, please contact the project maintainer.

---

## ADDITIONAL CIRCUITS AND HOW TO USE THEM

This project includes multiple example circuits beyond the multiplier. Each has its own logic and purpose. Here's how to compile and use each of them:

### 1. vote.circom

This circuit is a basic example of a zero-knowledge voting system. It allows a user to prove that they voted for a valid option without revealing which option.

#### Compile

```bash
circom circuits/vote.circom --r1cs --wasm --sym -o build
```

#### Example Input (input.json)

```json
{
  "voter_key": 123,
  "vote": 1
}
```

Note: You will need to design your circuit and verifier logic to prevent invalid values (like voting twice or voting outside allowed options).

Then continue with the same steps as the multiplier circuit:

```bash
snarkjs groth16 setup build/vote.r1cs powersOfTau28_hez_final_10_prepared.ptau build/vote_setup.zkey
snarkjs zkey export verificationkey build/vote_setup.zkey vote_verification_key.json
node build/vote_js/generate_witness.js build/vote_js/vote.wasm input.json build/vote.wtns
snarkjs groth16 prove build/vote_setup.zkey build/vote.wtns vote_proof.json vote_public.json
snarkjs groth16 verify vote_verification_key.json vote_public.json vote_proof.json
```

---

### 2. ownership.circom

Checks whether an input matches a known "owner" value.

#### Compile

```bash
circom circuits/ownership.circom --r1cs --wasm --sym -o build
```

#### Example Input

```json
{
  "owner": "42",
  "check": "42"
}
```

Proceed with setup and proof generation as with the previous circuits.

---

### 3. hash_preimage.circom

This circuit proves that a user knows the preimage of a given SHA256 hash. It depends on `circomlib`.

#### Requirements

Before compiling, make sure you clone circomlib and use the `-l` flag:

```bash
git clone https://github.com/iden3/circomlib.git
```

#### Compile

```bash
circom circuits/hash_preimage.circom --r1cs --wasm --sym -o build -l ./circomlib/circuits
```

#### Example Input

```json
{
  "preimage": ["123", "456"]
}
```

You must format your `preimage` values to match the expected input length (usually 512 bits split into 2 field elements).

Then proceed with:

```bash
snarkjs groth16 setup build/hash_preimage.r1cs powersOfTau28_hez_final_10_prepared.ptau build/hash_preimage_setup.zkey
snarkjs zkey export verificationkey build/hash_preimage_setup.zkey hash_verification_key.json
node build/hash_preimage_js/generate_witness.js build/hash_preimage_js/hash_preimage.wasm input.json build/hash_preimage.wtns
snarkjs groth16 prove build/hash_preimage_setup.zkey build/hash_preimage.wtns hash_proof.json hash_public.json
snarkjs groth16 verify hash_verification_key.json hash_public.json hash_proof.json
```

---

## SUMMARY: COMPILING AND USING CIRCUITS

| Circuit           | Purpose                      | Depends on circomlib? |
|------------------|-------------------------------|------------------------|
| multiplier.circom | Proves `a * b = c`           | No                     |
| vote.circom       | Private vote verification     | No                     |
| ownership.circom  | Identity match                | No                     |
| hash_preimage.circom | Prove knowledge of hash input | Yes                    |

Each circuit can be compiled and verified using the standard Circom + SnarkJS pipeline shown above. You simply replace `multiplier` with your circuit name throughout the commands.
