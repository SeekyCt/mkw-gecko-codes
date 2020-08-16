#==========#
# Settings #
#==========#

.set INTERVAL, 300 # Delay in frames between item uses (NNNN)
.set EVAADDRESS, 0x0C98 # Set to any free exception vector area address offset (PPPP)

#==================#
# Input Editing C2 #
#==================#
# 80521300 PAL     #
# 8051CE8C NTSC-U  #
# 8050F324 NTSC-K  #
# 80520C80 NTSC-J  #
#==================#

lis r11, 0x8000
lwz r12, EVAADDRESS (r11) # Loads timer from memory
cmpwi r12, INTERVAL #Checks if it's time
beq- on
off:

# todo: consider either removing this entirely to still allow user inputs or make it always happen to shorten the code, recommended by Vega
rlwinm r0, r0, 0, 30, 28 # Clears the bit for the item input
b end

on:
ori r0, r0, 0x4 # Turns on the bit for the item input
end:
sth r0, 0x002C (r30) # Default instruction (stores the input to memory)

#==========#
# Timer C0 #
#==========#

lis r11, 0x8000
lwz r12, EVAADDRESS (r11) # Gets current timer value
addi r12, r12, 1 # Increments by 1
cmpwi r12, INTERVAL # If the timer has reached the value where items were pressed, restarts it
ble+ end
li r12, 0
end:
stw r12, EVAADDRESS (r11)
blr
