org 100h
;Conventions used in this code
;All variables,labels are camelcased                              
;All instructions,registers are fully capitalized
;procs,macros first letter each word capitalzied                          
.Data  
  
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
 
 


 
ret







           