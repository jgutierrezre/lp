g(
    1,
    [
        ["a","b","c","d","e"],
        [e("a","b"),e("a","c"),e("b","d"),e("c","d"),e("d","e")],
        [v("a","p"),v("b","q"),v("c","q"),v("d","p"),v("e","q")]
    ]
).

next(Node,NextNode) :-
    g(_,G),
    [_,E,_] = G,
    member(e(Node,NextNode),E).

value(Node,Value) :-
    g(_,G),
    [_,_,V] = G,
    member(v(Node,Value),V).

evaluate(Predicate,Value,Node) :-
    (  callable(Predicate)
    -> call(Predicate,Node)
    ;  Predicate = Value).

b(Predicate,Node) :-
    forall(
            (next(Node,NextNode),value(NextNode,Value)),
            evaluate(Predicate,Value,NextNode)
        ).

d(Predicate,Node) :-
    once(
            (
                (next(Node,NextNode),value(NextNode,Value)),
                evaluate(Predicate,Value,NextNode)
            )
        ).

% b(G,U,P) :-
%     [N,E,V] = G,
%     member(U,N),
%     findall(
%         Value,
%         (
%             member(e(U,Neighbor),E),
%             member(v(Neighbor,Value),V)
%         ),
%         Values
%     ),
%     forall(
%         member(Value,Values),
%         Value = P
%     ).

% d(G,U,P) :-
%     [N,E,V] = G,
%     member(U,N),
%     findall(
%         Value,
%         (
%             member(e(U,Neighbor),E),
%             member(v(Neighbor,Value),V)
%         ),
%         Values
%     ),
%     member(
%         P,
%         Values
%     ).

% valid(G,U,P) :-
%     [N,E,V] = G,
%     member(U,N),

