# chkpasswd: verifies passwords via OpenDirectory; shares the OD/PAM
# password backends with passwd.
T_LDADD+=	-framework OpenDirectory -framework CoreFoundation -lpam
