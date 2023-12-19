MAIN start 0							; segment declaration
STM R14, R12, 12(R13)					; storing the register values of the parent segment in its RegSaveArea variable
BALR R12, R0							; storing PC value in R12
using *, R12							; declaration of R12 as the base register
ST R13,SAVEAREA_4
LA R13,SAVEAREA


	L 		R0,N_INPUT
    L 		R15,=V(FIB)
    BALR 	R14,R15
    ST 		R4,FIB_RES
	L 		R0,N_INPUT
	L 		R15,=V(FACT)
	BALR 	R14,R15
	S 		R4,FIB_RES
	ST 		R4,RES


L  R13,SAVEAREA_4
LM R14,R12,12(R13)
BR R14

N_INPUT 	DC F'5'
FIB_RES  	DS F
RES   		DS F
SAVEAREA  	DS F
SAVEAREA_4	DS 17F

end


FACT	START	0
	STM     R14,R12,12(R13)
	BALR    R12,R0
	USING   *,R12
	ST 		R13,SAVEAREA_4(R8)
	LA 		R13,SAVEAREA(R8)



	LR      R5,R0
	C		R0,ONE
	BNH		OUT
	S		R0,ONE
	LA		R8,72(R8)
	BALR 	R14,R15
	S		R8,=F'72'
	MR		R4,R4
OUT:		LR R4,R5

L  	R13,SAVEAREA_4(R8)
LM	R14,R3,12(R13)
LM	R5,R12,40(R13)
BR R14

ONE     	DC F'1'
SAVEAREA	DS	F
SAVEAREA_4	DS	719F

end

FIB start 0								; segment declaration
STM R14, R12, 12(R13)					; storing the original values of registers
BALR R12, R0							; storing PC value in R12
using *, R12							; declaration of R12 as the base register
	LR 		R7,R0						; limit
	LA    	R1,0           				; f(n-2)=0
	LA    	R2,1           				; f(n-1)=1
	SR 		R7,R2
LOOP:		              				; for n=2 to nn
	LR    	R3,R2						; f(n)=f(n-1)
	AR    	R3,R1						; f(n)=f(n-1)+f(n-2)
	LR    	R1,R2						; f(n-2)=f(n-1)
	LR   	R2,R3						; f(n-1)=f(n)
	BCT  	R7,LOOP     				; endfor n
OUT:
	LR R4,R3

LM	R14,R3,12(R13)
LM	R5,R12,40(R13)
BR	R14

end										; end of segment
