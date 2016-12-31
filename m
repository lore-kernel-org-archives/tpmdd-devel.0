From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/1] TPM2 engine support for openssl
Date: Sat, 31 Dec 2016 14:48:05 -0800
Message-ID: <1483224485.2518.20.camel@HansenPartnership.com>
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

This is a completed version of the original RFC.  It's working now both
on the TPM2 simulator and on real hardware (I've converted my laptop to
TPM2).  I've updated it to use the latest version of the ASN.1 for the
key format (still using a TCG OID).

I have it building here (it's what I'm currently using for my laptop
VPNs):

https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/openssl_tpm_engine

But note that this version also has experimental patches to activate
the in-kernel TPM Resource Manager because for multiple applications
TPM2 really doesn't work well without one.  Since the patch for the RM
is currently not upstream (yet), it's not going to work unless you have
a patched kernel.

James

---

James Bottomley (1):
  add TPM2 version of create_tpm2_key and libtpm2.so engine

 Makefile.am       |  12 +-
 create_tpm2_key.c | 451 +++++++++++++++++++++++++++++++++++++++++++
 e_tpm2.c          | 559 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tpm2-asn.h        |  59 ++++++
 tpm2-common.c     | 175 +++++++++++++++++
 tpm2-common.h     |  10 +
 6 files changed, 1264 insertions(+), 2 deletions(-)
 create mode 100644 create_tpm2_key.c
 create mode 100644 e_tpm2.c
 create mode 100644 tpm2-asn.h
 create mode 100644 tpm2-common.c
 create mode 100644 tpm2-common.h

-- 
2.6.6


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
