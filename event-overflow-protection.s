# Checks if EVENT data would fit in the buffer before copying it in
# This prevents you crashing from sending too many items
# See http://wiki.tockdom.com/wiki/MKWii_Network_Protocol/EVENT

#=================#
# C2              #
#=================#
# 806575B8 NTSC-U #
# 8065B240 NTSC-J #
# 8065BBD4 PAL    #
# 80649EEC NTSC-K #
#=================#

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
