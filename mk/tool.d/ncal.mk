# ncal includes its own calendar.h with angle brackets.
T_CFLAGS+=	-I${T_SRCDIR}

# terminfo entry highlighting
T_LDADD+=	-lcurses
