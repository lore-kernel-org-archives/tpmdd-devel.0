From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC 0/1] TPM2 engine support for openssl
Date: Wed, 21 Dec 2016 20:55:26 -0800
Message-ID: <1482382526.2350.57.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: tpmdd-devel@lists.sourceforge.net, trousers-tech@lists.sourceforge.net, ibmtpm20tss-users@lists.sourceforge.net, openssl-dev@openssl.org
List-Id: tpmdd-devel@lists.sourceforge.net

This is a basic RFC to show that it's possible to get TPM2 to act as an
engine for openssl as well as TPM1.2.  The format follows as closely as
possible what happens in TPM1.2.  The file format is full blown ASN.1
because we have to include both a public and private key blob.  I chose
to use TSS2 KEY BLOB as the guards to distinguish it from the TPM1.2
file.

TPM2 has significant limitations over TPM1.2 in what it will sign:
basically it must recognise the signature algorithm (that's why all the
signature parsing in the rsa_priv_enc() routine).  There's also another
problem in that a primary asymmetric key of the SPS must be provisioned
every time we perform this operation (which is time consuming and
annoying).  I think we need to do something about this under Linux, but
I'll take that off the openssl list because they likely won't be
interested.

The authority handling is missing at the moment, but I'll add that
shortly.  We should probably discuss how policy based authorisation
should be handled: I think as extensions to the key ASN.1 file.

Because of the signature recognition problem, you have to test this out
with x509 certificates:

openssl genrsa 2048 > tmp.key
create_tpm2_key -w tmp.key tmp.bin
openssl req -new -engine tpm2 -key tmp.bin -keyform e > tmp.csr
openssl x509 -req -engine tpm2 -in tmp.csr -signkey tmp.bin -keyform e -out tmp.crt
openssl x509 -text -in tmp.crt
 
The last step will validate you've got a genuine x509 self signed
certificate with the key from the TPM.

This kit is constructed using the IBM TSS2:

https://sourceforge.net/projects/ibmtpm20tss/

And, at the moment, it's only been validated on a software TPM2.

James

---

James Bottomley (1):
  add TPM2 version of create_tpm2_key and libtpm2.so engine

 Makefile.am       |  12 +-
 create_tpm2_key.c | 381 ++++++++++++++++++++++++++++++++++++++++++
 e_tpm2.c          | 482 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tpm2-asn.h        |  35 ++++
 tpm2-common.c     | 172 +++++++++++++++++++
 tpm2-common.h     |  10 ++
 6 files changed, 1090 insertions(+), 2 deletions(-)
 create mode 100644 create_tpm2_key.c
 create mode 100644 e_tpm2.c
 create mode 100644 tpm2-asn.h
 create mode 100644 tpm2-common.c
 create mode 100644 tpm2-common.h

-- 
2.6.6


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
