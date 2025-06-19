# ZK Playground: Universal zk-SNARK Verifier (Frontend)

This project is a fully-featured browser-based verifier for zk-SNARK circuits using Circom and SnarkJS. It supports verification of multiple circuit types and allows both local and uploaded file usage.

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

## How to Use

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


## In-Browser Proof Generation

This verifier is built for **verification only**, but it can be extended to:
- Load circuit `.wasm` and `.zkey` files
- Accept input.json via UI
- Generate the witness and proof client-side

Let us know if you'd like that bundled next.

---

## License

MIT — use freely for educational, experimental, and production purposes.
