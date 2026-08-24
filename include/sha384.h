/*-
 * Public Domain dedication for darwintools.
 *
 * <sha384.h> shim mapping the legacy libmd SHA384_* API onto
 * CommonCrypto, mirroring include/sha.h.
 */

#ifndef _SHA384_H_
#define _SHA384_H_

#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>

typedef CC_SHA512_CTX		SHA384_CTX;

#define SHA384Update		CC_SHA384_Update
#define SHA384_Init		CC_SHA384_Init
#define SHA384_Update		CC_SHA384_Update

static inline void
SHA384Init(SHA384_CTX *c)
{
	CC_SHA384_Init(c);
}

static inline char *
SHA384_End(SHA384_CTX *c, char *buf)
{
	unsigned char digest[CC_SHA384_DIGEST_LENGTH];
	static const char hex[] = "0123456789abcdef";
	int i;

	if (buf == NULL)
		return NULL;
	CC_SHA384_Final(digest, c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

static inline char *
SHA384_Data(const void *data, u_int len, char *buf)
{
	SHA384_CTX c;

	SHA384Init(&c);
	SHA384Update(&c, data, len);
	return SHA384_End(&c, buf);
}

static inline char *
SHA384_File(const char *filename, char *buf)
{
	SHA384_CTX c;
	unsigned char digest[CC_SHA384_DIGEST_LENGTH], data[65536];
	static const char hex[] = "0123456789abcdef";
	FILE *fp;
	size_t len;
	int i;

	if (buf == NULL || (fp = fopen(filename, "r")) == NULL)
		return NULL;
	SHA384Init(&c);
	while ((len = fread(data, 1, sizeof(data), fp)) > 0)
		SHA384Update(&c, data, len);
	fclose(fp);
	CC_SHA384_Final(digest, &c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

#endif /* !_SHA384_H_ */
