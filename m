From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: in-kernel user of ecdsa
Date: Mon, 12 Mar 2018 11:09:18 -0700
Message-ID: <1520878158.4522.31.camel@linux.vnet.ibm.com>
References: <0f698592-8ade-14d4-7891-1c35501c6285@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <0f698592-8ade-14d4-7891-1c35501c6285-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: "bluez mailin list (linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Crypto Mailing List <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

T24gTW9uLCAyMDE4LTAzLTEyIGF0IDE5OjA3ICswMjAwLCBUdWRvciBBbWJhcnVzIHdyb3RlOgo+
IEhpLAo+IAo+IFdvdWxkIHlvdSBjb25zaWRlciB1c2luZyBFQ0RTQSBpbiB0aGUga2VybmVsIG1v
ZHVsZSBzaWduaW5nIGZhY2lsaXR5Pwo+IFdoZW4gY29tcGFyZWQgd2l0aCBSU0EsIEVDRFNBIGhh
cyBzaG9ydGVyIGtleXMsIHRoZSBrZXkgZ2VuZXJhdGlvbgo+IHByb2Nlc3MgaXMgZmFzdGVyLCB0
aGUgc2lnbiBvcGVyYXRpb24gaXMgZmFzdGVyLCBidXQgdGhlIHZlcmlmeQo+IG9wZXJhdGlvbiBp
cyBzbG93ZXIgdGhhbiB3aXRoIFJTQS4KCllvdSBtaXNzZWQgdGhlIGtleXJpbmdzIGxpc3QsIHdo
aWNoIGlzIHdoZXJlIHRoZSBtb2R1bGUgc2lnbmluZyB1dGlsaXR5CmlzIGRpc2N1c3NlZC4KCkZp
cnN0IHF1ZXN0aW9uIGlzLCBoYXZlIHlvdSBhY3R1YWxseSB0cmllZD8gwqBJdCBsb29rcyBsaWtl
IHNpZ24tZmlsZQpkb2Vzbid0IGRvIGFueXRoaW5nIFJTQSBzcGVjaWZpYyBzbyBpZiB5b3UgZ2l2
ZSBpdCBhbiBFQyBYLjUwOQpjZXJ0aWZpY2F0ZSBpdCB3aWxsIHByb2R1Y2UgYW4gRUNEU0Egc2ln
bmF0dXJlLgoKSSB0aGluayBvdXIga2VybmVsIGludGVybmFsIHg1MDkgcGFyc2VycyBkb24ndCBo
YXZlIHRoZSBFQyBPSURzLCBzbwpzaWduYXR1cmUgdmVyaWZpY2F0aW9uIHdpbGwgZmFpbDsgYnV0
LCBlc3BlY2lhbGx5IHNpbmNlIHdlIGhhdmUgdGhlCnJlc3Qgb2YgdGhlIEVDIG1hY2hpbmVyeSBp
biB0aGUgY3J5cHRvIHN1YnN5c3RlbSwgdGhhdCBsb29rcyB0byBiZQpzaW1wbHkgZml4YWJsZS4K
CkphbWVzCgoKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkNoZWNrIG91dCB0aGUgdmlicmFudCB0ZWNo
IGNvbW11bml0eSBvbiBvbmUgb2YgdGhlIHdvcmxkJ3MgbW9zdAplbmdhZ2luZyB0ZWNoIHNpdGVz
LCBTbGFzaGRvdC5vcmchIGh0dHA6Ly9zZG0ubGluay9zbGFzaGRvdApfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp0cG1kZC1kZXZlbCBtYWlsaW5nIGxpc3QK
dHBtZGQtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8vbGlzdHMuc291cmNlZm9y
Z2UubmV0L2xpc3RzL2xpc3RpbmZvL3RwbWRkLWRldmVsCg==
