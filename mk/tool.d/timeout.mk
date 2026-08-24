# timeout: the bsdutils source uses Linux's child-subreaper API, which Darwin
# has no equivalent for.  include/sys/prctl.h shims the two operations it
# needs; see that header for the behavioural difference this leaves in the
# default (non---foreground) mode.
