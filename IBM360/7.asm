Replace start 0
                        ; START OF INIT
STM R14, R12, 12(R13)
BALR R12, R0
using *, R12
ST R13, Reg13
LA R13, RegSaveArea

XR R6,R6

LA R9,1
XR R10,R10
LA R1,0
lop:
LR R2,R1
XR R3,R3
chk:
XR R4,R4
XR R5,R5
IC R4,x(R2)
IC R5,a(R3)
CR R4,R5
BNZ bad
AR R2,R9
AR R3,R9
XR R4,R4
IC R4,a(R3)
CR R4,R10
BZ good
B chk

good:
L R4,cnt
AR R4,R9
ST R4,cnt
LR R1,R2

XR R4,R4
lop_add:
XR R5,R5
IC R5,b(R4)
STC R5,ans(R6)
AR R6,R9
AR R4,R9
XR R5,R5
IC R5,b(R4)
CR R5,R10
BNZ lop_add

B aft
bad:
XR R4,R4
IC R4,x(R1)
STC R4,ans(R6)
AR R6,R9
AR R1,R9


aft:
XR R4,R4
IC R4,x(R1)
CR R4,R10
BNZ lop



EXIT:
L  R13, Reg13
LM R14, R12, 12(R13)
BR R14

RegSaveArea DS 15 F	
Reg13 DS F
x DC C'abcabc'
a DC C'ab'
b DC C'abc'
cnt DS F
ans DS 50C
end