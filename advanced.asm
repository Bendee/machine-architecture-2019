        IN
loop    BRZ     end
        STO     number
        OUT
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
div_2   SUB     divisor
        BRP     contain

# Here I check if I'm already dividing by 2.
# If by subtracting "half" from one I end up at 0
# I know that i have already gone through the
# subtracting 2 loop. If I have I can also safely
# say that if I have reached this point the numbe
# is odd. Otherwise I change to changing the
# number being subtracted to 2. 
        LDA     one
        SUB     half
        BRZ     is_odd
# I opted to only use 2 and 20, and not 200, as
# the subtraction numbers, as the assignment
# document mentioned that the main test range
# would be 1 - 100
        LDA     one
        BR      upd_h

# As "f" would be 2n+1 to reach this point, I was
# able to simplify (3f+1)/2 to 3n+2 which means I
# only need to divide by 2 once.
# For the result to be over 999 "count" must
# also be >= 333 (Because 3*332 + 2 = 998)
is_odd  LDA     count
        SUB     max
# If postive will end up over 999
        BRP     over
# Adding 3 times is quicker/uses less registers.
# I could speed up halving of the resulting number
# by calculating 3n/2 + 1 but due to the extra
# division this would require some logic
# surrounding the handling of that case and
# would therefore add a fair few registers.
        LDA     count
        ADD     count
        ADD     count
# Because it was odd, "divisor" will be 2 as it
# has to go through that 2 subtraction loop
# at least once
        ADD     divisor
        BR      loop

# "count" holds half the starting value
is_even LDA     count
        BR      loop

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
max     DAT     333
