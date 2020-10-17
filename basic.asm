        IN
loops1  BRZ     end
        STO     number
loops2  OUT
# This is to end the sequence when the value
# "1" has been reached
        SUB     one
        BRZ     end
# Command at location "end" is just HLT which is
# equivalent to '000' so I can just load that
# to get a value of 0.
        LDA     end
        STO     count
        LDA     ten

# This is to allow me to change what I'm
# dividing by depending on the size of the number
# I'm dividing. This allows me to divide by 2
# slightly quicker for larger numbers by
# initially dividing by 20.
upd_h   STO     half
        ADD     half
        STO     divisor
div     LDA     number
        BR      div_2

# Here I add the "half" of the "divisor" if I
# was able to subtract the "divisor"
contain STO     number
        LDA     count
        ADD     half
        STO     count
        LDA     number
# If "number" is zero at this point
# then it was even
        BRZ     is_even
# Divide by 2 to know if f is even
# Store amount of times divided in case it is
div_2   SUB     divisor
        BRP     contain

# Here I check if I'm already dividing by 2.
# If by subtracting "half" from one I end up at 0
# I know that I have already gone through the
# subtracting 2 loop. If I have I can also safely
# say that if I have reached this point the number
# is odd. Otherwise I change to changing the
# number being subtracted to 2.
        LDA     one
        SUB     half
        BRZ     is_odd
# I opted to only use 2 and 20, and not 200, as
# the subtraction numbers as the assignment
# document mentioned that the main test range
# would be 1 - 100
        LDA     one
        BR      upd_h

# As "f" would be 2n+1 to reach this point I
# changed 3f+1 to 6n+4, this requires more
# registers to calculate but also allows me to
# calculate half of the resulting number before
# the number itself, therefore giving me the next
# number in the sequence as well.
# For the result to be over 999 "count" must also
# be >= 166 (Because 6*165 + 4 = 994)
is_odd  LDA     count
        SUB     max
# Here I only let it continue if "count" is less than 166
        BRP     over
        LDA     count   # n
        ADD     count   # 2n
        ADD     count   # 3n
# Because it was odd, "divisor" will be 2 as it
# has to go through that 2 subtraction loop at
# least once
        ADD     divisor # 3n+2
# This is the next number in the sequence so I
# store it. This means I don't need to divide
# again and can just output it.
        STO     number
        ADD     number  # 6n+4
# Here I can output 2 values in the sequence
# within 3 lines
        OUT
        LDA     number  # 3n+2
        BR      loops2

is_even LDA     count
        BR      loops1

over    LDA     end
        OUT
end     HLT

one     DAT     001
ten     DAT     010
# Holds the number being subtracted
divisor DAT     000
# Holds half the number being subtracted
half    DAT     000
# Holds the number being divided
number  DAT     000
# Holds the result of the division
count   DAT     000
# Holds check num to stop going > 999
max     DAT     166
