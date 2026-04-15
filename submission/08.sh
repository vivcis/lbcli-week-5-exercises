# Create a time-based CSV script that would lock funds for 6 months (using 30-day months)
# Time-based CSV uses 512-second units with the type flag (bit 22) set
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

# #!/bin/bash

# publicKey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"

# # HASH160 of pubkey
# pkh=$(echo -n "$publicKey" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p)

# script="03a77640b27576a914${pkh}88ac"

# echo "$script"

#!/bin/bash

publicKey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"

# 6 months × 30 days × 24 hours × 3600 seconds
seconds=$((6 * 30 * 24 * 3600))     

#divide by 512-second units
units=$((seconds / 512))     

#set bit 22 (the type flag = 0x400000) to mark this as time-based
sequence=$((units | 0x400000))       

#encode sequence as little-endian minimally-encoded script number

seq_hex=$(printf '%06x' $sequence)  
seq_le="${seq_hex:4:2}${seq_hex:2:2}${seq_hex:0:2}"   
seq_len=$(printf '%02x' $((${#seq_le} / 2)))          

# HASH160 the pubkey (SHA256 then RIPEMD160)
pkh=$(echo -n "$publicKey" \
  | xxd -r -p \
  | openssl dgst -sha256 -binary \
  | openssl dgst -rmd160 -binary \
  | xxd -p)

pkh_len=$(printf '%02x' $((${#pkh} / 2)))   # "14" (20 bytes)

#assemble the script ---
# <push seq> <seq_le> OP_CSV OP_DROP OP_DUP OP_HASH160 <push 20> <pkh> OP_EQUALVERIFY OP_CHECKSIG
OP_CSV="b2"
OP_DROP="75"
OP_DUP="76"
OP_HASH160="a9"
OP_EQUALVERIFY="88"
OP_CHECKSIG="ac"

script="${seq_len}${seq_le}${OP_CSV}${OP_DROP}${OP_DUP}${OP_HASH160}${pkh_len}${pkh}${OP_EQUALVERIFY}${OP_CHECKSIG}"

echo "$script"