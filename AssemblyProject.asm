org 100h
;Conventions used in this code
;All variables,labels are camelcased                              
;All instructions,registers are fully capitalized
;procs,macros first letter each word capitalzied                          
.Data  
  SBOX DB 63H,7CH,77H, 7BH, 0F2H, 6BH, 6FH, 0C5H, 30H, 01H, 67H, 2BH, 0FEH, 0D7H, 0ABH, 76H, 0CAH, 82H, 0C9H, 7DH, 0FAH, 59H, 47H, 0F0H, 0ADH, 0D4H, 0A2H, 0AFH, 9CH, 0A4H, 72H, 0C0H, 0B7H, 0FDH, 93H, 26H, 36H, 3FH, 0F7H, 0CCH, 34H, 0A5H, 0E5H, 0F1H, 71H, 0D8H, 31H, 15H, 04H, 0C7H, 23H, 0C3H, 18H, 96H, 05H, 9AH, 07H, 12H, 80H, 0E2H, 0EBH, 27H, 0B2H, 75H, 09H, 83H, 2CH, 1AH, 1BH, 6EH, 5AH, 0A0H, 52H, 3BH, 0D6H, 0B3H, 29H, 0E3H, 2FH, 84H, 53H, 0D1H, 00H, 0EDH, 20H, 0FCH, 0B1H, 5BH, 6AH, 0CBH, 0BEH, 39H, 4AH, 4CH, 58H, 0CFH, 0D0H, 0EFH, 0AAH, 0FBH, 43H, 4DH, 33H, 85H, 45H, 0F9H, 02H, 7FH, 50H, 3CH, 9FH, 0A8H, 51H, 0A3H, 40H, 8FH, 92H, 9DH, 38H, 0F5H, 0BCH, 0B6H, 0DAH, 21H, 10H, 0FFH, 0F3H, 0D2H, 0CDH, 0CH, 13H, 0ECH, 5FH, 97H, 44H, 17H, 0C4H, 0A7H, 7EH, 3DH, 64H, 5DH, 19H, 73H, 60H, 81H, 4FH, 0DCH, 22H, 2AH, 90H, 88H, 46H, 0EEH, 0B8H, 14H, 0DEH, 5EH, 0BH, 0DBH, 0E0H, 32H, 3AH, 0AH, 49H, 06H, 24H, 5CH, 0C2H, 0D3H, 0ACH, 62H, 91H, 95H, 0E4H, 79H, 0E7H, 0C8H, 37H, 6DH, 8DH, 0D5H, 4EH, 0A9H, 6CH, 56H, 0F4H, 0EAH, 65H, 7AH, 0AEH, 08H, 0BAH, 78H, 25H, 2EH, 1CH, 0A6H, 0B4H, 0C6H, 0E8H, 0DDH, 74H, 1FH, 4BH, 0BDH, 8BH, 8AH, 70H, 3EH, 0B5H, 66H, 48H, 03H, 0F6H, 0EH, 61H, 35H, 57H, 0B9H, 86H, 0C1H, 1DH, 9EH, 0E1H, 0F8H, 98H, 11H, 69H, 0D9H, 8EH, 94H, 9BH, 1EH, 87H, 0E9H, 0CEH, 55H, 28H, 0DFH, 8CH, 0A1H, 89H, 0DH, 0BFH, 0E6H, 42H, 68H, 41H, 99H, 2DH, 0FH, 0B0H, 54H, 0BBH, 16H
 
  SBOXRows  EQU 16
  SBOXCol   EQU 16

  totalColNum EQU 4
  totalRowNum EQU 4
  state  DB 0d4H,0e0H,0b8H,1eH,27H,0bfH,0b4H,41H,11H,98H,5dH,52H,0aeH,0f1H,0e5H,30H  ;Input Array State  
  ;algorithm to access row x col y =(currentRow*colNum)+currentCol

 
.Code  
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
  AddRoundKey MACRO st,k
    Mov SI,0 ;XORING START AT 0  
    Mov AX,totalColNum
    Mov BL,totalRowNum
    Mul BL
    Mov CX,AX ;TotalNumber of iterations 16 times (Total Number of cells)
    
    StartLoop:
    MOV AL,k[SI]
    XOR st[SI],AL   
    INC SI
    LOOP StartLoop      
                        
AddRoundKey ENDM

;SUB BYTES WORKS AS LOGIC HOWEVER DUE TO SIZE OF SBOX ERROR OCCURS IF KEY STARTS WITH LETTER
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
MOV BP,OFFSET sb  ;This is becasue directly using sb[,,,] gives error 
StartLoop: 
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
MOV AL,BP+DI
MOV k[SI],AL





INC SI    
LOOP StartLoop    
    
SubBytes ENDM 

 


 
ret







           