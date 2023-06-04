g(
    1,
    [
        ["a","b","c","d","e"],
        [e("a","b"),e("a","c"),e("b","d"),e("c","d"),e("d","e")],
        [v("a","p"),v("b","q"),v("c","q"),v("d","p"),v("e","q")]
    ]
).

% g(
%     2,
%     [
%         ["a","b","c","d","e", "f", "g", "h", "i"],
%         [e("a","b"),e("b","c"),e("c","d"),e("c","g"),e("d","e"),e("d","f"),e("g","h"),e("g","i"),e("h","i")],
%         [v("a","a and b"),v("b","not a or c"),v("c","not c or not b"),v("d","not c"),v("e","not a"),v("f","c"),v("g","not b"),v("h","a"),v("i","b")]
%     ]
% ).

% g(
%     3,
%     [
%         ["t0","v0","u","v1","t1","s1","s0"],
%         [e("t0","v0"),e("s0","t0"),e("s0","u"),e("u","v0"),e("u","v1"),e("s1","u"),e("s1","t1"),e("t1","u")],
%         [v("v0","q"),v("u","p"),v("v1","q")]
%     ]
% ).





next(Node,G, NextNode) :-
    % g(_,G),
    [_,E,_] = G,
    member(e(Node,NextNode),E).

value(Node, G,Value) :-
    % g(_,G),
    [_,_,V] = G,
    member(v(Node,Value),V).

evaluate(Predicate,Value, G,Node) :-
    (  callable(Predicate)
    -> call(Predicate,Value, G,Node)
    ;  Predicate = Value).

% Always
b(Predicate, Value, G,Node) :-
    forall(
            (next(Node, G,NextNode),value(NextNode, G,NewValue)),
            evaluate(Predicate,NewValue,G, NextNode)
        ).

% Eventually
d(Predicate, Value, G,Node) :-
    once(
            (
                (next(Node, G, NextNode),value(NextNode, G, NewValue)),
                evaluate(Predicate,NewValue,G, NextNode)
            )
        ).

and(Predicate1,Predicate2,Value, G, Node) :-
    evaluate(Predicate1,Value, G,Node),
    evaluate(Predicate2,Value, G,Node).

or(Predicate1, Predicate2, Value, G, Node) :-
    evaluate(Predicate1,Value, G,Node);
    evaluate(Predicate2,Value, G,Node).

valid(G, U, P) :-
    value(U,G,Value),
    evaluate(P,Value,G,U).

% -------------------------------------------------
%                    EXAMPLES
% -------------------------------------------------
% 
% Modal operations have only one parameter ('b' (box), 'd' (dimond), 'and' and 'or')

% g(_,G),valid(G,"a",b(b("p"))).
% output : true

% g(_,G),b(b("q"),G,"a").
% output : false

% g(_,G),valid(G,"a",b(b("p"))).
% output : true

% g(_,G),valid(G,"a",b(and(b("p"),b("q")))).
% output : false

% g(_,G),valid(G,"a",b(and(b("p"),b("p")))).
% output : true

% g(_,G),valid(G,"a",b(or(b("p"),b("q"))))
% output : false

% g(_,G),valid(G,"a",b(or(b("p"),b("q")))).
% output : true

% g(_,G),valid(G,"a",b(or(b("q"),b("q")))).
% output : false
