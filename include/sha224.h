/*-
 * Public Domain dedication for darwintools.
 *
 * <sha224.h> shim mapping the legacy libmd SHA224_* API onto
 * CommonCrypto, mirroring include/sha.h.
 */

#ifndef _SHA224_H_
#define _SHA224_H_

#include <sys/types.h>
#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>

typedef CC_SHA256_CTX		SHA224_CTX;

#define SHA224Update		CC_SHA224_Update
#define SHA224_Init		CC_SHA224_Init
#define SHA224_Update		CC_SHA224_Update

static inline void
SHA224Init(SHA224_CTX *c)
{
	CC_SHA224_Init(c);
}

static inline char *
SHA224_End(SHA224_CTX *c, char *buf)
{
	unsigned char digest[CC_SHA224_DIGEST_LENGTH];
	static const char hex[] = "0123456789abcdef";
	int i;

	if (buf == NULL)
		return NULL;
	CC_SHA224_Final(digest, c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

static inline char *
SHA224_Data(const void *data, u_int len, char *buf)
{
	SHA224_CTX c;

	SHA224Init(&c);
	SHA224Update(&c, data, len);
	return SHA224_End(&c, buf);
}

static inline char *
SHA224_File(const char *filename, char *buf)
{
	SHA224_CTX c;
	unsigned char digest[CC_SHA224_DIGEST_LENGTH], data[65536];
	static const char hex[] = "0123456789abcdef";
	FILE *fp;
	size_t len;
	int i;

	if (buf == NULL || (fp = fopen(filename, "r")) == NULL)
		return NULL;
	SHA224Init(&c);
	while ((len = fread(data, 1, sizeof(data), fp)) > 0)
		SHA224Update(&c, data, len);
	fclose(fp);
	CC_SHA224_Final(digest, &c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

#endif /* !_SHA224_H_ */
