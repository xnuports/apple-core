# timeout(1) depends on Linux prctl(PR_SET_CHILD_SUBREAPER); needs a
# Darwin reaping strategy before it can build.
T_NOBUILD=	yes
