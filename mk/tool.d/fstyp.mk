# fstyp: the dispatcher only.  The per-filesystem probes (fstyp_msdos,
# fstyp_ntfs, fstyp_udf) are separate binaries on stock macOS -- each has
# its own main() and its own copy of blockcheck()/rawname() -- so they are
# built from their own PROGS entries rather than linked in here.
T_SRCS=		fstyp.c
