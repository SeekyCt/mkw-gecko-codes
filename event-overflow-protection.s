# Checks if EVENT data would fit in the buffer before copying it in
# This prevents you crashing from sending too many items

#==============#
# C2           #
#==============#
# 8065bbd4 PAL #
# Unported     #
#==============#

# r12 free
# r27: entry pointer
# r30: total size

# get data size
lbz r12, 0x1c (r27)

# check if it would fit in the buffer
add r12, r30, r12
cmpwi r12, 0xe0
blt+ noblock

# set type to none if not to ignore
li r0, 0
stb r0, 0x19 (r27)

noblock:
#default instruction
lbz r0, 0x19 (r27)
