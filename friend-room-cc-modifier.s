# A modification of Force Room CC by XeR to only activate in friend rooms that someone asked me to make
# For the original code see https://mkwii.com/showthread.php?tid=109

#=================#
# C2              #
#=================#
# 80659D7C NTSC-U #
# 80661324 NTSC-J #
# 80661CB8 PAL    #
# 8064FFD0 NTSC-K #
#=================#

.set REGION, 'P'

.if REGION == 'U'
  .set RACEDATA, 0x809B8F68
.elseif REGION == 'J'
  .set RACEDATA, 0x809BC788
.elseif REGION == 'P'
  .set RACEDATA, 0x809bd728
.elseif REGION == 'K'
  .set RACEDATA, 0x809ABD68
.else
  .err
.endif

#Get racedata pointer
lis r3, RACEDATA@ha
lwz r3, RACEDATA@l (r3)

#Get the gamemode number from the in menu scenario
lwz r3, 0x1760 (r3)

#Check if it's a friend room
cmpwi r3, 7
bne default

#Force CC
# 1 = 100cc
# 2 = 150cc
# 3 = Mirror
li r28, 2

default:
stb r28, 63(r29)
