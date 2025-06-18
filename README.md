# 🔐 ZKPlayground — A Zero-Knowledge Proof System with Circom + SnarkJS

Welcome to **ZKPlayground** — a hands-on project that walks you through building and understanding zk-SNARKs from scratch using [Circom](https://docs.circom.io) and [SnarkJS](https://github.com/iden3/snarkjs). Whether you're a cryptography enthusiast or a web3 developer, this system helps you explore the magic of proving knowledge **without revealing it**.

---

## 📦 What's Inside?

### Project Structure
```
ZKPlayground/
├── circuits/               # Circom source files (e.g. multiplier, hash, ownership)
├── build/                  # Compiled artifacts: .r1cs, .wasm, .zkey, witness files
├── scripts/                # Shell scripts for compiling and proving
├── frontend/public/        # Placeholder for in-browser proof generation
├── input.json              # Example input file for testing
└── powersOfTau28_hez_final_10.ptau  # Phase 1 trusted setup file (created locally)
```

---

## ✨ Key Features

- ✔️ Circom 2.0+ support with clean, verified circuits
- 🔐 Groth16 zk-SNARK proof generation
- 📜 Trust setup with `powersoftau` (done locally)
- ⚙️ End-to-end CLI workflow
- 💻 Browser integration-ready
- ✅ Real testable examples (multiplication, hash preimage, ownership check)

---

## 🔧 Setup Instructions (CLI Workflow)

### 1. Install Requirements

```bash
npm install -g snarkjs
cargo install --locked --git https://github.com/iden3/circom circom
```

Make sure you can run:
```bash
circom --version
snarkjs --version
```

---

### 2. Compile a Circuit

For example, to compile the multiplier circuit:

```bash
circom circuits/multiplier.circom --r1cs --wasm --sym -o build
```

---

### 3. Generate Trusted Setup (ptau)

Generate your own Phase 1 file:

```bash
snarkjs powersoftau new bn128 12 pot12_0000.ptau
snarkjs powersoftau contribute pot12_0000.ptau powersOfTau28_hez_final_10.ptau --name="my contribution" -v
snarkjs powersoftau prepare phase2 powersOfTau28_hez_final_10.ptau powersOfTau28_hez_final_10_prepared.ptau
```

---

### 4. Groth16 Setup (Phase 2)

```bash
snarkjs groth16 setup build/multiplier.r1cs powersOfTau28_hez_final_10_prepared.ptau build/multiplier_setup.zkey
snarkjs zkey export verificationkey build/multiplier_setup.zkey verification_key.json
```

---

### 5. Create Inputs

Edit `input.json`:

```json
{
  "a": "3",
  "b": "11"
}
```

---

### 6. Generate Witness

```bash
node build/multiplier_js/generate_witness.js build/multiplier_js/multiplier.wasm input.json build/multiplier.wtns
```

---

### 7. Generate Proof

```bash
snarkjs groth16 prove build/multiplier_setup.zkey build/multiplier.wtns proof.json public.json
```

---

### 8. Verify the Proof

```bash
snarkjs groth16 verify verification_key.json public.json proof.json
```

✅ If everything is correct, you'll see `OK`.

---

## 🌐 Optional: Frontend Integration

Use `multiplier.wasm`, `public.json`, and `proof.json` to verify proofs in the browser using SnarkJS.

---

## 🧠 Circuits Included

- `multiplier.circom`: Proves that a * b = c
- `vote.circom`: Proves you voted without revealing who
- `hash_preimage.circom`: SHA256-based preimage proof (requires circomlib)
- `ownership.circom`: Verifies equality (e.g., identity ownership)

---

## 🎯 Why Use This Project?

- Learn how zk-SNARKs work from the ground up
- Build your own circuits and plug into any frontend
- Gain real-world proof generation experience
- Can be used for voting, private identity, or blockchain smart contracts

---

## 💡 Tips

- If you get `ENOENT` errors, double-check file paths and extensions.
- Make sure `.ptau` files are valid — run `snarkjs powersoftau verify` to confirm.
- Always use Circom 2.x or newer.

---

## 🤝 Credits

- Circom by iden3
- SnarkJS by iden3
- Circuit templates inspired by the ZK community

---

Happy proving! 🧙‍♂️✨