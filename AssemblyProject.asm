org 100h
.DATA
 SBOX	DB 63H,7cH,77H,7bH,0f2H,6bH,6fH,0c5H,30H,01H,67H,2bH,0feH,0d7H,0abH,76H
     	DB 0caH,82H,0c9H,7dH,0faH,59H,47H,0f0H,0adH,0d4H,0a2H,0afH,9cH,0a4H,72H,0c0H
     	DB 0b7H,0fdH,93H,26H,36H,3fH,0f7H,0ccH,34H,0a5H,0e5H,0f1H,71H,0d8H,31H,15H
     	DB 04H,0c7H,23H,0c3H,18H,96H,05H,9aH,07H,12H,80H,0e2H,0ebH,27H,0b2H,75H
     	DB 09H,83H,2cH,1aH,1bH,6eH,5aH,0a0H,52H,3bH,0d6H,0b3H,29H,0e3H,2fH,84H
     	DB 53H,0d1H,00H,0edH,20H,0fcH,0b1H,5bH,6aH,0cbH,0beH,39H,4aH,4cH,58H,0cfH
     	DB 0d0H,0efH,0aaH,0fbH,43H,4dH,33H,85H,45H,0f9H,02H,7fH,50H,3cH,9fH,0a8H
     	DB 51H,0a3H,40H,8fH,92H,9dH,38H,0f5H,0bcH,0b6H,0daH,21H,10H,0ffH,0f3H,0d2H
    	DB 0cdH,0cH,13H,0ecH,5fH,97H,44H,17H,0c4H,0a7H,7eH,3dH,64H,5dH,19H,73H
     	DB 60H,81H,4fH,0dcH,22H,2aH,90H,88H,46H,0eeH,0b8H,14H,0deH,5eH,0bH,0dbH
     	DB 0e0H,32H,3aH,0aH,49H,06H,24H,5cH,0c2H,0d3H,0acH,62H,91H,95H,0e4H,79H
     	DB 0e7H,0c8H,37H,6dH,8dH,0d5H,4eH,0a9H,6cH,56H,0f4H,0eaH,65H,7aH,0aeH,08H
     	DB 0baH,78H,25H,2eH,1cH,0a6H,0b4H,0c6H,0e8H,0ddH,74H,1fH,4bH,0bdH,8bH,8aH
     	DB 70H,3eH,0b5H,66H,48H,03H,0f6H,0eH,61H,35H,57H,0b9H,86H,0c1H,1dH,9eH
     	DB 0e1H,0f8H,98H,11H,69H,0d9H,8eH,94H,9bH,1eH,87H,0e9H,0ceH,55H,28H,0dfH
     	DB 8cH,0a1H,89H,0dH,0bfH,0e6H,42H,68H,41H,99H,2dH,0fH,0b0H,54H,0bbH,16H
   	 
  SBOXRows  EQU 16
  SBOXCol   EQU 16       
;==================================================================
    Rcon db 01H, 02H, 04H, 08H, 10H, 20H, 40H, 80H, 1BH, 36H
         db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
         db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
         db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H 
         
    rconRows EQU 4
    rconCol  EQU 10      
  
;==================================================================
    MixCol DB 02H,03H,01H,01H,01H,02H,03H,01H,01H,01H,02H,03H,03H,01H,01H,02H
    
    
    
    tempMixCol DB 00H,00H,00H,00H
          
  
;==================================================================
  totalColNum EQU 4
  totalRowNum EQU 4
  state  DB 16 DUP(0)
  enterStateMsg db "Please enter State as a matrix : ", 13, 10, '$' 
  outputMsg db "output : ", 13, 10, '$'
;==================================================================
   cipherKey DB 16 DUP(0)
    enterCipherMsg db "Please enter CipherKey as a matrix : ", 13, 10, '$'  
    printNewLine db 13, 10,'$' 
    printSpace db " ",'$'
   tempCol DB 4 DUP(?)  
        
   keyColNum EQU 4
   keyRow   EQU 4
   
   currentRound DB 0     ;Note currentRound is ACtual Round -1 

  ;algorithm to access row x col y =(currentRow*colNum)+currentCol
;=============================================================================================== 
  stateBuffer  db 17,?, 16 dup(0)
  cipherBuffer db 17,?, 16 dup(0)  
  
  askStateMsg db "Press (1) to enter state as a string and (2) to enter state as a matrix : ", 13, 10, '$'  
  askCipherMsg db "Press (1) to enter Cipher as a string and (2) to enter Cipher as a matrix : ", 13, 10, '$'
  
  enterCipherAsStringMsg db "Please enter CipherKey as a String : ", 13, 10, '$' 
  enterStateAsStringMsg db "Please enter State as a String : ", 13, 10, '$' 

;===============================================================================================

.CODE  

ShiftRows MACRO array 
 
    MOV DI,1 ;Used For RowIndex Start with 1 
    ;SI Will be Used For Col Index
    
    NextRowLoop:
    MOV BP,DI;   
    
    
    ShiftRowAgain:;START OF Loop that shifts each row n Times stops when BP==0  
    
    
    ;CalcualtionIndex
    MOV AX,totalColNum
    MUL DI
    MOV SI,AX ;Col is Now Calcualted starting at its respective 0
    MOV BX,SI ;Same For BX which is used to store n-1          
              
              
              
    MOV AL,array[SI];Saving First Element  
    
    MOV CX,totalColNum
    DEC CX;Will shift 3 times
   
   
    ShiftLoop:
    INC SI
    MOV DL,array[SI]
    MOV array[BX],DL
   
    MOV BX,SI    
    
    Loop ShiftLoop  
   
    MOV array[SI],AL;put Saved ElementLast
    DEC BP        
    
    
    JNZ ShiftRowAgain ;END OF Loop that shifts each row n Times stops when BP==0 
    
    INC DI
    CMP DI,totalColNum
    JNZ NextRowLoop     
    
 ShiftRows ENDM   
;==================================================================
  
  AddRoundKey MACRO st,k
    Mov SI,0 ;XORING START AT 0  
    Mov AX,totalColNum
    Mov BL,totalRowNum
    Mul BL
    Mov CX,AX ;TotalNumber of iterations 16 times (Total Number of cells)
    
    IDKLOOP:
    MOV AL,k[SI]
    XOR st[SI],AL   
    INC SI
    LOOP IDKLOOP      
                        
AddRoundKey ENDM 
 
;================================================================== 
SubBytes MACRO k,sb
;For this function we replace all keys with proper SBOX values
;The idea is if given 19 the 1 is the row of the SBOX and the 9 is the colmn
;Then the algorithm of (currRow*totalCol)+currCol
;To seperate the values this can be done by first anding with 0FH to get 09H
;Then shift left*4 and and with 0FH to get 01H  

XOR AX,AX ;resetting AX
XOR DX,DX ;resetting DX
XOR BX,BX ;resetting BX

MOV AL,totalColNum
MOV BL,totalRowNum
Mul BL
MOV CX,AX
MOV SI,0
StartLoops: 
MOV DL,k[SI]
MOV BL,DL
AND BL,0FH ;now BL contains Lower Value only  (COL INDEX)
SHR DL, 4  ;Shifting AL 4 Times
AND DL,0FH ;now DL contains Higher Value only (ROW INDEX)
;Now we will calculate index in SBOX
MOV AX,SBOXCol
MUL DX
ADD AX,BX
MOV DI,AX
MOV AL,sb[DI]
MOV k[SI],AL





INC SI    
LOOP StartLoops    
    
SubBytes ENDM  
;================================================================== 
KeySchedule MACRO rk,sb
    MOV SI,0
    MOV CX,4
    ;Copy The Col
    StartColCopy:
    MOV AX,SI
    MOV BL,4 
    MUL BL
    MOV DI,AX ;SI FOR tempCol DI For key
    ADD DI,3  ;To Acces Forth row
    
    MOV AL,rk[DI]
    MOV tempCol[SI],AL   
                     
    INC SI
                     
    LOOP StartColCopy  
    ;Now we preform RoWord on tempCol
    MOV SI,0 
    MOV AL,tempCol[SI]
    
    MOV CX,keyColNum
    DEC CX
    
    shift:
    MOV DI,SI
    INC SI
    MOV BL,tempCol[SI]
    MOV tempCol[DI],BL
    LOOP shift
                        
    MOV tempCol[SI],AL
    ;Now Preform Subbytes on tempCol 
    
    MOV CX,keyColNum 
    MOV SI,0 
    XOR BX,BX
    subb:
    MOV BL,tempCol[SI]
    MOV AL,SBOX[BX]
    MOV tempCol[SI],AL 
    
    INC SI
    Loop subb
    ;XOR KEY,RCON,TEMPCOL
    MOV BP,0 
    MOV CX,keyColNum  
    
    XORLOOP: 
     
    
    MOV SI,BP;Index TempCol
     
    MOV AX,SI 
    MOV DI,SI;DI IS INDEX RCON  
    MOV BL,rconCol
    MUL BL
    ADD AL,currentRound
    MOV DI,AX
    
    MOV AX,SI
    MOV BL,keyColNum
    MUL BL
    MOV SI,AX
    
    MOV AL,tempCol[BP]
    XOR rk[SI],AL 
    
    MOV AL,Rcon[DI]
    XOR rk[SI],AL
    
    INC BP
    
    LOOP XORLOOP
    ;Now we have the First Col of round key we Xor it with other 3 cols in key
    
    MOV BX,0  
    INC BX
    FINALXOR:
    
      MOV CX,0
     INNERXOR:
       
       MOV AX,CX 
       MOV DL,keyColNum
       MUL DL 
       MOV SI,AX
        
       MOV DI,SI
       ADD DI,BX
       MOV SI,DI
       DEC SI
           
       MOV AL,rk[SI]
       XOR rk[DI],AL
       
     INC CX
     CMP CX,4 
     JNZ INNERXOR
    
    
     INC BX
     CMP BX,4
     JNZ FINALXOR 
     INC currentRound

KeySchedule ENDM          
;================================================================== 
MixColumns MACRO st 
  Mov DL,0;Curr Col  
  LoopOverState:
  
  
  
  MOV BL,0;MixCol Row
  LoopOverMixCol:
  
  
  MOV BH,0;Each Element COL FOR MIXCOL, ROW FOR STATE
  LoopOverRow:  
  MOV AX,04H
  MUL BH
   
  ADD AL,DL
  MOV SI,AX;Current State Index
  
  MOV AX,04H
  MUL BL
  ADD AL,BH 
  MOV DI,AX;INDEX MIXCOL
  
  CMP MixCol[DI],1
  JNZ SKIP1  
  
  MOV CX,0
  MOV CL,BL
  MOV BP,CX
  MOV CL,st[SI]
  XOR tempMixCol[BP],CL
  JMP END
  SKIP1:   
  MOV AH,2
  MOV AL,st[SI]
  MUL AH
  CMP AH,00H
  JZ NoOverFlow
  XOR AL,1BH
  
  
  NoOverFlow:
  CMP MixCol[DI],3
  JNZ SKIP3
  XOR AL,st[SI]
  
   
  
  SKIP3:
  MOV CX,0
  MOV CL,BL
  MOV BP,CX
  XOR tempMixCol[BP],AL
  END:
  
 
  INC BH
  CMP BH,4  
  JNZ LoopOverRow
  
  INC BL
  CMP BL,4
  JNZ LoopOverMixCol ;Wont do anythgin special here
  
  ;;Loop to copy from temp to actual
   ;dl is  current col 
  MOV CX,0 
  COPYCONTENTS:
  MOV AX,4
  MUL CL
  ADD AL,DL
  MOV SI,AX
  MOV DI,CX
  MOV AL,tempMixCol[DI]
  
  MOV AH,0 
  MOV tempMixCol[DI],AH ;reset temp col
  MOV st[SI],AL
   
  INC CL 
  CMP CL,4 
  JNZ COPYCONTENTS
   
  INC DL
  CMP DL,4
  JNZ LoopOverState 
MixColumns ENDM  
;================================================================== 


Call askState 

CMP AL,'2'
JNZ stateString
Call EnterState
JMP endStateAsk  

stateString:
CALL EnterStateString

endStateAsk:  

Call askCipher 

CMP AL,'2'
JNZ cipherString
Call EnterCipher
JMP endStateAsk

cipherString:
CALL EnterCipherString

endCipherAsk:                                                                   



MOV CX,11  

EncryptionLoop:

PUSH CX  

CMP CX,11
JZ FirstRound                                                            
SubBytes  state,SBOX                                                                    
ShiftRows  state
 
POP CX
PUSH CX 
CMP CX,1
JZ LastRound
                                                                                        
MixColumns state


LastRound:

KeySchedule cipherKey,SBOX 

FirstRound:
AddRoundKey state,cipherKey 

POP CX 
LOOP EncryptionLoop                                        

Call PrintState  
ret  
;==================================================================    
EnterState PROC  
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   mov dx, offset enterStateMsg
   mov ah, 09h
   int 21h 
     
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h  
     
   mov CX,16
   MOV SI,0 
   StartEntering:
   XOR AX,AX
   XOR BX,BX 
    
   mov ah, 01h        
   int 21h   ;;Al now contains the number         
  
   cmp al,'a'
   JL nota
   SUB al,57H 
   JMP sub1
   nota:
   cmp al,'A'
   JL nottA 
   SUB al,37H
   JMP sub1 
   
   nottA:
   SUB al,30H
   sub1:
   MOV BL,10H
   MUL BL
   MOV BL,AL ;NOW BL HAS BIGGER NUM
      
   mov ah, 01h        
   int 21h           
 
   cmp al,'a'
   JL notSa
   SUB al,57H 
   JMP subS1
   notSa:
   cmp al,'A'
   JL nottSA 
   SUB al,37H
   JMP subS1 
   
   nottSA:
   SUB al,30H
   subS1:
   ADD BL,AL 
   MOV state[SI],BL
      
   
   INC SI
   Loop StartEntering      
ret    
EnterState ENDP	
;================================================================== 
EnterCipher PROC   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h
    
   mov dx, offset enterCipherMsg
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h
     
   mov CX,16
   MOV SI,0 
   zStartEntering:
   XOR AX,AX
   XOR BX,BX 
    
   mov ah, 01h        
   int 21h   ;;Al now contains the number         
  
   cmp al,'a'
   JL znota
   SUB al,57H 
   JMP zsub1
   znota:
   cmp al,'A'
   JL znottA 
   SUB al,37H
   JMP zsub1 
   
   znottA:
   SUB al,30H
   zsub1:
   MOV BL,10H
   MUL BL
   MOV BL,AL ;NOW BL HAS BIGGER NUM
      
   mov ah, 01h        
   int 21h           
 
   cmp al,'a'
   JL znotSa
   SUB al,57H 
   JMP zsubS1
   znotSa:
   cmp al,'A'
   JL znottSA 
   SUB al,37H
   JMP zsubS1 
   
   znottSA:
   SUB al,30H
   zsubS1:
   ADD BL,AL 
   MOV cipherKey[SI],BL
          
   INC SI
   Loop zStartEntering      
ret    
EnterCipher ENDP 
;================================================================== 
PrintState PROC  
    
 mov dx, offset printNewLine
 mov ah, 09h
 int 21h 
 
 mov dx, offset printNewLine
 mov ah, 09h
 int 21h
    
 mov dx, offset outputMsg
 mov ah, 09h
 int 21h  
   
 MOV CX,16 
 MOV SI,0
 StartPrinting:
 MOV AX,CX
 MOV BL,4
 DIV BL
 CMP AH,0
 JNZ notNewLine 
 mov dx, offset printNewLine
 mov ah, 09h
 int 21h
 mov dx, offset printNewLine
 mov ah, 09h
 int 21h
    
 notNewLine: 
 
 
 
 
 XOR AX,AX
 MOV AL,state[SI]
 MOV BL,10H
 DIV BL
 ;;AL HAS NUMBER TO BE PRINTED FIRST AH SECOND NUMBER
 CMP AL,0AH
 JL skipA
 ADD AL,57H
 JMP printA
 skipA:
 ADD AL,30H
 printA: 
 MOV BL,AH
 
 mov ah, 02h     
 mov dl, al     
 int 21h
  
 MOV AL,BL 
 ;Print second
 CMP AL,0AH
 JL ZskipA
 ADD AL,57H
 JMP ZprintA
 ZskipA:
 ADD AL,30H
 ZprintA: 
 MOV BL,AH
 
 mov ah, 02h     
 mov dl, al     
 int 21h
 
 mov dx, offset printSpace
 mov ah, 09h
 int 21h
 
 
 INC SI
 LOOP StartPrinting 
  
    
    
ret    
PrintState ENDP    
;==================================================================
askState PROC 
      
   mov dx, offset askStateMsg
   mov ah, 09h
   int 21h
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   mov ah, 01h        
   int 21h   
ret
askState ENDP    
;==================================================================
askCipher PROC 
    mov dx, offset printNewLine
    mov ah, 09h
    int 21h 
 
    mov dx, offset printNewLine
    mov ah, 09h
    int 21h
      
   mov dx, offset askCipherMsg
   mov ah, 09h
   int 21h                   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   mov ah, 01h        
   int 21h     
ret
askCipher ENDP 
;==================================================================
EnterStateString  PROC  
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h
    
   mov dx, offset enterStateAsStringMsg
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h
    
    mov dx, offset stateBuffer
	mov ah, 0ah
	int 21h    
	
	MOV SI,2
	MOV DI,0
	MOV CX,16
	continueCopying:     
	MOV DL,stateBuffer[SI] 
	CMP DL,0DH
	JZ terminated
	MOV state[DI],DL
	INC DI
	INC SI
	LOOP continueCopying     
	terminated:
       
ret
EnterStateString ENDP  
;==================================================================
EnterCipherString  PROC   
    
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h
    
   mov dx, offset enterCipherAsStringMsg
   mov ah, 09h
   int 21h 
   
   mov dx, offset printNewLine
   mov ah, 09h
   int 21h
    
    mov dx, offset cipherBuffer
	mov ah, 0ah
	int 21h    
	
	MOV SI,2
	MOV DI,0
	MOV CX,16
	continueCopyingci: 
	MOV DL,cipherBuffer[SI]  
	CMP DL,0DH
	JZ terminator
	MOV cipherKey[DI],DL
	INC DI
	INC SI
	LOOP continueCopyingci                           
    terminator:                        
ret
EnterCipherString ENDP  
           

