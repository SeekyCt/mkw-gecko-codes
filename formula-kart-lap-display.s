# A code made for Formula Kart Wii to display the lap count in the milliseconds timer with an offset from the negative initial amount
# See http://wiki.tockdom.com/wiki/Formula_Kart_Wii
# Uses JoshuaMK's millisecond timer modification address https://www.mkwii.com/showthread.php?tid=1448

.set REGION, 'P'

.if REGION == 'U'
  .set RACEDATA, 0x809B8F68
  .set RACEINFO, 0x809B8F70
.elseif REGION == 'J'
  .set RACEDATA, 0x809BC788
  .set RACEINFO, 0x809BC790
.elseif REGION == 'P'
  .set RACEDATA, 0x809bd728
  .set RACEINFO, 0x809bd730
.elseif REGION == 'K'
  .set RACEDATA, 0x809ABD68
  .set RACEINFO, 0x809ABD70
.else
  .err
.endif


# Load HUD pid and convert it to player array index
# racedata.main = 0x1c
# main.scenarios[0] = 0x4
# scenarios[0].settings = 0xb48
# settings.hudPlayerIds[0] = 0x1c
# total = 0xb84
lis r26, RACEDATA@ha
lwz r26, RACEDATA@l (r26)
lbz r26, 0xb84 (r26)
rlwinm r26, r26, 2, 0, 29 # multiply by 4

# Get raceinfo pointer
lis r28, RACEINFO@ha
lwz r28, RACEINFO@l (r28)

# Get player from player array
lwz r28, 0xC (r28)
lwzx r28, r28, r26

# Get current lap of player, store to r28 to set timer
lbz r28, 0x25 (r28)
