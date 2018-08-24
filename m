From: Mimi Zohar <zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH 01/23] TPM: Add new TPMs to the tail of
 the list to prevent inadvertent change of dev
Date: Fri, 24 Aug 2018 07:22:39 -0400
Message-ID: <1535109759.19550.355.camel@linux.ibm.com>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
 <153486701644.13066.13372706238885253812.stgit@warthog.procyon.org.uk>
 <20180821183004.GB25543@ziepe.ca> <20180824062434.GB3584@linux.intel.com>
 <20180824062557.GC3584@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20180824062557.GC3584-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

T24gRnJpLCAyMDE4LTA4LTI0IGF0IDA5OjI1ICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
Cj4gT24gRnJpLCBBdWcgMjQsIDIwMTggYXQgMDk6MjQ6MzRBTSArMDMwMCwgSmFya2tvIFNha2tp
bmVuIHdyb3RlOgo+ID4gT24gVHVlLCBBdWcgMjEsIDIwMTggYXQgMTI6MzA6MDRQTSAtMDYwMCwg
SmFzb24gR3VudGhvcnBlIHdyb3RlOgo+ID4gPiBPbiBUdWUsIEF1ZyAyMSwgMjAxOCBhdCAwNDo1
Njo1NlBNICswMTAwLCBEYXZpZCBIb3dlbGxzIHdyb3RlOgo+ID4gPiA+IEFkZCBuZXdseSByZWdp
c3RlcmVkIFRQTXMgdG8gdGhlIHRhaWwgb2YgdGhlIGxpc3QsIG5vdCB0aGUgYmVnaW5uaW5nLCBz
byB0aGF0Cj4gPiA+ID4gdGhpbmdzIHRoYXQgYXJlIHNwZWNpZnlpbmcgVFBNX0FOWV9OVU0gZG9u
J3QgZmluZCB0aGF0IHRoZSBkZXZpY2UgdGhleSdyZQo+ID4gPiA+IHVzaW5nIGhhcyBpbmFkdmVy
dGVudGx5IGNoYW5nZWQuICBBZGRpbmcgYSBzZWNvbmQgZGV2aWNlIHdvdWxkIGJyZWFrIElNQSwg
Zm9yCj4gPiA+ID4gaW5zdGFuY2UuCj4gPiA+ID4gCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogRGF2
aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KPiA+ID4gPiBSZXZpZXdlZC1ieTogSmFz
b24gR3VudGhvcnBlIDxqZ3VudGhvcnBlQG9ic2lkaWFucmVzZWFyY2guY29tPgo+ID4gPiA+IFNp
Z25lZC1vZmYtYnk6IFBldGVyIEh1ZXdlIDxwZXRlcmh1ZXdlQGdteC5kZT4KPiA+ID4gPiBjYzog
c3RhYmxlQHZnZXIua2VybmVsLm9yZwo+ID4gPiA+IC0tLQo+ID4gPiAKPiA+ID4gV2UgcmVhbGx5
IHNob3VsZCBhcHBseSB0aGlzIHBhdGNoLi4uCj4gPiA+IAo+ID4gPiBKYXNvbgo+ID4gCj4gPiBU
aGlzIGlzIHRoZSBmaXJzdCB0aW1lIEkgcmVtZW1iZXIgc2VlaW5nIGl0Lgo+IAo+IEF0IGxlYXN0
IGluIHRoZSBzZW5zZSB0aGF0IEkgc2hvdWxkIHJldmlldyBpdC4KCkkgcmVtZW1iZXIgdGhpcyBw
YXRjaCwgYmVjYXVzZSBpdCBhZmZlY3RlZCBJTUEuIMKgSXQgaGFzIGFscmVhZHkgYmVlbgp1cHN0
cmVhbWVkIGFzIDM5OGExZTcxZGM4Mi4KCk1pbWkKCgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KQ2hl
Y2sgb3V0IHRoZSB2aWJyYW50IHRlY2ggY29tbXVuaXR5IG9uIG9uZSBvZiB0aGUgd29ybGQncyBt
b3N0CmVuZ2FnaW5nIHRlY2ggc2l0ZXMsIFNsYXNoZG90Lm9yZyEgaHR0cDovL3NkbS5saW5rL3Ns
YXNoZG90Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnRw
bWRkLWRldmVsIG1haWxpbmcgbGlzdAp0cG1kZC1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQK
aHR0cHM6Ly9saXN0cy5zb3VyY2Vmb3JnZS5uZXQvbGlzdHMvbGlzdGluZm8vdHBtZGQtZGV2ZWwK
