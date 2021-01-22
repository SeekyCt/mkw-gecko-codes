# A joke code I made to make more than 60 seconds pass on the timer before the minutes increase
# Currently only supports powers of 2 because I needed it to be beneath a certain size

#=================#
# C2              #
#=================#
# 807ED7B8 NTSC-U #
# 807F7924 NTSC-J #
# 807F82B8 PAL    #
# 807E6678 NTSC-K #
#=================#

# r3 - Raceinfo pointer
# r4 - Destination Timer struct

# raceinfo->timerManager
lwz r3, 0x14 (r3)

# copy _a and ms
lhz r0, 0x18 (r3)
sth 0, 0x8 (r4)
lbz r0, 0x1a (r3)
stb r0, 0xa (r4)

# custom minute calc

# calculate seconds total
lhz r5, 0x14 (r3)
mulli r5, r5, 60
lbz r0, 0x16 (r3)
add r5, r5, r0

# calculate "minutes" and remainder
rlwinm r0, r5, 26, 6, 31
rlwinm r5, r5, 0, 26, 31
stb r5, 0x6 (r4)
sth r0, 0x4 (r4)
blr
