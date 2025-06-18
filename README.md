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