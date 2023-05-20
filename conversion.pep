;Programme qui fait la conversion d'un nombre entier décimal positif en sa représentation dans une base X. La base spécifiée X peut être entre 2 et 36.
;20 Février 2023
;Imad Bouarfa Shaker
;bouarfa.imad@courrier.uqam.ca

         BR      main 

main:    STRO    msg1,d      ;affiche message 1
         DECI    num,d       ;met le nombre saisi dans num
         LDA     num,d       
         BRLT    invalid     ; si < 0 
         CPA     max2,i      
         BRGT    invalid     ; si > 32767
         STRO    msg2,d
         DECI    base,d      ; demande la base
         LDA     base,d      
         CPA     min,i       
         BRLT    invalid     ;si < 2
         CPA     max,i
         BRGT    invalid     ;si > 36
         LDX     0,i         ; début de la chaine
         LDA     "A",i       ; début de l'alphabet
init:    STBYTEA alphabet,x   
         ADDX    1,i         ; caractère suivant
         ADDA    1,i         ; lettre suivante
         CPA     "Z",i       ; fin de ligne ?
         BRLE    init  
         LDX     0,i
         STX     index,d
         BR      do
         

while:   BREQ    for         ;si == 0
         LDA     0,i
         STA     remain,d    ;stocke le reste de la division
         LDA     quotient,d
         STA     num,d       
         LDA     0,i         
         STA     quotient,d 
         BR      do
         

do:      LDA     num,d 
         BRLT    reste       ;si num est plus petit que la base 
         SUBA    base,d      ;soustraction de la base sur num    
         STA     num,d       
         LDA     quotient,d
         ADDA    1,i
         STA     quotient,d  ;enregistrement en mémoire du quotient
         BR      do          ;boucle qui recommence jusqu'à temps que num est inférieur à la base         
         STOP

reste:   LDA     num,d
         ADDA    base,d      ;addition de la base afin d'obtenir le reste
         STA     remain,d;                 
         LDA     quotient,d
         SUBA    1,i         ;soustrait 1 afin d'obtenir le prochain quotient
         STA     quotient,d 
         ;DECO   quotient,d
         ;DECO   remain,d
         LDA     remain,d
         ASLX                ;décale la valeur dans remain vers la gauche
         STA     tableau,x   
         LDX     index,d
         ADDX    1,i         ;incrémente l'index afin de pointer la prochaine position du tableau
         STX     index,d              
         LDA     quotient,d
         BR      while       ;vérifie si le quotient est 0
         STOP


         
invalid: STRO    error1,d
         BR      main

for:     LDX     index,d
         CPX     0,i
         BREQ    fini        ;si égal à 0
         SUBX    1,i         ;décrément l'index de 1
         STX     index,d     
         ASLX                ;décale la valeur X vers la gauche de un bit 
         
         LDA     tableau,x
         
         SUBA    9,i
         CPA     0,i
         BRGT    convert     ;si > 0
         DECO    tableau,x
         CPX     0,i
         BREQ    fini        ;si == 0
         BR      for
fini:    BR      main

convert: STA     diff,d      ;Stocke la valeur de la différence dans "diff". 
         LDX     diff,d
         SUBX    1,i         ;Soustrait 1 de la valeur dans le registre X
         LDA     alphabet,x
         LDX     index,d
         ASLX                ;Décale la valeur dans le registre X d'un bit vers la gauche, la multipliant par 2.
         STA     tableau,x
         CHARO   tableau,x   ;Sort le caractère stocké dans le tableau "tableau" à l'indice spécifié par la valeur dans le registre X.
         BR      for
         


         

         

msg1:     .ASCII  "Entrez un nombre positif svp: \n\x00"
error1:   .ASCII  "Entrée invalide\n\x00"
msg2:     .ASCII  "Entrez une base de conversion (un nombre de 2 à 36): \x00"
num:      .BLOCK  2
base:     .BLOCK  2
min:      .EQUATE 2
max:      .EQUATE 36
max2:     .EQUATE 32767
quotient: .BLOCK  2
remain:   .BLOCK  2 
tableau:  .BLOCK  30
length:   .EQUATE 15
index:    .BLOCK  2
alphabet: .BLOCK  26
diff:     .BLOCK  2
          
          .END