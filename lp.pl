% Knowledge Base
may(rain).
may(not(elephants_fly)).
always(sun_rise).
always(birds_fly).

% Modal Logic Rules
diamond(X) :- may(X).
square(X) :- \+ may(not(X)).

% Additional rules to illustrate the usage
might_not_rain_tomorrow :- diamond(not(rain)).
sun_always_rises :- square(sun_rise).
birds_always_fly :- square(birds_fly).
elephants_might_not_fly :- diamond(not(elephants_fly)).