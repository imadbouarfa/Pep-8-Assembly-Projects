;Programme qui v�rifie si c'est un carr� magique.
;19 Mars 2023
;Imad Bouarfa Shaker
;bouarfa.imad@courrier.uqam.ca
;---------------------------------------------------------------------------------------------               

                 BR      main

;Cr�e une matrice de taille n*n � partir de l'entr�e utilisateur en utilisant la proc�dure mult.
;Les facteurs pour la multiplication sont stock�s dans facteur1 et facteur2, et le r�sultat est
;stock� dans res. n2 est utilis� pour stocker le carr� de n, et tabidx est utilis� pour indexer la matrice     
creerMat:        STRO        msg1,d           ;affiche le message d'entr�e pour la taille de la matrice                               
                 DECI        n,d              ;lit la taille de la matrice                 
                 LDA         n,d              ;charge la valeur de n dans le registre d
                 CPA         10,i             ;compare la valeur de n avec 10
                 BRGT        then             ;si n est sup�rieur � 10, branche vers 'then'
                 CPA         2,i
                 BRLT        then
                 STA         facteur1,d       ;stocke la valeur de n dans facteur1
                 STA         facteur2,d       ;stocke la valeur de n dans facteur2
                 CALL        mult             ;appelle la fonction mult pour multiplier facteur1 et facteur2
                 LDA         res,d            ;charge le r�sultat de la multiplication dans le registre d
                 STA         n2,d             ;stocke le r�sultat de la multiplication dans n2
                 LDA         0,i
                 STA         tabidx,d         ;initialise l'index du tableau � 0
                 
do:              LDX         res,d        
                 STX         cursor,d         ;initialise la variable cursor � 0


;Cette boucle lit les entr�es utilisateur dans input et les stocke dans la matrice en utilisant l'index tabidx.
while:           DECI        input,d
                 LDX         cursor,d        
                 SUBX        1,i
                 STX         cursor,d


;Ces instructions comparent la valeur entr�e par l'utilisateur avec les bornes inf�rieure et sup�rieure 
;de la matrice. Si la valeur est hors de la plage, l'ex�cution saute � la proc�dure erreur.
compare:         LDA         input,d
                 CPA         1,i
                 BRLT        erreur
                 CPA         res,d
                 BRGT        erreur


;Ces instructions sont utilis�es pour v�rifier si la valeur entr�e par l'utilisateur a d�j� �t� entr�e auparavant. 
;Si la valeur est d�j� dans la matrice, l'ex�cution saute � la proc�dure erreur2.
check:           LDX         input,d
                 SUBX        1,i 
                 LDBYTEA     bools,x
                 CPA         1,i
                 BREQ        erreur2
                 
putbool:         LDX        input,d
                 SUBX        1,i
                 LDBYTEA     1,i
                 STBYTEA     bools,x
                

;Ces instructions stockent la valeur entr�e par l'utilisateur dans la matrice � l'index tabidx.
store:           LDA         input,d
                 LDX         tabidx,d
                 ASLX
                 STA         mat,x
                 LDX         tabidx,d
                 ADDX        1,i
                 STX         tabidx,d
                 LDX         cursor,d
                 BRNE        while
                 RET0
              
                 


erreur:          LDA         res,d            ;Charge la valeur de la variable res dans le registre d'accumulateur A.
                 STRO        msg2,d           ;affiche un message d'erreur
                 DECO        res,d            ;Affiche un caract�re de saut de ligne (\n) � l'emplacement m�moire point� par le registre i.
                 CHARO       '\n',i
                 LDX         cursor,d
                 ADDX        1,i
                 STX         cursor,d
                 BR          while            ;branche � 'while' qui r�p�te le bloc d'instructions jusqu'� ce que la condition soit satisfaite

erreur2:         LDA         res,d
                 STRO        msg3,d
                 DECO        res,d
                 CHARO       '\n',i
                 LDX         cursor,d
                 ADDX        1,i
                 STX         cursor,d
                 BR          while                       
                          
                 
                 
                 

mult:            LDX         facteur2,d       ;charge le registre d'index X avec la valeur de la variable facteur2 stock�e en m�moire.
        
                 BR          start    
start:           LDA         0,i
add:             ADDA        facteur1,d       ;ajoute la valeur de la variable facteur1 � la valeur stock�e dans l'accumulateur
                 SUBX        1,i              ;oustrait 1 de la valeur du registre d'index X
                 BRGT        add
end:             STA         res,d            ;stocke la valeur actuelle de l'accu dans la variable res en m�moire
                 RET0                         ;retourne � la fonction appelante



affMat:          BR          loop_i


;boucle qui parcourt les lignes d'une matrice nxn et qui affiche chaque �l�ment � l'aide de la fonction loop_j.                 
loop_i:          CALL        loop_j
                 CHARO       '\n',i
                 LDX         i,d
                 ADDX        1,i
                 STX         i,d
                 LDX         i,d
                 CPX         n,d              ;compare la valeur du registre d'index X avec la valeur de la variable n
                 BREQ        fin
                 
                 BR          loop_i        
                 

;permet de boucler sur les colonnes de la matrice et pour chaque �l�ment de la matrice, elle appelle la fonction index.                 
loop_j:          LDX         i,x
                 LDA         i,d
                 STA         facteur1,d
                 LDA         j,d
                 STA         facteur2,d
                 CALL        index
                 LDX         valmulti,d
                 ASLX                         ;effectue un d�calage � gauche du contenu du registre d'indexation x (�quivalent � une multiplication par 2)
                 DECO        mat,x            ;affiche le contenu de la case de la matrice correspondant � l'index x
                 CHARO       '\t',i
                 LDX         j,d
                 ADDX        1,i
                 STX         j,d
                 CPX         n,d              ;compare la valeur du registre d'index X avec la valeur de la variable n
                 BREQ        next             ;si n == � la valeur du registre d'index X
                 BR          loop_j           ;branche � loop_j
                 

next:            LDA         0,i
                 STA         j,d
                 RET0 


;La fonction index calcule l'index de l'�l�ment dans la matrice en utilisant la multiplication de la ligne par le nombre total 
;de colonnes et l'ajout de la colonne correspondante. Elle renvoie l'index dans la variable valmulti.
index:           LDA         i,d
                 STA         facteur1,d
                 LDA         n,d
                 STA         facteur2,d
                 CALL        mult
                 LDA         res,d        
                 ADDA        j,d
                 STA         valmulti,d
                 RET0


;v�rifier si une matrice est un carr� magique en appelant les fonctions ligne, colonne, diago, et carre pour calculer la somme 
;des �l�ments de chaque ligne, colonne, diagonale et de la matrice enti�re. Si toutes les sommes sont �gales, alors la matrice 
;est un carr� magique. La fonction retourne 0 si la matrice n'est pas un carr� magique, et 1 si elle l'est.
estMag:          LDX         0,i
                 STX         i,d
                 STX         j,d
                 CALL        ligne                
                 CALL        colonne
                 CALL        diago
                 CALL        carre
                 RET0


;v�rifier si la dimension du carr� magique est 3, 5, 7 ou 9. 
;Si la dimension est diff�rente de ces valeurs, la fonction ex�cute l'instruction bye
carre:           LDA         n,d
                 CPA         3,i
                 BREQ        bye
                 CPA         5,i
                 BREQ        bye
                 CPA         7,i
                 BREQ        bye
                 CPA         9,i
                 BREQ        bye
                 LDA         0,i
                 STA         somme,d
                 LDA         1,i
                 STA         i,d
                 STA         j,d
                 LDA         n,d
                 SUBA        1,i
                 STA         nmoins,d     


;parcourt les lignes du carr� magique en appelant la fonction "loop2" pour chaque ligne. 
loop1:           LDA         i,d
                 CPA         nmoins,d
                 BREQ        finito2
                 CALL        loop2
                 LDA         i,d
                 ADDA        1,i
                 STA         i,d
                 BR          loop1

loop2:           LDA         j,d
                 CPA         nmoins,d
                 BREQ        finloop
                 CALL        index
                 LDX         valmulti,d
                 ASLX    
                 LDA         somme,d
                 ADDA        mat,x
                 STA         somme,d     
                 LDX         j,d
                 ADDX        1,i
                 STX         j,d
                 BR          loop2
         
finloop:         LDA         1,i
                 STA         j,d
                 RET0        

finito2:         LDA         somme,d
                 CPA         nbmagie,d
                 BRNE        popareil 
                 RET0
         
         
         
bye:             RET0
                    

;initialise trois variables i, j, et somme � z�ro
diago:           LDX         0,i
                 STX         i,d
                 STX         j,d
                 STX         somme,d


;It�re sur les indices de la diagonale sup�rieure d'une matrice carr�e. Il commence par charger l'indice de ligne "i" dans 
;le registre X et compare sa valeur � la taille de la matrice "n". Si i est �gal � n, la boucle se termine. Sinon, 
;il appelle la fonction "index" pour obtenir l'indice de l'�l�ment de la matrice correspondant � l'intersection de la ligne "i" et de la 
;diagonale sup�rieure. La valeur retourn�e est stock�e dans le registre X, puis le code multiplie cette valeur par 2 en utilisant l'op�ration "ASLX".
for:             LDX         i,d
                 CPX         n,d
                 BREQ        fin_diag
                 CALL        index
                 LDX         valmulti,d
                 ASLX    
                 LDA         somme,d
                 ADDA        mat,x
                 STA         somme,d     
                 LDX         i,d
                 ADDX        1,i
                 STX         i,d
                 STX         j,d
                 BR          for                           
                                                                                              


ligne:           BR          for_i
                 

;parcourt les indices de ligne de la matrice carr�e mat de taille n x n. La boucle commence par initialiser le registre d'index i � 0 
;et se poursuit tant que i < n. Dans chaque it�ration de la boucle, la fonction appelle for_j pour parcourir les indices de colonne de 
;la matrice pour la ligne actuelle i, puis incr�mente la valeur de i pour passer � la ligne suivante.
for_i:           LDX         i,d
                 CPX         n,d
                 BREQ        fin
                 CALL        for_j
                 LDX         i,d
                 ADDX        1,i
                 STX         i,d
                                
                 BR          for_i


;it�re sur les colonnes de la matrice "mat", en utilisant l'index "j" pour acc�der aux �l�ments de la colonne en cours de traitement. 
;La boucle commence en initialisant "j" � z�ro, puis elle compare "j" avec la valeur "n" pour d�terminer si elle doit se terminer. 
;Si "j" est �gal � "n", la boucle passe � l'�tiquette "next_i". 
for_j:           LDX         j,d
                 CPX         n,d
                 BREQ        next_i
                 CALL        index
                 LDX         valmulti,d
                 ASLX
                 LDA         somme,d
                 ADDA        mat,x
                 STA         somme,d
                 LDX         j,d
                 ADDX        1,i
                 STX         j,d
                 BR          for_j
                 

;v�rifie si la somme calcul�e dans les fonctions pr�c�dentes correspond � la constante magique (nbmagie).
next_i:          LDX         0,i
                 STX         j,d
                 LDA         i,d
                 CPA         0,i
                 BREQ        storemaj
                 LDA         nbmagie,d
                 CPA         somme,d
                 BREQ        pareil
                 BR          popareil
                 
                                  
;v�rification pour voir si la somme des �l�ments dans une ligne, colonne ou diagonale est �gale � la constante magique. 
;Si oui, la constante magique est stock�e dans la variable "nbmagie". Si la somme n'est pas �gale � la constante magique, 
;rien n'est stock� et le code continue.
storemaj:        LDA         somme,d
                 STA         nbmagie,d
                 LDA         0,i
                 STA         somme,d                
                 RET0


;Met la variable somme � z�ro et termine la fonction avec RET0. Cela indique que le programme est arriv� � la fin de la fonction 
;et retourne au point d'appel. Cette fonction est appel�e lorsque la somme des nombres dans une ligne, colonne ou diagonale 
;est �gale � la constante magique nbmagie.
pareil:          LDA         0,i
                 STA         somme,d
                 RET0


;Affiche un message d'erreur si la somme n'est pas pareille.
popareil:        STRO        msg4,d 
                 STOP        
                 

;v�rifie si la somme actuelle est �gale � la somme magique. Si c'est le cas, il remet les indices i et j � z�ro et la somme � z�ro et passe 
;� la prochaine boucle. Sinon, il saute � popareil.
fin_diag:        LDA         somme,d
                 CPA         nbmagie,d
                 BRNE        popareil
                 LDA         0,i
                 STA         i,d
                 LDA         n,d
                 SUBA        1,i
                 STA         j,d
                 LDA         0,i
                 STA         somme,d
                 BR          for2

for2:            LDX         i,d
                 CPX         n,d
                 BREQ        finito
                 CALL        index
                 LDX         valmulti,d
                 ASLX    
                 LDA         somme,d
                 ADDA        mat,x
                 STA         somme,d     
                 LDX         i,d
                 ADDX        1,i
                 STX         i,d
                 LDX         j,d
                 SUBX        1,i
                 STX         j,d
                 BR          for2    


;compare la valeur de la variable somme avec la variable nbmagie dans la fonction next_i. Si les deux valeurs sont �gales, la fonction retourne 
;� la fonction appelante. Sinon, elle continue � ex�cuter les instructions dans la fonction popareil
finito:          LDA         somme,d
                 CPA         nbmagie,d
                 BRNE        popareil
                 RET0                                                      
                                  
                 
;Code qui effectue des calculs sur une colonne d'une matrice. Le registre d'index X est initialis� � z�ro et utilis� pour parcourir la colonne de la 
;matrice. Les registres i, j et somme sont initialis�s � z�ro. La section de code appelle ensuite la section de code for_j2 pour effectuer des calculs 
;sur chaque �l�ment de la colonne.                                          
colonne:         LDX         0,i
                 STX         somme,d
                 STX         i,d
                 STX         j,d                                            
                 BR          for_j2          

for_j2:          LDX         j,d 
                 CPX         n,d
                 BREQ        fin
                 CALL        for_i2                      
                 LDX         j,d
                 ADDX        1,i
                 STX         j,d
                 BR          for_j2


for_i2:          LDX         i,d
                 CPX         n,d
                 BREQ        next_j
                 CALL        index
                 LDX         valmulti,d
                 ASLX
                 LDA         somme,d
                 ADDA        mat,x
                 STA         somme,d
                 LDX         i,d
                 ADDX        1,i
                 STX         i,d
                 BR          for_i2
         
next_j:          LDX         0,i
                 STX         i,d
                 LDA         nbmagie,d
                 ;DECO       nbmagie,d
                 CPA         somme,d
                 BREQ        pareil
                 BR          popareil
                                             
                 
                 

then:            DECO        -1,i 
                 RET0          
         

fin:             RET0


;Fonction Main qui appelle les sous-programmes
main:            CALL        creerMat         ;cr�e une matrice carr�e de taille n et y ins�re des valeurs al�atoires entre 1 et 9.
                 CALL        affMat           ;affiche la matrice cr��e pr�c�demment
                 CALL        estMag           ;v�rifie si la matrice est un carr� magique
                 STRO        msg5,d
                 DECO        nbmagie,d
            
                 STOP        

         

         

msg1:            .ASCII  "Entrez un nombre valide de 2 � 10 :\n\x00"
msg2:            .ASCII  "Le nombre entr� n'est pas valide. Entrez une valeur de 1 � \x00"
msg3:            .ASCII  "La donn�e est d�j� entr�e! Entrez une autre valeur de 1 �  \x00"
msg4:            .ASCII  "La matrice n'est pas un carr� magique! \n\x00"
msg5:            .ASCII  "Carr� magique!!! La valeur magique est: \x00"
n:               .BLOCK  2
facteur1:        .BLOCK  2
facteur2:        .BLOCK  2
tabidx:          .BLOCK  2
cursor:          .BLOCK  2
res:             .BLOCK  2
n2:              .BLOCK  2
valmulti:        .BLOCK  2
input:           .BLOCK  2
mat:             .BLOCK  200
bools:           .BLOCK  100
i:               .BLOCK  2
j:               .BLOCK  2
idxmulti:        .BLOCK  2
somme:           .BLOCK  2
nbmagie:         .BLOCK  2
nmoins:          .BLOCK  2
                 .END