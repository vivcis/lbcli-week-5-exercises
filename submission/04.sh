# Create a CLTV script with a timestamp of 1495584032 and public key below:
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

#!/bin/bash

publicKey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"
locktime=1495584032

# locktime as 4-byte little-endian hex
locktime_hex=$(printf '%08x' $locktime)
locktime_le="${locktime_hex:6:2}${locktime_hex:4:2}${locktime_hex:2:2}${locktime_hex:0:2}"

#HASH160 of pubkey
pkh=$(echo -n "$publicKey" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p)

script="04${locktime_le}b17576a914${pkh}88ac"

echo "$script"