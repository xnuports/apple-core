.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	-lresolv

# w uses the libxo API for structured output.
.include "${TOP}/mk/with-libxo.mk"
