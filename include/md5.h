/*-
 * Public Domain dedication for darwintools.
 *
 * <md5.h> shim: Apple removed this header from recent SDKs, but the
 * legacy MD5_* API is still available through CommonCrypto.  Map the
 * classic names onto their CC_* counterparts and provide the libmd
 * End()/Data()/File() helpers.
 */

#ifndef _MD5_H_
#define _MD5_H_

#include <sys/types.h>
#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>

typedef CC_MD5_CTX		MD5_CTX;

#define MD5Update		CC_MD5_Update

static inline void
MD5Init(MD5_CTX *c)
{
	CC_MD5_Init(c);
}

static inline char *
MD5End(MD5_CTX *c, char *buf)
{
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	static const char hex[] = "0123456789abcdef";
	int i;

	if (buf == NULL)
		return NULL;
	CC_MD5_Final(digest, c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

static inline char *
MD5Data(const void *data, u_int len, char *buf)
{
	MD5_CTX c;

	MD5Init(&c);
	MD5Update(&c, data, len);
	return MD5End(&c, buf);
}

static inline char *
MD5File(const char *filename, char *buf)
{
	MD5_CTX c;
	unsigned char digest[CC_MD5_DIGEST_LENGTH], data[65536];
	static const char hex[] = "0123456789abcdef";
	FILE *fp;
	size_t len;
	int i;

	if (buf == NULL || (fp = fopen(filename, "r")) == NULL)
		return NULL;
	MD5Init(&c);
	while ((len = fread(data, 1, sizeof(data), fp)) > 0)
		MD5Update(&c, data, len);
	fclose(fp);
	CC_MD5_Final(digest, &c);
	for (i = 0; i < (int)sizeof(digest); i++) {
		buf[i + i] = hex[digest[i] >> 4];
		buf[i + i + 1] = hex[digest[i] & 0x0f];
	}
	buf[i + i] = '\0';
	return buf;
}

#endif /* !_MD5_H_ */
