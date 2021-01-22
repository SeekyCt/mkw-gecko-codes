# A now obsolete code made for Formula Kart Wii to prevent position tracking issues from disconnected players and negative laps
# See http://wiki.tockdom.com/wiki/Formula_Kart_Wii

# For a disconnected player, their lap progress is set to -1.0 * playerId, which causes them to become ahead of players with
# negative laps (which Formula Kart uses to increase the count to 50). This code worked around this by not registering the player
# as disconnected until the player in 1st was on their final lap, which is generally late enough to ensure nobody would have a
# low enough lap to be counted as behind the disconnected players

#====#
# C0 #
#====#

.set REGION, 'P'

.if REGION == 'U'
  .set RACEINFO, 0x809B8F70
  .set RKNETCONTROLLER, 0x809BD918
.elseif REGION == 'J'
  .set RACEINFO, 0x809BC790
  .set RKNETCONTROLLER, 0x809C1138
.elseif REGION == 'P'
  .set RACEINFO, 0x809bd730
  .set RKNETCONTROLLER, 0x809c20d8
.elseif REGION == 'K'
  .set RACEINFO, 0x809ABD70
  .set RKNETCONTROLLER, 0x809B0718
.else
  .err
.endif

# get the raceinfo pointer
lis r12, RACEINFO@ha
lwz r12, RACEINFO@l (r12)
cmpwi r12, 0
beq- end

# get the RKNetController pointer
lis r3, RKNETCONTROLLER@ha
lwz r3, RKNETCONTROLLER@l (r3)
cmpwi r3, 0
beq end

# get the id in first place
# raceinfo->playerIdInEachPosition[0]
lwz r11, 0x18 (r12)
lbz r11, 0 (r11)

# get the RaceInfoPlayers ptr
lwz r12, 0xC (r12)

# get the RaceInfoPlayer in first place
# raceinfo->players[i]
rlwinm r11, r11, 2, 0, 29
lwzx r11, r12, r11

# if it's their final lap
# player->lap
lbz r11, 0x25 (r11)
cmpwi r11, 3
beq- dodcs

# or if everyone else dced (you'd keep racing alone otherwise)
# RKNetController->subs[RKNetController->currentSub].connectionCount == 1
lwz r0, 0x291C (r3)
mulli r0, r0, 0x58
add r11, r3, r0
lwz r11, 0x40 (r11)
cmpwi r11, 1
bne end

dodcs:
# get RKNetController->disconnectedPlayerIds
lwz r11, 0x2930 (r3)

# loop through every player id
li r9, 1
li r10, 0
looptop:
slw r0, r9, r10
and. r0, r0, r11
beq+ nodc

# if player id is dced, set flag
rlwinm r5, r10, 2, 0, 29
lwzx r5, r12, r5
lwz r0, 0x38 (r5)
ori r0, r0, 0x20
stw r0, 0x38 (r5)

nodc:
addi r10, r10, 1
cmpwi r10, 12
blt+ looptop

end:
blr
