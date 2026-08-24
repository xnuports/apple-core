/*-
 * Public Domain dedication for darwintools.
 *
 * <CommonCrypto/CommonDigestSPI.h> shim: Apple's SPI header exposes
 * streaming digest context (CCDigestCtx) plus the CCDigestAlg enum,
 * but none of it ships in the public SDK even though mtree(8)'s
 * sources use it.  Rebuild the needed surface on top of the public
 * CommonDigest.h API.
 */

#ifndef _CC_COMMON_DIGEST_SPI_H_
#define _CC_COMMON_DIGEST_SPI_H_

#include <CommonCrypto/CommonDigest.h>

__BEGIN_DECLS

/* Digest algorithm selector (values match Apple's SPI). */
enum {
	kCCDigestNone = 0,
	kCCDigestMD5,
	kCCDigestSHA1,
	kCCDigestSHA224,
	kCCDigestSHA256,
	kCCDigestSHA384,
	kCCDigestSHA512,
	kCCDigestRMD160		/* RIPEMD-160: not implemented here */
};
typedef uint32_t CCDigestAlg;

/*
 * Streaming digest context.  Apple's real struct is opaque; ours is a
 * tagged union over the public CC_*_CTX types.
 */
typedef struct {
	CCDigestAlg	alg;
	union {
		CC_MD5_CTX	md5;
		CC_SHA1_CTX	sha1;
		CC_SHA256_CTX	sha224;
		CC_SHA256_CTX	sha256;
		CC_SHA512_CTX	sha384;
		CC_SHA512_CTX	sha512;
	} u;
} CCDigestCtx;

static inline int
CCDigestInit(CCDigestAlg algorithm, CCDigestCtx *ctx)
{
	if (ctx == NULL)
		return -1;
	ctx->alg = algorithm;
	switch (algorithm) {
	case kCCDigestMD5:
		return CC_MD5_Init(&ctx->u.md5) ? 0 : -1;
	case kCCDigestSHA1:
		return CC_SHA1_Init(&ctx->u.sha1) ? 0 : -1;
	case kCCDigestSHA224:
		return CC_SHA224_Init(&ctx->u.sha224) ? 0 : -1;
	case kCCDigestSHA256:
		return CC_SHA256_Init(&ctx->u.sha256) ? 0 : -1;
	case kCCDigestSHA384:
		return CC_SHA384_Init(&ctx->u.sha384) ? 0 : -1;
	case kCCDigestSHA512:
		return CC_SHA512_Init(&ctx->u.sha512) ? 0 : -1;
	default:
		return -1;
	}
}

static inline int
CCDigestUpdate(CCDigestCtx *ctx, const void *data, size_t len)
{
	if (ctx == NULL || data == NULL)
		return -1;
	switch (ctx->alg) {
	case kCCDigestMD5:
		return CC_MD5_Update(&ctx->u.md5, data, (CC_LONG)len) ? 0 : -1;
	case kCCDigestSHA1:
		return CC_SHA1_Update(&ctx->u.sha1, data, (CC_LONG)len) ? 0 : -1;
	case kCCDigestSHA224:
		return CC_SHA224_Update(&ctx->u.sha224, data, (CC_LONG)len) ? 0 : -1;
	case kCCDigestSHA256:
		return CC_SHA256_Update(&ctx->u.sha256, data, (CC_LONG)len) ? 0 : -1;
	case kCCDigestSHA384:
		return CC_SHA384_Update(&ctx->u.sha384, data, (CC_LONG)len) ? 0 : -1;
	case kCCDigestSHA512:
		return CC_SHA512_Update(&ctx->u.sha512, data, (CC_LONG)len) ? 0 : -1;
	default:
		return -1;
	}
}

static inline int
CCDigestFinal(CCDigestCtx *ctx, unsigned char *output)
{
	if (ctx == NULL || output == NULL)
		return -1;
	switch (ctx->alg) {
	case kCCDigestMD5:
		return CC_MD5_Final(output, &ctx->u.md5) ? 0 : -1;
	case kCCDigestSHA1:
		return CC_SHA1_Final(output, &ctx->u.sha1) ? 0 : -1;
	case kCCDigestSHA224:
		return CC_SHA224_Final(output, &ctx->u.sha224) ? 0 : -1;
	case kCCDigestSHA256:
		return CC_SHA256_Final(output, &ctx->u.sha256) ? 0 : -1;
	case kCCDigestSHA384:
		return CC_SHA384_Final(output, &ctx->u.sha384) ? 0 : -1;
	case kCCDigestSHA512:
		return CC_SHA512_Final(output, &ctx->u.sha512) ? 0 : -1;
	default:
		return -1;
	}
}

static inline size_t
CCDigestOutputSize(const CCDigestCtx *ctx)
{
	if (ctx == NULL)
		return 0;
	switch (ctx->alg) {
	case kCCDigestMD5:
		return CC_MD5_DIGEST_LENGTH;
	case kCCDigestSHA1:
		return CC_SHA1_DIGEST_LENGTH;
	case kCCDigestSHA224:
		return CC_SHA224_DIGEST_LENGTH;
	case kCCDigestSHA256:
		return CC_SHA256_DIGEST_LENGTH;
	case kCCDigestSHA384:
		return CC_SHA384_DIGEST_LENGTH;
	case kCCDigestSHA512:
		return CC_SHA512_DIGEST_LENGTH;
	default:
		return 0;
	}
}

__END_DECLS

#endif /* !_CC_COMMON_DIGEST_SPI_H_ */
