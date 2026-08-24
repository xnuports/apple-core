# telnet: built without AUTHENTICATION/ENCRYPTION, so it needs neither
# krb5 nor DES -- only libtelnet's crypto-free option helpers, and the
# system curses for terminal handling.  USE_TERMIO selects the modern
# termios path (skips the legacy sgtty tchars/ltchars code and the
# conflicting cc_t typedef); KLUDGELINEMODE enables linemode support.
T_CFLAGS+=	-DUSE_TERMIO -DKLUDGELINEMODE
.include "${TOP}/mk/with-libtelnet.mk"
T_LDADD+=	-lncurses
