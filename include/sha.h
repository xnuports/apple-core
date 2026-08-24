/*-
 * Public Domain dedication for darwintools.
 *
 * <sha.h> shim: Apple removed this header from recent SDKs, but the
 * legacy SHA1_* API is still available through CommonCrypto.  Map the
 * classic names onto their CC_* counterparts and provide the libmd
 * End()/Data()/File() helpers.
 */

#ifndef _SHA_H_
#define _SHA_H_

#include <sys/types.h>
#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>

typedef CC_SHA1_CTX		SHA1_CTX;

#define SHA1_Update		CC_SHA1_Update
#define SHA1Update		CC_SHA1_Update
#define SHA1_Init		CC_SHA1_Init

static inline void
SHA1Init(SHA1_CTX *c)
{
	CC_SHA1_Init(c);
}

static inline char *
SHA1_End(SHA1_CTX *c, char *buf)
{
	unsigned char digest[CC_SHA1_DIGEST_LENGTH];
	static const char hex[] = "0123456789abcdef";
	int i;

	if (buf == NULL)
		return NULL;
	CC_SHA1_Final(digest, c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

static inline char *
SHA1_Data(const void *data, u_int len, char *buf)
{
	SHA1_CTX c;

	SHA1Init(&c);
	SHA1Update(&c, data, len);
	return SHA1_End(&c, buf);
}

static inline char *
SHA1_File(const char *filename, char *buf)
{
	SHA1_CTX c;
	unsigned char digest[CC_SHA1_DIGEST_LENGTH], data[65536];
	static const char hex[] = "0123456789abcdef";
	FILE *fp;
	size_t len;
	int i;

	if (buf == NULL || (fp = fopen(filename, "r")) == NULL)
		return NULL;
	SHA1Init(&c);
	while ((len = fread(data, 1, sizeof(data), fp)) > 0)
		SHA1Update(&c, data, len);
	fclose(fp);
	CC_SHA1_Final(digest, &c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

#endif /* !_SHA_H_ */
