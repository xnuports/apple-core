/*-
 * Public Domain dedication for darwintools.
 *
 * <sha256.h> shim mapping the legacy libmd SHA256_* API onto
 * CommonCrypto, mirroring include/sha.h.
 */

#ifndef _SHA256_H_
#define _SHA256_H_

#include <sys/types.h>
#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>

typedef CC_SHA256_CTX		SHA256_CTX;

#define SHA256Update		CC_SHA256_Update
#define SHA256_Init		CC_SHA256_Init
#define SHA256_Update		CC_SHA256_Update

static inline void
SHA256Init(SHA256_CTX *c)
{
	CC_SHA256_Init(c);
}

static inline char *
SHA256_End(SHA256_CTX *c, char *buf)
{
	unsigned char digest[CC_SHA256_DIGEST_LENGTH];
	static const char hex[] = "0123456789abcdef";
	int i;

	if (buf == NULL)
		return NULL;
	CC_SHA256_Final(digest, c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

static inline char *
SHA256_Data(const void *data, u_int len, char *buf)
{
	SHA256_CTX c;

	SHA256Init(&c);
	SHA256Update(&c, data, len);
	return SHA256_End(&c, buf);
}

static inline char *
SHA256_File(const char *filename, char *buf)
{
	SHA256_CTX c;
	unsigned char digest[CC_SHA256_DIGEST_LENGTH], data[65536];
	static const char hex[] = "0123456789abcdef";
	FILE *fp;
	size_t len;
	int i;

	if (buf == NULL || (fp = fopen(filename, "r")) == NULL)
		return NULL;
	SHA256Init(&c);
	while ((len = fread(data, 1, sizeof(data), fp)) > 0)
		SHA256Update(&c, data, len);
	fclose(fp);
	CC_SHA256_Final(digest, &c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

#endif /* !_SHA256_H_ */
