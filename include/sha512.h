/*-
 * Public Domain dedication for darwintools.
 *
 * <sha512.h> shim mapping the legacy libmd SHA512_* API onto
 * CommonCrypto, mirroring include/sha.h.
 */

#ifndef _SHA512_H_
#define _SHA512_H_

#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>

typedef CC_SHA512_CTX		SHA512_CTX;

#define SHA512Update		CC_SHA512_Update
#define SHA512_Init		CC_SHA512_Init
#define SHA512_Update		CC_SHA512_Update

static inline void
SHA512Init(SHA512_CTX *c)
{
	CC_SHA512_Init(c);
}

static inline char *
SHA512_End(SHA512_CTX *c, char *buf)
{
	unsigned char digest[CC_SHA512_DIGEST_LENGTH];
	static const char hex[] = "0123456789abcdef";
	int i;

	if (buf == NULL)
		return NULL;
	CC_SHA512_Final(digest, c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

static inline char *
SHA512_Data(const void *data, u_int len, char *buf)
{
	SHA512_CTX c;

	SHA512Init(&c);
	SHA512Update(&c, data, len);
	return SHA512_End(&c, buf);
}

static inline char *
SHA512_File(const char *filename, char *buf)
{
	SHA512_CTX c;
	unsigned char digest[CC_SHA512_DIGEST_LENGTH], data[65536];
	static const char hex[] = "0123456789abcdef";
	FILE *fp;
	size_t len;
	int i;

	if (buf == NULL || (fp = fopen(filename, "r")) == NULL)
		return NULL;
	SHA512Init(&c);
	while ((len = fread(data, 1, sizeof(data), fp)) > 0)
		SHA512Update(&c, data, len);
	fclose(fp);
	CC_SHA512_Final(digest, &c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

#endif /* !_SHA512_H_ */
