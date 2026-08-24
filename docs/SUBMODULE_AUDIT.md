# Submodule Audit — Full Overview

*Date: 2026-08-21 · Updated: 2026-08-24 · Scope: `darwintools/src/*`, `darwintools/lib/*` vs `references/bsdutils`, `references/coreutils-bsd` and stock macOS*

## 1. Inventory

**14 source groups** (~230 binaries) after `at_cmds` removal, **3 built libraries** (`libmd`, `libtelnet`, `libutil`), 1 helper tool (`xcrmint`, replacing `fix-macosx-internal-sdk`). All groups build via Xcode projects (`macosx.internal` SDK in most).

| Group | Tools |
|---|---|
| `adv_cmds` | cap_mkdb, finger, gencat, genwrap*, last, locale, localedef, lsvfs, pkill/pgrep, ps, stty, tabs, tty, whois |
| `at_cmds` | appleping, appletalk, at_cho_prn, atlookup, atprint, atstatus, chooser*, setdbg, tuple_pr* (* = in-tree libs) |
| `basic_cmds` | mesg, write |
| `bc` | bc + dc (single binary, hardlinked) — Gavin Howard's bc |
| `diskdev_cmds` | dev_mkdb, dirs_cleaner, edquota, fdisk, fsck, fsck_fskit, fstyp (+msdos/ntfs/udf variants), fuser, mount, mount_devfs, mount_fdesc, newfs_fskit, quota, quotacheck, quotaon/quotaoff, repquota, setclass, tmp_cleaner, umount, vsdbutil; in-tree `libdisk.a` |
| `doc_cmds` | makewhatis |
| `file_cmds` | chflags, chmod, chown, cksum(+sum link), compress, cp, dd, df, du, gzip (+gunzip/zcat etc.), install, ipcrm, ipcs, ln, ls, mkdir, mkfifo, mknod, mtree, mv, pathchk, pax, rm(+unlink link), rmdir, shar, stat(+readlink link), touch, truncate, xattr, chgrp link |
| `mail_cmds` | mail / mailx |
| `misc_cmds` | calendar, leave, ncal/cal, tsort, units |
| `network_cmds` | arp, dnctl, ifconfig, kdumpd, ndp, netstat, ping, ping6, rarpd, route, rtadvd, rtsol/rtsold, spray, traceroute, traceroute6; in-tree `libnetwork_cmds_lib.a` |
| `patch_cmds` | cmp, diff, diff3, diffstat, patch, sdiff |
| `remote_cmds` | logger, talk, talkd/ntalkd, telnet, telnetd, tftp, tftpd, wall |
| `shell_cmds` | alias, apply, basename, chroot, date, dirname, echo, env, expr, false, find, getopt, hexdump, hostname, id, jot, kill, killall, lastcomm, locate, lockf, logname, mktemp, nice, nohup, path_helper, printenv, printf, pwd, realpath, renice, script, seq, sh, shlock, sleep, stdbuf, su, systime, tee, test/[ , time, true, uname, users, w (+uptime man), what, whereis, which, who, xargs, yes |
| `system_cmds` | ac, accton, arch, at, atrun, chkpasswd, chpass, cpuctl, dmesg, dynamic_pager, fs_usage, gcore (+GCoreFramework), getconf, getty, hostinfo, iosim, iostat, kpgo, latency, login, lskq, lsmp, ltop, mean, memory_pressure, mkfile, mslutil, newgrp, nologin, nvram, pagesize, passwd, proc_uuid_policy, purge, pwd_mkdb, reboot, sa, sc_usage, shutdown, stackshot, sync, sysctl, taskpolicy, vifs, vipw, vm_purgeable_stat, vm_stat, wait4path, wordexp-helper, zdump, zic, zlog, zprint |
| `text_cmds` | banner, bintrans, cat, col, colrm, column, comm, csplit, cut, ed, expand, fmt, fold, grep (+egrep/fgrep/zgrep…), head, join, jq (+bundled oniguruma), lam, look, md5 (+sha1sum…sha512sum links), nl, paste, pr, rev, rs, sed, sort, split, tail, tr, ul, unexpand, uniq, unvis, vis, wc |

## 2. Tools that don't belong / can't work (removal candidates)

| Item | Verdict | Why |
|---|---|---|
| **`at_cmds` (entire group)** | **Remove** | AppleTalk legacy (`appleping`, `atlookup`, `atprint`, …). Needs `AppleTalk.framework` + kernel `netat` headers — both removed from macOS years ago. Unbuildable, dead technology. Also the only group on obsolete NeXT build files. |
| `remote_cmds/telnetd`, `tftpd`, `talkd` | ✅ **Gated** (`MK_DAEMONS`, default off) | Network *daemons*, not CLI tools; telnetd also needs private `libtelnet.a`. Modern macOS has dropped telnetd entirely. |
| `network_cmds/rarpd`, `spray` | ✅ **Gated** (`MK_DAEMONS`, default off) | Boot-era RARP daemon; obsolete NFS benchmark tool. Neither is in either reference project. |
| `system_cmds` diagnostics tier | ✅ **Gated** (`MK_DIAGNOSTICS`, default off) | `fs_usage`, `latency`, `sc_usage`, `ltop`, `lsmp`, `lskq`, `hostinfo`, `zprint`, `zlog`, `mslutil`, `kpgo`, `mean`, `stackshot`, `gcore`, `memory_pressure`, `vm_stat`, `vm_purgeable_stat`, `purge`, `iostat`, `iosim`, `cpuctl`, `proc_uuid_policy`, `dynamic_pager` — these ship with macOS but are system diagnostics/dev tools, not coreutils-like. They're also the worst offenders for private dependencies (see §4). If darwintools is strictly coreutils-like, this tier goes; if it's "the full BSD userland," they stay. |
| `adv_cmds/genwrap` + test helpers | ✅ **Excluded** from `progs.mk` (`2077a94`) | `/AppleInternal`-only internal tools, not stock userland. |
| `diskdev_cmds/dirs_cleaner`, `tmp_cleaner` | ✅ Kept, installed to `usr/libexec` (tmp_cleaner via `T_SCRIPT`) | launchd housekeeping scripts installed to `/usr/libexec` — not userland tools. |

Everything else fits the "Apple-flavored BSD coreutils" identity: all of `file_cmds`, `text_cmds`, `shell_cmds`, `patch_cmds`, `basic_cmds`, `misc_cmds`, `mail_cmds`, `doc_cmds`, plus the legit parts of `adv_cmds`/`diskdev_cmds`/`network_cmds`.

## 3. Missing tools vs references

> **RESOLVED 2026-08-22:** scope fixed at Option C (strict default, optional tiers). All four candidates ported from FreeBSD into `src/bsd_additions/`.

Cross-checking against `bsdutils` (~100 tools) and `coreutils-bsd` (71):

| Missing | Notes |
|---|---|
| **`factor`** | In both references. Prime-factorization; trivially portable from FreeBSD. |
| **`timeout`** | bsdutils only. Genuinely useful; FreeBSD source ports cleanly. |
| **`indent`** | bsdutils only. C code formatter; borderline dev-tool. |
| **`ee`** | bsdutils only. FreeBSD's easy editor — arguably out of scope since macOS ships nano/vim instead. |

### Missing vs *stock macOS* (not the references)

> **RESOLVED 2026-08-24:** `fstyp_hfs` located and wired; `src/hfs` submodule added (`4d0fd58`, build wiring `53cb92c`).

| Item | Notes |
|---|---|
| ~~**`fstyp_hfs`**~~ ✅ | Stock macOS ships `/sbin/fstyp_hfs` alongside `fstyp`, `fstyp_msdos`, `fstyp_ntfs` and `fstyp_udf`, but it lives in Apple's `hfs` project rather than `diskdev_cmds`, so `fstyp.tproj` had no source for it. Added as the `src/hfs` submodule (upstream `apple-oss-distributions/hfs`, `fstyp_hfs/fstyp_hfs.c`). All five probes now build as separate binaries, matching stock `/sbin` exactly. |

**`src/hfs` triage vs stock (2026-08-24).** Stock ships `fstyp_hfs` as a real `/sbin`
binary; `fsck_hfs`, `newfs_hfs` and `mount_hfs` are `/sbin` symlinks into
`hfs.fs/Contents/Resources`. All four are wired (installed flat into `sbin/` for now —
see PROGRESS.md open item on bundle layout); `fsck_hfs` alone does not build.
`CopyHFSMeta` and `hfs_util` (shipped as `hfs.util` inside the bundle) were
deliberately skipped. Excluded as not shipped: `hfs-alloc-trace` (dev tool),
`livefiles_*_plugin` (testers), `hfs_appex`, `hfs_xctests`, `tests`.

Not actually missing despite appearances:

- **`dc`** — included: our `bc` is Gavin Howard's bc, one binary hardlinked as both `bc` and `dc`
- **`readlink`**, `unlink`, `chgrp`, `sum` — provided as stat/rm/chown/cksum hardlinks via file_cmds aggregate targets
- **`install`** = file_cmds' `xinstall` equivalent ✓

We're otherwise **ahead** of the references: we carry the full BSD extras (`jot`, `apply`, `calendar`, `ncal`, `units`, `rs`, `lam`, `vis/unvis`, `banner`, `jq`, `md5` variants, `chflags`, `pax`, `mtree`, `xattr`, …).

## 4. Library audit (updated 2026-08-22)

### Strategy
Link against macOS SDK/system libraries wherever possible; build from source only when no system equivalent exists. Vendored interface headers live in `include/`.

### Read the conditional before hunting a header

`lib_fsck_hfs/dfalib/SRuntime.h` includes `<Errors.h>`, `<MacMemory.h>`,
`<MacTypes.h>` and `<HFSVolumes.h>` — all classic CarbonCore headers Apple no
longer ships.  Chasing them cost a long detour: CarbonCore's `MacErrors.h`
covers only some of the codes, its `Files.h` collides with dfalib's own
`kVCBFlags*` enums, and four `OSErr` values appear in no SDK at all.

None of it was necessary.  Those includes sit in the `#else` of `#if BSD`
nine lines above — the *classic Mac OS* fallback.  Building with `-DBSD=1`
takes the modern path (`<hfs/hfs_format.h>` plus dfalib's own type and error
definitions) and the whole problem disappears.  `-DDEBUG_BUILD=0` then
selects release semantics for dfalib's `if (DEBUG_BUILD && ...)` assertions.

When a missing header turns up, check *why* it is being included and whether
the compile is even meant to reach that line, before going looking for it.

### Frameworks vendored under `frameworks/` shadow the SDK

`-F ${TOP}/frameworks` puts our copies ahead of the SDK's, so a vendored
`FSKit.framework` would mask Apple's real public one for any tool built with
that flag.  The recovered FSKit headers are class-dump output and are not a
substitute for the SDK's, so `FSKitCFunctions_private.h` is staged in
`include/FSKit/` instead: `<FSKit/FSKit.h>` keeps resolving to Apple's public
header while the private include resolves from `include/`.  No tool currently
builds with both, but the trap is live.

### Caution: staged headers can shadow bundled ones

`CPPFLAGS` puts `-I include` ahead of every per-tool `-I`, so anything vendored
into `include/` wins over a copy a tool bundles itself.  Staging the transitive
closure of one tool's private includes is therefore not free: the xnu
`sys/tree.h` pulled in for ifconfig was itself unbuildable (it needs
`libkern/tree.h`, which is unavailable) *and* masked localedef's working
bundled copy, breaking a tool that had been fine.  Incremental builds hid it.

Stage a header only when a tool actually needs it, prefer the SDK or a
per-tool `-I` over `include/`, and confirm with a from-scratch build.

### Dropped submodules → system libraries

| Old submodule | Replaced by | Notes |
|---|---|---|
| `libz` | `zlib.h` + `libz.tbd` | |
| `bzip2` | `bzlib.h` + `libbz2.tbd` | |
| `xz` | `liblzma.tbd` + `include/liblzma/lzma.h` | system lib ships API, no public header |
| `libcurses` | curses/ncurses/termcap headers + `.tbd`s | Apple ncurses is 5.7-era; homebrew 6.6 as fallback |
| `libedit` | `editline/readline.h`, `histedit.h` + `libedit.tbd` | old but battle-tested (`sh` links it) |
| `libpam` | `security/pam_*.h` + `libpam.tbd` | |
| `bsm` / `OpenBSM` | `bsm/*.h` + `libbsm.tbd` | nothing in-tree needs auditd itself |
| `ipsec` | `net/pfkeyv2.h`, `netinet6/ipsec.h` + `libipsec.tbd` | |
| `krb5` | `krb5.h`, `com_err.h` + `libkrb5.tbd` → Kerberos.framework | core `krb5_*` API present incl. sendauth/recvauth |
| `libpcap` | `pcap.h`, `pcap/` + `libpcap.tbd` | |
| `sysmon` | `libsysmon.tbd` + `include/libsysmon/` RE headers | header-only staging |
| `libxo` | `libxo.tbd` + `include/libxo/xo.h` | vendored header is self-contained |

Runtime availability is guaranteed by the dyld shared cache even though `/usr/lib/*.dylib` files are not on disk.

### Kept in `lib/`

| Submodule | Why |
|---|---|
| `libmd` | system `libmd.tbd` exports one-shot wrappers only (no `MD5Init`/`SHA256_Init` streaming API); no public headers |
| `libtelnet` | absent from system and public SDKs |
| `libutil` | no `libutil.h` in SDK at all; future home of `login_cap`/`setusercontext` |

Also: `PrivateFrameworks/` renamed to `frameworks/`; staged APFS/ktrace headers in `include/apfs/`, `include/ktrace/`.

## 5. Recommended next steps

1. ~~Decide scope~~ ✅ **Option C**, implemented as three build tiers, all default off:
   `MK_DIAGNOSTICS` (23 progs), `MK_DAEMONS` (9), `MK_PRIVATE_FRAMEWORKS` (7 — the
   FSKit/APFS/kextmanager consumers).
2. ~~Remove `at_cmds` outright~~ ✅ done (`cebc8c4`).
3. ~~Add missing tools~~ ✅ done: `factor`, `timeout`, `indent`, `ee` → `src/bsd_additions/`;
   `genwrap` excluded (`/AppleInternal`-only); `src/hfs` added for the `fstyp_hfs` gap.
4. ~~Grow `lib/`~~ ✅ `libtelnet` (crypto-free), `libxo`, `libnetcmds`, and `libutil` incl.
   the `login_cap`/`getcap` family plus C++ `wipefs`/`ExtentManager`. `libfsck_hfs.a` builds
   on demand but is out of `all` until `<Errors.h>` is available.
5. ~~Private-header strategy~~ ✅ resolved. Public API → SDK `.tbd`s; private headers vendored
   into `include/` (xnu `bsd/`, Apple Libc, the internal SDK) and private *frameworks* into
   `frameworks/` reached with `-F`. Where Apple ships no header at all, interfaces were
   recovered from authoritative artefacts rather than invented — MIG `.defs` for
   kextmanager, `ipsw class-dump` over the dyld shared cache for FSKit/LiveFS, and the
   `CFSTR` literals inside Apple's own shipped `mount_hfs` for DiskImages2.

## 6. Build status (2026-08-24)

From a from-scratch clean build (`rm -rf build && bmake ...`) — an incremental
build had previously masked a regression where a staged xnu `sys/tree.h`
shadowed localedef's bundled copy (fixed, `4b5d8c7`), so the numbers below are
only ever taken from a clean one.

| Configuration | Declared | Building |
|---|---|---|
| default `bmake` | 214 | **214** |
| `bmake MK_PRIVATE_FRAMEWORKS=yes` | 221 | **221** (222 binaries with `dc`) |

Zero build errors. Every tool in the inventory compiles.

Three carry behavioural caveats, recorded in their fragments rather than
glossed over:

- `timeout` — Darwin has no child-subreaper API (neither Linux's `prctl` nor
  FreeBSD's `procctl`), so its default mode returns when the direct child
  exits rather than the last descendant. `--foreground` is exact.
- `mount`, `fsck_fskit`, `newfs_fskit`, `fsck_hfs` — report FSKit as
  unavailable via `mk/compat/fskit_stub.c`, reproducing Apple's own `ENOTSUP`
  fallback, because the private FSKit headers the real path needs are not
  shipped.
- `ifconfig` — `IF_NETEM_MODEL_IOD`/`_FPD` appear in no published header and
  were recovered by disassembling the shipped `/sbin/ifconfig`; the `nlc` arm
  agreeing with the published value is the control that validates them.
