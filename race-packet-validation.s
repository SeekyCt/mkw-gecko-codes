# Checks the section sizes of incoming RACE packets are valid, and ignores it if not
# This should act as an antifreeze for some freeze codes and also as RCE protection
# for the same exploit as https://mkwii.com/showthread.php?tid=1543
# See http://wiki.tockdom.com/wiki/MKWii_Network_Protocol#Main_records_.28.22RACE.22_records.29

#=================#
# C2              #
#=================#
# 806555FC NTSC-U #
# 806590F0 NTSC-J #
# 80659a84 PAL    #
# 80647D9C NTSC-K #
#=================#

# r3 RKnetController ptr
# r4 aid
# r5 packet ptr
# r6 size

header:
lbz r0, 0x8 (r5)
cmpwi r0, 0
beqlr # this specific section would freeze if 0
cmpwi r0, 0x10
bnelr

rh1:
lbz r0, 0x9 (r5)
cmpwi r0, 0
beq rh2
cmpwi r0, 0x28
bnelr

rh2:
lbz r0, 0xa (r5)
cmpwi r0, 0
beq roomSelect
cmpwi r0, 0x28
bnelr

roomSelect:
lbz r0, 0xb (r5)
andi. r0, r0, ~0x4 & 0xff
beq racedata
cmpwi r0, 0x38
bnelr

racedata:
lbz r0, 0xc (r5)
andi. r0, r0, ~0x80 & 0xff
beq user
cmpwi r0, 0x40
bnelr

user:
lbz r0, 0xd (r5)
cmpwi r0, 0
beq item
cmpwi r0, 0xc0
bnelr

item:
lbz r0, 0xe (r5)
andi. r0, r0, ~0x10 & 0xff
beq event
cmpwi r0, 0x8
bnelr

event:
lbz r0, 0xf (r5)
cmpwi r0, 0
beq allow
cmpwi r0, 0x18
bltlr
cmpwi r0, 0xf8
bgtlr

allow:
# default instruction
stwu r1, -0x30 (r1)
