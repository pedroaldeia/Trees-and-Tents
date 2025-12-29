% Pedro Aldeia numero 109989
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- ["puzzlesAcampar.pl"]. % Ficheiro dado. No Mooshak tera mais puzzles.
% Atencao: nao deves copiar nunca os puzzles para o teu ficheiro de codigo
% Segue-se o codigo

% vizinhanca/2
% A funcao devolve true se receber coordenadas e devolver as coordenadas diretamente adjacentes a mesma.

vizinhanca((A,B), [(L1, C1), (L2, C2), (L3, C3), (L4, C4)]):-

    L1 is A-1, % para cada coordenada, calcula a linha
    C1 is B,   % ou coluna anterior ou seguinte a que foi dada

    L2 is A,
    C2 is B-1,

    L3 is A,
    C3 is B+1,

    L4 is A+1,
    C4 is B.


% vizinhancaAlargada/2
% A funcao devolve true se receber coordenadas e devolver as coordenadas que rodeiam a mesma.

vizinhancaAlargada((A,B), [(L1, C1), (L2, C2), (L3, C3), (L4, C4), (L5, C5), (L6, C6), (L7, C7), (L8, C8)]):-

    L1 is A-1, % para cada coordenada, calcula a linha 
    C1 is B-1, % ou coluna (ou ambas) anterior ou seguinte a que foi dada

    L2 is A-1,
    C2 is B,

    L3 is A-1,
    C3 is B+1,

    L4 is A,
    C4 is B-1,

    L5 is A,
    C5 is B+1,

    L6 is A+1,
    C6 is B-1,

    L7 is A+1,
    C7 is B,

    L8 is A+1,
    C8 is B+1.


% todasCelulas/2 
% A funcao e devolve true se receber um tabuleiro e uma lista com todas as coordenadas do tabuleiro anterior.

todasCelulas(T, []):- % se o tabuleiro tiver length 0, a lista e vazia
    length(T, 0), !.

todasCelulas(T, TodasCelulas):- 
    length(T, A), % retiro o comprimento do tabuleiro
    findall(X, between(1, A, X), L), % cria uma lista com todos os numeros entre um e o comprimento do tabuleiro
    findall(Y, (Y = (Z, W), member(Z, L), member(W, L)), TodasCelulas).  
    % devolve como TodasCelulas todas as combinacoes entre os elementos da lista anterior



% todasCelulas/3
% A funcao devolve true se receber um tabuleiro, um objecto e todas as coordenadas que contiverem o objeto no tabuleiro.

todasCelulas(T, TodasCelulas, Objecto):-
    todasCelulas(T, Coord), % vai buscar todas as celulas do tabuleiro
    flatten(T, T2), % torna o tabuleiro numa unica lista
    auxTodasCelulas(T2, TodasCelulas, Objecto, Coord). % chama uma funcao auxiliar com as celulas do tabuleiro

auxTodasCelulas([], [], _, []):- !. % caso terminal, se todas as listas forem vazias para a funcao

auxTodasCelulas([C1|R1], [C2|TodasCelulas], Objecto, [C2|R2]):- % retira a cabeca do tabuleiro e das coordenadas
    % se nao der false neste ramo, e adicionada a cabeca a TodasCelulas
    (var(Objecto), % verifica se o objeto e uma variavel
    var(C1); % verifica se o objeto do tabuleiro e variavel
    C1 == Objecto), !, % verifica se o objeto  e igual a cabeca
    auxTodasCelulas(R1, TodasCelulas, Objecto, R2). % chama a funcao recursivamente

auxTodasCelulas([_|R1], TodasCelulas, Objecto, [_|R2]):- % caso nao unificar com o passo anterior,
    % simplesmente tira a cabeca as coordenadas e tabuleiro
    auxTodasCelulas(R1, TodasCelulas, Objecto, R2).



% calculaObjectosTabuleiro/4
% A funcao devolve true se receber um tabuleiro, um objeto, uma lista com a contagem do objeto por linhas e uma
% lista com a contagem do objeto por colunas.

calculaObjectosTabuleiro(T, ContagemLinhas, ContagemColunas, Objecto):- 
    transpose(T, Ttransp), % fornece o tabuleiro transposto
    auxCalculaObjectosTabuleiro(T, ContagemLinhas, ContagemColunas, Objecto, Ttransp). % chama 

auxCalculaObjectosTabuleiro([], [], [], _, []):-!. % caso terminal, se os tabuleiro nao tiverem mais linhas

auxCalculaObjectosTabuleiro([C|R], [X|ContagemLinhas], [Y|ContagemColunas], Objecto, [T|Rt]):- 
    % tira a cabeca dos tabuleiros e adiciona os numeros de objetos nas contagens
    findall(A, (var(Objecto), member(A, C), var(A); \+var(Objecto), member(A, C), \+var(A), A=Objecto), C2),
    % vai buscar os elementos da linha do tabuleiro que sao iguais ao objecto e adiciona a C2
    findall(B, (var(Objecto), member(B, T), var(B); \+var(Objecto), member(B, T), \+var(B), B=Objecto), T2),
    % faz o mesmo para a transposta, para calcular para as colunas
    length(C2, X), % vai buscar a quantidade de elementos da lista
    length(T2, Y),
    auxCalculaObjectosTabuleiro(R, ContagemLinhas, ContagemColunas, Objecto, Rt). 
    % chama recursivamente para verificar as linhas restantes do tabuleiro


% celulaVazia/
% A funcao devolve true se receber um tabuleiro e coordenadas do mesmo tabuleiro que estejam vazias.


celulaVazia(T, (L,C)):- 
    nth1(L, T, Linha), % vai buscar a linha respectiva
    nth1(C, Linha, V), % vai buscar a coluna respectiva
    var(V). % verifica se e variavel

celulaVazia(T, (L,C)):- 
    nth1(L, T, Linha), % vai buscar a linha respectiva
    \+ nth1(C, Linha, a), % verifica que o elemento nao e arvore
    \+ nth1(C, Linha, t). % verifica que o elemento nao e tenda



% insereObjectoCelula/3
% A funcao devolve true se receber um tabuleiro, um objeto (tenda ou relva), e as coordenadas em que 
% se pretende colocar o objeto no tabuleiro.


insereObjectoCelula(T, TendaOuRelva, (L, C)):-
    nth1(L, T, A), % vai buscar a linha 
    nth1(C, A, TendaOuRelva), !. % se nao estiver ocupada, poe o objeto

insereObjectoCelula(_, _, _). % se estiver ocupada nao faz nada



% insereObjectoEntrePosicoes/4
% A funcao devolve true se receber um tabuleiro, um objeto (tenda ou relva), e as coordenadas entre as 
% quais se pretende colocar o objeto no tabuleiro.

insereObjectoEntrePosicoes(_, _, (_, C1), (_, C2)):- % caso terminal
    C1 > C2, !. % A funcao para quando a coluna do primeiro elemento e maior do que a do segundo

insereObjectoEntrePosicoes(T, TendaOuRelva, (L1, C1), (L2, C2)):-
    insereObjectoCelula(T, TendaOuRelva, (L1, C1)), !, % insere o objeto na coordenada atual
    CNew is C1 + 1,
    insereObjectoEntrePosicoes(T, TendaOuRelva, (L1, CNew), (L2, C2)). % repete para a coluna seguinte


% relva/1
% A funcao devolve true se receber um puzzle e, apos a aplicacao da mesma, o tabuleiro tiver relva em
% todas as coordenadas que antes estavam vazias e que se encontravam em colunas ou linhas que ja tinham
% alcancado o seu numero maximo de tendas.


relva((T, LinF, ColF)):-
    length(T, Len), % vai buscar o comprimento do tabuleiro
    calculaObjectosTabuleiro(T, Linhas, Colunas, t), % calcula o numero de tendas por linha e coluna
    findall(X, (nth1(X, LinF, Y), nth1(X, Linhas, Y)), L1), % vai buscar as linhas que tem numero maximo de tendas
    auxRelva(T, L1, Len), % chama uma funcao auxiliar
    transpose(T, T1),
    findall(X, (nth1(X, ColF, Y), nth1(X, Colunas, Y)), L2),
    auxRelva(T1, L2, Len).
    
auxRelva(_, [], _):- !. % caso terminal, terimina quando acabam as linhas por preencher

auxRelva(T, [C|R], Len2):- % retira uma coordenada la lista
    insereObjectoEntrePosicoes(T, r, (C, 1), (C, Len2)), % preenche a lista
    auxRelva(T, R, Len2). % chama recursivamente a mesma funcao, sem a cabeca



% inacessiveis/1
% A funcao devolve true se receber um tabuleiro e, apos a aplicacao da mesma, o tabuleiro tiver relva em
% todas as coordenas que nao se encontram na vizinhanca alargada de nenhuma arvore.


inacessiveis(T):-
    todasCelulas(T, CelulasArv, a), % vai buscar todas as coordenadas das arvores
    todasCelulas(T, Celulas), % vai buscar as coordenadas do tabuleiro
    findall(X, (member(Y, CelulasArv), vizinhanca(Y, Z), member(X, Z)), LViz), % vai buscar as coordenadas da vizinhanca das arvores
    findall(X, (member(X, Celulas), \+ member(X, LViz)), LNotViz), % vai buscar as coordenadas que nao pertencem a vizinhanca das arvores
    auxInacessiveis(LNotViz, T). % chama uma funcao auxiliar

auxInacessiveis([], _):- !. % caso terminal, termina quando ja nao ha coordenadas para preencher

auxInacessiveis([C|R], T):- % tira uma coordenada
    insereObjectoCelula(T, r, C), % insere relva na coordenada
    auxInacessiveis(R, T). % chama a funcao de novo, para o resto das coordenadas


% aproveita/1
% A funcao devolve true se receber um tabuleiro e, apos a aplicacao da mesma, o tabuleiro tiver tendas em 
% todas as coordenadas em colunas ou linhas em que faltavam X tendas e que tem apenas X espacos livres.


aproveita((T, LinF, ColF)):-
    calculaObjectosTabuleiro(T, Linhas, Colunas, t), % vai buscar as tendas no tabuleiro
    auxAproveita(LinF, Linhas, T, 1, ListaVariaveis), % chama funcao auxiliar
    transpose(T, Ttransp), % vai buscar o tabuleiro transposto
    auxAproveita(ColF, Colunas, Ttransp, 1, ListaVariaveisT), % chama funcao auxiliar
    flatten(ListaVariaveis, ListaVariaveisF), % alisa as listas
    flatten(ListaVariaveisT, ListaVariaveisTF),
    auxAproveita2(ListaVariaveisF, T), % chama a segunda funcao auxiliar para as listas
    auxAproveita2(ListaVariaveisTF, T).

auxAproveita([], [], _, _, []):- !. % caso terminal, termina quando ja nao ha mais linhas do tabuleiro

auxAproveita([N1|R1], [N2|R2], [L|T], N, [Variaveis|ListaVariaveis]):- 
    % retira uma linha do tabuleiro e o numero de tendas nessa linha
    % adiciona as coordenadas das variaveis a ListaVariaveis
    findall(Z, (nth1(X, L, Y), var(Y), Z =(N, X)), Variaveis), % vai buscar as celulas vazias da linha
    length(Variaveis, V), % calcula o numero de celulas vazias da linha
    N3 is N1-N2, 
    V == N3, !, % verifica se o numero de espacos vazios e o mesmo numero que as tendas que faltam naquela linha
    N4 is N + 1,
    auxAproveita(R1, R2, T, N4, ListaVariaveis). % repete o processo para a linha seguinte

auxAproveita([_|R1], [_|R2], [_|T], N, ListaVariaveis):- 
    % se nao unificar com a parte anterior, simplesmente passa para a linha seguinte
    N1 is N + 1,
    auxAproveita(R1, R2, T, N1, ListaVariaveis).

auxAproveita2([], _):- !. % caso terminal, termina quando ja nao ha celulas para preencher

auxAproveita2([C|R], T):- % pega numa coordenada
    insereObjectoCelula(T, t, C), % insere uma tenda na coordenada
    auxAproveita2(R, T). % repete para o resto da lista



% limpaVizinhancas/1
% A funcao devolve true se receber um tabuleiro e, apos a aplicacao da mesma, o tabuleiro tiver relva
% em todas as celulas correspondentes a coordenadas da vizinhanca alargada de uma celula com uma tenda.

limpaVizinhancas((T, _, _)):- 
    todasCelulas(T, L, t), % procura as coordenadas das tendas
    findall(X, (member(Y, L), vizinhancaAlargada(Y, Z), member(X, Z)), L1), % vai buscar a celulas das vizinhancas das tendas
    auxLimpaVizinhancas(T, L1). % chama a funcao auxiliar

auxLimpaVizinhancas(_, []):- !. % caso terminal, termina quando ja nao ha coordenadas para preencher

auxLimpaVizinhancas(T, [C|R]):- % retira uma coordenada
    insereObjectoCelula(T, r, C), % insere relva na coordenada
    auxLimpaVizinhancas(T, R). % repete para o resto da lista



% unicaHipotese/1
% A funcao devolve true se receber um tabuleiro e, apos a aplicacao da mesma, o tabuleiro tiver uma tenda
% na celula na vizinhanca de uma arvore que tivesse apenas essa celula por preencher e se a arvore ainda
% nao tiver tenda.

unicaHipotese((T, _, _)):-
    todasCelulas(T, Arv, a),  
    todasCelulas(T, Ten, t), % vai buscar todas as celulas com arvores e tendas
    auxUnicaHipotese(Arv, Ten, T). % chama uma funcao auxiliar

auxUnicaHipotese([], _, _):- !. % caso terminal, para quando ja nao mais arvores para verificar

auxUnicaHipotese([C|R], Ten, T):- % retira uma arvore
    vizinhanca(C, Viz), % vai buscar a vizinhanca da arvore
    findall(X, (member(X, Ten), member(X, Viz)), []), % verifica que nao ha tendas na vizinhanca
    findall(X, (nth1(_, Viz, X), X = (Linha, Coluna), 
        nth1(Linha, T, L), nth1(Coluna, L, Y), var(Y)), Livres),
    % vai buscar as coordenadas da vizinhanca que estao livres
    length(Livres, 1), !, % verifica que so ha uma celula livre na vizinhanca
    Livres = [Cel],
    insereObjectoCelula(T, t, Cel), % poe uma tenda na celula
    auxUnicaHipotese(R, Ten, T). % repete para o resto das arvores

auxUnicaHipotese([C|R], Ten, T):- % retira uma arvore
    vizinhanca(C, Viz), % vai buscar a vizinhanca
    findall(X, (member(X, Ten), member(X, Viz)), []), !, % verifica que a nao ha tendas na vizinhanca
    auxUnicaHipotese(R, Ten, T). % repete para o resto das arvores

auxUnicaHipotese([C|R], Ten, T):- % retira uma arvore
    vizinhanca(C, Viz), % vai buscar a vizinhanca
    findall(X, (member(X, Ten), member(X, Viz)), TenViz), % vai buscar as tendas na vizinhanca
    member(Qualquer, TenViz), % vai buscar uma tenda qualquer da vizinhanca
    findall(X, (member(X, Ten), X \= Qualquer), NewTen), % cria uma lista de tendas sem essa tenda
    auxUnicaHipotese(R, NewTen, T). % chama a funcao para o resto das arvores e com a nova lista



% valida/2
% A funcao devolve true se receber duas listas de coordenadas, uma de arvores e outra de tendas, e as quais se podem
% corresponder apenas uma arvore a uma unica tenda na sua vizinhanca.


valida([], []):- !. % caso terminal, a funcao termina quando as listas estao ambas vazias

valida([C|LArv], LTen):- % retira as coordenadas de uma arvore
    vizinhanca(C, Viz), % vai buscar a vizinhanca da arvore
    findall(X, (member(X, Viz), member(X, LTen)), TenViz), % vai buscar os elementos da vizinhanca que pertencem a lista de tendas
    \+ TenViz = [], % verifica que a lista nao e vazia
    member(Ten, TenViz), % vai buscar uma tenda a lista
    findall(X, (member(X, LTen), X \= Ten), NewLTen), % cria uma lista sem a tenda anterior
    valida(LArv, NewLTen). % repete o processo com a nova lista e com o resto das arvores



% resolve/1
% A funcao devolve true se receber um puzzle e se, apos a sua aplicacao, o puzzle estiver resolvido.


resolve(Puzzle):-
    Puzzle = (T, _, _),
    inacessiveis(T), % poe relva nos espacos inacessiveis
    relva(Puzzle),  % poe relva nos espacos vazios em linhas ou colunas com o numero maximo de tendas
    aproveita(Puzzle), % poe tendas em linhas ou colunas em que so faltavam X tendas e so tinham X espacos livres
    relva(Puzzle), % poe relva nos espacos inacessiveis
    unicaHipotese(Puzzle), % poe tendas nos espacos onde so ha uma opcao para por a tenda
    limpaVizinhancas(Puzzle), % poe relva nos espacos a volta das tendas
    todasCelulas(T, CelArv, a), % procura todas as celulas com arvores
    todasCelulas(T, CelTen, t), % procura todas as celulas com tendas
    todasCelulas(T, CelVar, Var), % procura todas as celulas com variaveis
    var(Var), 
    (valida(CelArv, CelTen), !; % se o puzzle estiver resolvido para
    \+length(CelVar, 0), % se o puzzle nao estiver resolvido e nao houverem espacos livres da false
    member(X, CelVar), % retira um membro (ao calhas) das celulas com variaveis
    insereObjectoCelula(T, t, X), % insere uma tenda nessa celula
    resolve(Puzzle)). % e depois chama a funcao de novo

    




