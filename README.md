---
title: "ZKPlayground"
description: "A complete zero-knowledge proof system using Circom and SnarkJS"
---


---

## 🌐 How to Use the Frontend Verifier (Browser-Based)

You can verify zk-SNARK proofs in the browser using the frontend folder included in this project.

###  Folder Structure for Frontend

```
frontend/
├── index.html                 # UI to trigger verification
├── verifier.js                # JavaScript logic using SnarkJS
├── proof.json                 # Generated proof file
├── public.json                # Public inputs used for proof
├── verificationkey.json      # Exported from .zkey setup
```

###  Step-by-Step

#### 1. Run These Commands from Your Project Root:

```bash
cd ~/zkSnarkUltimateSystemV1
snarkjs groth16 prove build/multipliersetup.zkey build/multiplier.wtns proof.json public.json
snarkjs zkey export verificationkey build/multipliersetup.zkey verificationkey.json
```

#### 2. Copy Files to Frontend

```bash
cp proof.json public.json verificationkey.json frontend/
```

#### 3. Start a Local Web Server

```bash
cd frontend
python3 -m http.server 8000
```

#### 4. Visit in Browser

Open:
```
http://localhost:8000
```

Click the “Verify Proof” button — it will check your proof in-browser and display:

```
 Proof is valid!
```

Or show ❌ if it's invalid.

---

##  Notes

- You must replace the placeholder `.json` files in the frontend with real ones from CLI.
- The file paths in `verifier.js` assume all proof files are in the same directory as `index.html`.
- Make sure you use `public.json` as an array (e.g., `["33"]`), not an object.

## FRONTEND VERIFICATION (BROWSER)

To verify zk-SNARK proofs in the browser, follow these steps:

### 1. Run from the project root:

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

Click the "Verify Proof" button. If everything is correct, it will display:

```
✅ Proof is valid!
```

Or show a failure message if the proof is incorrect.

Make sure:
- The `.json` files are valid and complete
- You are using the correct verification key and proof output from your own circuit setup