# ee: the "easy editor".  ee.c gates its standard includes behind HAS_*
# config macros (normally set by a configure script); NCURSE selects the
# bundled new_curse (a self-contained termcap/terminfo curses needing no
# library).  catgets works on macOS, so NO_CATGETS is left undefined.
T_CFLAGS+=	-DNCURSE -DHAS_STDLIB -DHAS_STDARG -DHAS_UNISTD -DHAS_SYS_WAIT
