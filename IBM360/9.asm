MAIN start 0							; segment declaration
STM R14, R12, 12(R13)					; storing the register values of the parent segment in its RegSaveArea variable
BALR R12, R0							; storing PC value in R12
using *, R12							; declaration of R12 as the base register
ST R13,SAVEAREA_4
LA R13,SAVEAREA


	L 		R2,N_INPUT
	L		R3,N_INPUT
	LA		R4,0
    	L 		R15,=V(SOLVE)
    	BALR 		R14,R15
	ST 		R4,RES


L  R13,SAVEAREA_4
LM R14,R12,12(R13)
BR R14

N_INPUT 		DC F'4'
RES   		DS F
SAVEAREA  	DS F
SAVEAREA_4	DS 17F

end


SOLVE	START		0
	STM     		R14,R12,12(R13)
	BALR    		R12,R0
	USING   		*,R12
	ST 		R13,SAVEAREA_4(R8)
	LA 		R13,SAVEAREA(R8)


;R2 = t
;R3 = n
;R4 = rt



	LR		R1,R2
LOOP1:
	LA		R1,1(R1)
	CR		R1,R3
	BNL		END_LOOP1
	SLL		R1,2
	SLL		R2,2
	L		R6,CELLS(R1)
	S		R6,CELLS(R2)			; R6 = cells[i] - cells[t]
	SRL		R1,2
	SRL		R2,2
	LR		R7,R1
	SR		R7,R2				; R7 = i-t
	LPR		R6,R6				; R6 = |R6|
	C		R6,=F'0'
	BE		OUT				; if(tmp1==0) return
	CR		R6,R7
	BE		OUT				; if(tmp1==tmp2) return
	B		LOOP1
END_LOOP1:

	C		R2,=F'0'
	BNE		NOT_T_ZERO
	LA		R4,1(R4)
	B		OUT

NOT_T_ZERO:
	LA 		R1,0
	S		R2,ONE
LOOP2:
	SLL		R2,2
	ST		R1,CELLS(R2)
	SRL		R2,2
	LR		R9,R2
	LA		R8,72(R8)
	BALR 		R14,R15
	S		R8,=F'72'
	LR		R2,R9
	LA		R1,1(R1)
	CR		R1,R3
	BL		LOOP2


















OUT:

L  	R13,SAVEAREA_4(R8)
LM	R14,R1,12(R13)
LM	R5,R12,40(R13)
BR R14

ONE     		DC F'1'
TWO		DC F'2'
CELLS		DC	100 F'0'
SAVEAREA		DS	F
SAVEAREA_4	DS	719F

end