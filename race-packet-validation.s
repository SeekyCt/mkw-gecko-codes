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

# HEADER Record
lbz       r9, 8(r5)
cmpwi     r9, 0x10
bnelr-

# RACEHEADER_1 Record
lbz       r9, 9(r5)
cmpwi     r9, 0
beq-      loc_valid_RACEHEADER_1_record
cmplwi    r9, 0x28
bnelr-

loc_valid_RACEHEADER_1_record:
# RACEHEADER_2 Record
lbz       r10, 0xA(r5)
cmpwi     r10, 0
beq-      loc_valid_RACEHEADER_2_record
cmplwi    r10, 0x28
bnelr-

loc_valid_RACEHEADER_2_record:
# ROOM / SELECT Record
lbz       r8, 0xB(r5)
andi.     r7, r8, 0xFB
beq+      loc_valid_ROOM_SELECT_record
cmplwi    r8, 0x38
bnelr-

loc_valid_ROOM_SELECT_record:
# RACEDATA Record
lbz       r7, 0xC(r5)
andi.     r11, r7, 0x7F
beq-      loc_valid_RACEDATA_record
cmplwi    r7, 0x40
bnelr-

loc_valid_RACEDATA_record:
# USER Record
lbz       r11, 0xD(r5)
cmpwi     r11, 0
beq+      loc_valid_USER_record
cmplwi    r11, 0xC0
bnelr-
add       r9, r5, r9
add       r9, r9, r10
add       r9, r9, r8
add       r9, r9, r7
lhz       r9, 0x14(r9)
cmpwi     r9, 2
bnelr-

loc_valid_USER_record:
# ITEM Record
lbz       r9, 0xE(r5)
andi.     r10, r9, 0xEF
beq-      loc_valid_ITEM_record
cmplwi    r9, 8
bnelr-

loc_valid_ITEM_record:
# EVENT Record
lbz       r9, 0xF(r5)
cmpwi     r9, 0
beq-      loc_valid_EVENT_record
addi      r9, r9, -0x18
clrlwi    r9, r9, 24
cmplwi    r9, 0xE0
bgtlr-

loc_valid_EVENT_record:
stwu      r1, -0x30(r1)
