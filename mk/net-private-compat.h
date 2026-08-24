/*-
 * mk/net-private-compat.h
 *
 * Apple-private networking constants and structures that the
 * network_cmds sources reference but the public SDK headers omit.
 * Everything below was transcribed verbatim from the corresponding
 * xnu headers so kernel ABI stays exact:
 *
 *   bsd/sys/socket_private.h   NET_RT_DUMPX(_FLAGS), SO_RECV_ANYIF,
 *                              SO_TC_CTL
 *   bsd/netinet/in.h (PRIVATE) IP_NO_IFT_CELLULAR
 *   bsd/net/route_private.h    RTM_GET_SILENT/RTM_GET_EXT,
 *                              struct rt_msghdr_ext
 *   bsd/net/bpf.h (PRIVATE)    struct xbpf_d, BPF_D_* directions
 *
 * Included via -include from mk/with-netcmds.mk; never include it
 * directly from source.
 */
#ifndef DARWINTOOLS_NET_PRIVATE_COMPAT_H_
#define DARWINTOOLS_NET_PRIVATE_COMPAT_H_

#include <stdint.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/route.h>

/* --- bsd/sys/socket_private.h ------------------------------------ */

#ifndef NET_RT_DUMPX
#define NET_RT_DUMPX            8       /* private */
#define NET_RT_DUMPX_FLAGS      9       /* private */
#endif

#ifndef SO_RECV_ANYIF
#define SO_RECV_ANYIF           0x1104  /* unrestricted inbound processing */
#endif

/* full traffic-class enum (bsd/sys/socket_private.h) */
#ifndef SO_TC_BK_SYS
#define SO_TC_BK_SYS    100             /* lowest class */
#define SO_TC_BK        200
#define SO_TC_BE        0
#define SO_TC_RD        300
#define SO_TC_OAM       400
#define SO_TC_AV        500
#define SO_TC_RV        600
#define SO_TC_VI        700
#define SO_TC_VO        800
#define SO_TC_CTL       900             /* highest class */
#define SO_TC_MAX       10              /* Total # of traffic classes */
#define SO_TC_UNSPEC    ((int)-1)       /* Traffic class not specified */
#endif

#ifndef SO_TRAFFIC_CLASS
#define SO_TRAFFIC_CLASS        0x1086  /* Traffic service class (int) */
#define SO_RECV_TRAFFIC_CLASS   0x1087  /* Receive traffic class (bool) */
#define SO_TRAFFIC_CLASS_DBG    0x1088  /* Debug traffic class (struct so_tcdbg) */
#endif

/* --- bsd/netinet/in.h (PRIVATE section) -------------------------- */

#ifndef IP_NO_IFT_CELLULAR
#define IP_NO_IFT_CELLULAR      6969    /* for internal use only */
#define IP_NO_IFT_PDP           IP_NO_IFT_CELLULAR /* deprecated */
#define IP_OUT_IF               9696    /* for internal use only */
#endif

/* --- bsd/net/route_private.h ------------------------------------- */

/* structs rt_reach_info/rt_msghdr_ext + RTM_GET_SILENT/EXT now come from
 * the real xnu header shipped under include/net/route_private.h.        */

/* --- bsd/net/bpf.h (BSD_KERNEL_PRIVATE) --------------------------- */

#ifndef BPF_D_IN
#define BPF_D_NONE              0x0     /* See no packet (for writing only) */
#define BPF_D_IN                0x1     /* See incoming packets */
#define BPF_D_OUT               0x2     /* See outgoing packets */
#define BPF_D_INOUT             0x3     /* See incoming and outgoing packets */
#endif

struct xbpf_d {
	uint32_t        bd_structsize;  /* Size of this structure. */
	int32_t         bd_dev_minor;
	int32_t         bd_sig;
	uint32_t        bd_slen;
	uint32_t        bd_hlen;
	uint32_t        bd_bufsize;
	pid_t           bd_pid;

	uint8_t         bd_promisc;
	uint8_t         bd_immediate;
	uint8_t         bd_hdrcmplt;
	uint8_t         bd_async;

	uint8_t         bd_headdrop;
	uint8_t         bd_direction;
	uint8_t         bh_compreq;
	uint8_t         bh_compenabled;

	uint8_t         bd_exthdr;
	uint8_t         bd_trunc;
	uint8_t         bd_pkthdrv2;
	uint8_t         bd_pad;

	uint64_t        bd_rcount;
	uint64_t        bd_dcount;
	uint64_t        bd_fcount;
	uint64_t        bd_wcount;
	uint64_t        bd_wdcount;

	char            bd_ifname[IFNAMSIZ];

	uint64_t        bd_comp_count;
	uint64_t        bd_comp_size;

	uint32_t        bd_scnt;        /* number of packets in store buffer */
	uint32_t        bd_hcnt;        /* number of packets in hold buffer */

	uint64_t        bd_read_count;
	uint64_t        bd_fsize;
};

/*
 * DSCP codepoints (bsd/netinet/in_private.h, RFC 2474/2597/3246/4594).
 * Values are 6-bit codepoints as used with IPTOS_DSCP_SHIFT.
 */
#ifndef _DSCP_DF
#define _DSCP_DF        0       /* RFC 2474 */
#define _DSCP_CS0       _DSCP_DF
#define _DSCP_CS1       8       /* RFC 2474 */
#define _DSCP_CS2       16      /* RFC 2474 */
#define _DSCP_CS3       24      /* RFC 2474 */
#define _DSCP_CS4       32      /* RFC 2474 */
#define _DSCP_CS5       40      /* RFC 2474 */
#define _DSCP_CS6       48      /* RFC 2474 */
#define _DSCP_CS7       56      /* RFC 2474 */
#define _DSCP_AF11      10      /* RFC 2597 */
#define _DSCP_AF12      12      /* RFC 2597 */
#define _DSCP_AF13      14      /* RFC 2597 */
#define _DSCP_AF21      18      /* RFC 2597 */
#define _DSCP_AF22      20      /* RFC 2597 */
#define _DSCP_AF23      22      /* RFC 2597 */
#define _DSCP_AF31      26      /* RFC 2597 */
#define _DSCP_AF32      28      /* RFC 2597 */
#define _DSCP_AF33      30      /* RFC 2597 */
#define _DSCP_AF41      34      /* RFC 2597 */
#define _DSCP_AF42      36      /* RFC 2597 */
#define _DSCP_AF43      38      /* RFC 2597 */
#define _DSCP_VA        44      /* RFC 5865 */
#define _DSCP_EF        46      /* RFC 3246 */
#endif

/* --- systm/kctl socket generators (sys/sys_domain_private.h) ------- */
#include <sys/sys_domain_private.h>
#include <sys/kern_control_private.h>
#include <sys/kern_event_private.h>

/* --- routing stats (bsd/net/route_private.h) ----------------------- */
#include <net/route_private.h>

/* --- private ifreq/if_qstatsreq (bsd/net/if_private.h) ------------- */
#include <net/if_private.h>
#include <sys/sockio_private.h>

#endif /* !DARWINTOOLS_NET_PRIVATE_COMPAT_H_ */
