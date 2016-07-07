From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] xen-tpmfront: correct return value check on
 xenbus_scanf()
Date: Thu, 07 Jul 2016 02:04:00 -0600
Message-ID: <577E291002000078000FBF18@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd@selhorst.net
Cc: Juergen Gross <JGross@suse.com>, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, david.vrabel@citrix.com
List-Id: tpmdd-devel@lists.sourceforge.net

T25seSBhIHBvc2l0aXZlIHJldHVybiB2YWx1ZSBpbmRpY2F0ZXMgc3VjY2Vzcy4KClNpZ25lZC1v
ZmYtYnk6IEphbiBCZXVsaWNoIDxqYmV1bGljaEBzdXNlLmNvbT4KLS0tCiBkcml2ZXJzL2NoYXIv
dHBtL3hlbi10cG1mcm9udC5jIHwgICAgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pCgotLS0gNC43LXJjNi14ZW5idXNfc2NhbmYub3JpZy9kcml2ZXJz
L2NoYXIvdHBtL3hlbi10cG1mcm9udC5jCisrKyA0LjctcmM2LXhlbmJ1c19zY2FuZi9kcml2ZXJz
L2NoYXIvdHBtL3hlbi10cG1mcm9udC5jCkBAIC0zNDQsNyArMzQ0LDcgQEAgc3RhdGljIHZvaWQg
YmFja2VuZF9jaGFuZ2VkKHN0cnVjdCB4ZW5idQogCQkJYnJlYWs7CiAKIAkJaWYgKHhlbmJ1c19z
Y2FuZihYQlRfTklMLCBkZXYtPm90aGVyZW5kLAotCQkJCSJmZWF0dXJlLXByb3RvY29sLXYyIiwg
IiVkIiwgJnZhbCkgPCAwKQorCQkJCSJmZWF0dXJlLXByb3RvY29sLXYyIiwgIiVkIiwgJnZhbCkg
PD0gMCkKIAkJCXZhbCA9IDA7CiAJCWlmICghdmFsKSB7CiAJCQl4ZW5idXNfZGV2X2ZhdGFsKGRl
diwgLUVJTlZBTCwKCgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0
cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
