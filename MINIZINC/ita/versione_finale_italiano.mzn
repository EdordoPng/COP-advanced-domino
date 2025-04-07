% Elenco dei vincoli : 

%  1) Piazzare le tessere in grid e place_grid
%  2) Ogni tessera deve essere adiacente ad almeno un'atra tessera 
%  3) Celle adiacenti ma di tessere diverse devono avere lo stesso valore 
%  4) Limite delle celle usabili al numero di celle nelle tessere in input
%  5) Una cella è occupata se ha una tessera piazzata
%  6) Iniziamo a connettere a partire da una cella occupata
%  7) Propagazione della connessione in tutte le direzioni per le celle adiacenti occupate 

% -----------------------------------------------------------------------------------------------------------

% Autore : Edoardo Diana

% Dimensione della griglia n x n
int: n;

% Numero di tessere disponibili
int: num_tessere;

set of int : valori_permessi = {0,1,2,3,4,5,6};

% Matrice che rappresenta la griglia del piano di gioco, con i valori delle tessere
array[1..n, 1..n] of var valori_permessi: grid;

% Matrice che rappresenta le celle occupate nella griglia
% 0 = cella vuota, altrimenti contiene l'indice della tessera posizionata
array[1..n, 1..n] of var 0..num_tessere: place_grid;

% Numero di celle per ciascuna tessera
array[1..num_tessere] of int: numero_di_celle;

% Matrice per ogni tessera che contiene triplette (valore, x, y) plottati idealmente su di una matrice 3x3.
array[1..num_tessere, 1..4] of tuple(int, int, int): tessere;

% Variabile che conta il numero di celle occupate (diverse da 0) in place_grid
var 0..n*n: celle_occupate;

% Variabile binaria che indica se una cella è connessa alla componente principale
array[1..n, 1..n] of var 0..1: connesso;

% Variabile binaria per ogni tessera che indica se la tessera è posizionata (1) o no (0)
array[1..num_tessere] of var 0..1: tessera_posizionata;

% Vincolo 1  :
% per poter piazzare una tessera, serve che esista una cella di partenza libera tale che siano libere tutte le posizioni che verrebbero occupate dalle celle
% della suddetta tessera.

% Questo vincolo permette di valutare se è possibile piazzare una tessera in una deterinata posizione.
% E' necessario che esista una posizione di partenza valida, identificata tramite delle coordinate X ed Y, tale per cui vengan soddisfatte le condizioni 
% successivamente indicate.
% A tale scopo viene utilizzata una costante ausiliaria "k" che consente di tener traccia del numero di celle appartenenti alla tessera in analisi.
% Tramite un ciclo che scorre ogni cella di cui è composta una tessera, vengono ricavate delle nuove coordinate da analizzare, "cellX" e "cellY".
% Esse sono ottenute mediante la somma della coordinate della posizione di partenza ed un offset relativo alle coordinate proprie della cella in analisi.
% Per ognuna di esse, è richiesto che il valore in "grid" sia corrispondente al valore che la cella deve contenere (fornito in input) e che il valore
% in "place_grid" sia corrispondente a quello della tessera in analisi.
% Qualora le condizioni siano rispettate per tutte le celle apparteneti alla tessera, è possibile piazzare quest'ultima sulla tavola di gioco.

constraint forall(t in 1..num_tessere)(
    if tessera_posizionata[t] == 1 then
        exists(startX, startY in 1..n)(
            let {
                int: k = numero_di_celle[t]
            } in
            forall(i in 1..k)(
                let {
                    int: cellX = startX + tessere[t, i].2,
                    int: cellY = startY + tessere[t, i].3
                } in
                cellX >= 1 /\ cellX <= n /\       % La cella deve essere valida
                cellY >= 1 /\ cellY <= n /\       % La colonna deve essere valida
                
                % Il valore nella griglia deve corrispondere al valore della cella nella tessera
                grid[cellX, cellY] == tessere[t, i].1 /\ 
                % La cella nella griglia con indici delle tessere deve essere occupata dalla tessera t
                place_grid[cellX, cellY] == t     
            )
        )
    else
        % Se la tessera non è posizionata, non deve occupare celle
        forall(cellX, cellY in 1..n)(
            place_grid[cellX, cellY] != t
        )
    endif
  )   
;

% Predicato che è True solo se è stata piazzata almeno una tessera sulla tavola di gioco.
predicate almeno_una_tessera_piazzata() =
  sum(t in 1..num_tessere)(tessera_posizionata[t]) > 1;

% Vincolo 2: 
% ogni tessera posizionata deve essere adiacente ad almeno una tessera già posizionata

% Questo vincolo è valido per tutte le tessere al di fuori della prima che viene piazzata sulla tavola di gioco.
% Aassicura che una tessera sia piazzabile qualora esista una cella ad essa appartenete che sia adiacente ad una cella di una tessera diversa. 

constraint forall(t1 in 1..num_tessere)(
    if tessera_posizionata[t1] == 1 /\ almeno_una_tessera_piazzata() then (
        exists(cellX, cellY in 1..n)(
            place_grid[cellX, cellY] == t1 /\
            % Verifica che almeno una cella adiacente appartiene a una tessera già posizionata diversa da t1
            (
                % Cella sopra
                (cellX > 1 /\ place_grid[cellX - 1, cellY] != 0 /\ place_grid[cellX - 1, cellY] != t1) \/ 
                % Cella sotto
                (cellX < n /\ place_grid[cellX + 1, cellY] != 0 /\ place_grid[cellX + 1, cellY] != t1) \/ 
                % Cella sinistra
                (cellY > 1 /\ place_grid[cellX, cellY - 1] != 0 /\ place_grid[cellX, cellY - 1] != t1) \/ 
                % Cella destra
                (cellY < n /\ place_grid[cellX, cellY + 1] != 0 /\ place_grid[cellX, cellY + 1] != t1)    
            )
        )
    ) endif
);


% Vincolo 3 : 
% assicura che se due celle di tessere diverse sono adiacenti allora hanno lo stesso valore in grid

% Questo vincolo impone che due celle di tessere diverse adiacenti abbiano lo stesso valore al loro interno
% Vine applicato per ogni cella della matrice "place_grid" in cui è stata piazzata una tessera
% Per eseguire il controllo, viene utilizzata una cella di partenza e vengono analizzate le quadro celle ad essa adiacenti.

constraint
  forall(cellX,cellY in 1..n where place_grid[cellX, cellY]!=0)(
    
    if (cellY < n /\ place_grid[cellX, cellY] != place_grid[cellX, cellY + 1] /\ place_grid[cellX, cellY + 1] != 0)
      then grid[cellX, cellY] == grid[cellX, cellY + 1]
    endif
    /\
    if (cellY > 1 /\ place_grid[cellX, cellY] != place_grid[cellX, cellY - 1] /\ place_grid[cellX, cellY - 1] != 0)
      then grid[cellX, cellY] == grid[cellX, cellY - 1]
    endif
    /\
    if (cellX > 1 /\ place_grid[cellX, cellY] != place_grid[cellX - 1, cellY] /\ place_grid[cellX - 1, cellY] != 0)
      then grid[cellX, cellY] == grid[cellX - 1, cellY]
    endif
    /\
    if (cellX < n /\ place_grid[cellX, cellY] != place_grid[cellX + 1, cellY] /\ place_grid[cellX + 1, cellY] != 0)
      then grid[cellX, cellY] == grid[cellX + 1, cellY]
    endif
  );

% Vincolo 4 : 
% che evita che il solver aggiunga delle celle occupate quando queste non appartengono a nessuna tessera

% Questo vincolo impone che ogni tessera occupi un numero di celle della matrice "place_grid" corrispondente al numero di celle di cui è composta 
constraint 
  forall(t in 1..num_tessere)(
    if tessera_posizionata[t] == 1 then (
      count(cellX, cellY in 1..n)(place_grid[cellX, cellY] == t ) == numero_di_celle[t]
    ) 
    else 
      count(cellX, cellY in 1..n)(place_grid[cellX, cellY] == t ) == 0
    endif
  );  


% Vincolo 5 : 
% Iniziamo a connettere a partire da una cella occupata

% Questo vincolo impone che ogni cella della matrice "connesso" venga posta ad 1 qualora nella matrice place_grid sia presente un valore diverso da 0.
% In altre parole, se è stata piazzata la cella di una tessera a quelle determinate coordinate della tavola di gioco.  
constraint exists(cellX, cellY in 1..n where place_grid[cellX, cellY] != 0) (
    connesso[cellX, cellY] == 1
);

% Vincolo 6 : 
% Ci assicuriamo che tutte le celle occupate siano connesse alla componente principale

constraint forall(cellX, cellY in 1..n)(
    place_grid[cellX, cellY] != 0 -> connesso[cellX, cellY] == 1
);

% Vincolo 7 : 
% Propagazione della connessione in tutte le direzioni per le celle adiacenti occupate

% Questo vincolo permette, qualora una cella della tavola di gioco sia occupata, di propagare la connessione alla componente principale a tutte 
% le componenti adiacenti. 
% Ciò è stato fatto allo scopo di ottenere una unica componente principale e vietare che vengano piazzate tessere lontane da essa.

constraint 
    forall(cellX, cellY in 1..n)(
      if place_grid[cellX, cellY] != 0 then (
          % Se una cella è connessa, propaga la connessione alle celle adiacenti
          (cellX > 1 /\ place_grid[cellX - 1, cellY] != 0) -> (connesso[cellX, cellY] == 1 -> cellX > 1 /\ connesso[cellX - 1, cellY] == 1 )
          /\
          (cellX < n /\ place_grid[cellX + 1, cellY] != 0) -> (connesso[cellX, cellY] == 1 -> cellX < n /\ connesso[cellX + 1, cellY] == 1 )
          /\
          (cellY > 1 /\ place_grid[cellX, cellY - 1] != 0) -> (connesso[cellX, cellY] == 1 -> cellY > 1 /\ connesso[cellX, cellY - 1] == 1 )
          /\
          (cellY < n /\ place_grid[cellX, cellY + 1] != 0) -> (connesso[cellX, cellY] == 1 -> cellY < n /\ connesso[cellX, cellY + 1] == 1 )
      )
      endif
  );


% Obiettivo: massimizzare il numero di tessere posizionate
solve maximize sum(t in 1..num_tessere)(tessera_posizionata[t]);


% Output
output [
  "Griglia:\n" ++
  show2d(grid) ++ "\n" ++
  "Posizionamento delle tessere:\n" ++
  show2d(place_grid) ++ "\n" ++
  "Tessere posizionate: " ++ show([t | t in 1..num_tessere where tessera_posizionata[t]==1]) ++ "\n"
];




