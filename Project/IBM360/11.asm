Sum start 0								; segment declaration
;STM R14, R12, 12(R13)						; storing the original values of registers
BALR R12, R0							; storing PC value in R12
using *, R12							; declaration of R12 as the base register
;ST R13, Reg13							; storing R13 in Reg13

LA R8,0
LA R9,1
lop_odd:
LA R7,0
chk_odd:
AR R7,R9
LA R1,0
LR R5,R8
LR R6,R8
SR R5,R7
AR R6,R7
XR R3,R3
XR R4,R4
IC R3,str(R5)
IC R4,str(R6)
CR R3,R4
BZ chk_odd
SR R7,R9
LR R1,R7
AR R1,R7
AR R1,R9
C R1,sz
BL pass_max_odd
ST R1,sz
LR R1,R8
SR R1,R7
ST R1,le
LR R1,R8
AR R1,R7
ST R1,ri
pass_max_odd:
AR R8,R9
LA R10,0
IC R11,str(R8)
CR R10,R11
BNZ lop_odd



LA R8,0
LA R9,1
lop_even:
LA R7,0
SR R7,R9
chk_even:
AR R7,R9
LA R1,0
LR R5,R8
LR R6,R8
SR R5,R7
AR R6,R7
AR R6,R7
XR R3,R3
XR R4,R4
IC R3,str(R5)
IC R4,str(R6)
CR R3,R4
BZ chk_even
SR R7,R9
LR R1,R7
AR R1,R7
AR R1,R9
AR R1,R9
C R1,sz
BL pass_max_even
ST R1,sz
LR R1,R8
SR R1,R7
ST R1,le
LR R1,R8
AR R1,R7
AR R1,R9
ST R1,ri
pass_max_even:
AR R8,R9
LA R10,0
IC R11,str(R8)
CR R10,R11
BNZ lop_even


;L  R13, Reg13 							; restoring R13 from Reg13
;LM R14, R12, 12(R13)						; restoring the original values of registers
BR R14								; returning control to OS

str DC C'banana'
sz DS F
le DS F
ri DS F

;Reg13 DS F	
end									; end of segment
