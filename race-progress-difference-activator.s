# A code made for Formula Kart Wii to set a value when your race progress is a certain amount less than 1st place's
# See http://wiki.tockdom.com/wiki/Formula_Kart_Wii

#====#
# C0 #
#====#

.set REGION, 'P'

.if REGION == 'P'
  .set RACEDATA, 0x809bd728
  .set RACEINFO, 0x809bd730
.else
  .err
.endif

# the 'bl trick'
mflr r12
bl enddata
.long RACEINFO
.long RACEDATA
.long 0x80000198 # output location
.float 2.0 # max difference
enddata:
mflr r3

# get difference threshold
lfs f0, 12 (r3)

# get EVA addr
lwz r10, 8 (r3)

# load racedata pointer
lwz r11, 4 (r3)
lwz r11, 0 (r11)

# load raceinfo pointer
lwz r3, 0 (r3)
lwz r3, 0 (r3)

# null pointer check - if raceinfo exists then racedata must anyway
cmpwi r3, 0
beq end

# TODO: this might crash if you're spectating and player id 0 dcs
# load HUD pid and convert it to player array index
# racedata.main = 0x1c
# main.scenarios[0] = 0x4
# scenarios[0].settings = 0xb48
# settings.hudPlayerIds[0] = 0x1c
# total = 0xb84
lbz r9, 0xb84 (r11)
rlwinm r9, r9, 2, 0, 29 # multiply by 4

# get player id in 1st and convert it to player array index
# raceinfo->playerIdInEachPosition[0]
lwz r5, 0x18 (r3)
lbz r5, 0 (r5)
rlwinm r5, r5, 2, 0, 29 # multiply by 4

# get raceinfo player pointers
lwz r3, 0xc (r3)
lwzx r5, r3, r5
lwzx r9, r3, r9

# get lap progresses and calculate difference
lfs f2, 0xc (r5)
lfs f3, 0xc (r9)
fsubs f2, f2, f3

# if greater than threshold, output 1
li r3, 0
fcmpu cr0, f2, f0
ble+ end
li r3, 1

end:
stw r3, 0 (r10)
mtlr r12
blr
