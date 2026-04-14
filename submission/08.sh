# Create a time-based CSV script that would lock funds for 6 months (using 30-day months)
# Time-based CSV uses 512-second units with the type flag (bit 22) set
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

#!/bin/bash

publicKey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"

# HASH160 of pubkey
pkh=$(echo -n "$publicKey" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p)

script="03a77640b27576a914${pkh}88ac"

echo "$script"