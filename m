From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: ibmvtpm byteswapping inconsistency
Date: Mon, 30 Jan 2017 14:42:25 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DB0273BCA@AcuExch.aculab.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
 <d55b06cc-cb7a-1ef1-05b7-d7d4114d0c48@linux.vnet.ibm.com>
 <1485481819.2980.82.camel@kernel.crashing.org>
 <e518682f-e563-9533-9ffd-f465c662e998@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e518682f-e563-9533-9ffd-f465c662e998@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Tyrel Datwyler' <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, =?utf-8?B?TWljaGFsIFN1Y2jDoW5law==?= <msuchanek@suse.de>, Ashley Lai <ashleydlai@gmail.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

RnJvbTogVHlyZWwgRGF0d3lsZXINCj4gU2VudDogMjcgSmFudWFyeSAyMDE3IDE4OjAzDQo+IE9u
IDAxLzI2LzIwMTcgMDU6NTAgUE0sIEJlbmphbWluIEhlcnJlbnNjaG1pZHQgd3JvdGU6DQo+ID4g
T24gVGh1LCAyMDE3LTAxLTI2IGF0IDE3OjQyIC0wODAwLCBUeXJlbCBEYXR3eWxlciB3cm90ZToN
Cj4gPj4gT24gMDEvMjYvMjAxNyAxMjoyMiBQTSwgTWljaGFsIFN1Y2huZWsgd3JvdGU6DQo+ID4+
PiBIZWxsbywNCj4gPj4+DQo+ID4+PiBidWlsZGluZyBpYm12dHBtIEkgbm90aWNlZCBnY2Mgd2Fy
bmluZyBjb21wbGFpbmluZyB0aGF0IHNlY29uZCB3b3JkDQo+ID4+PiBvZg0KPiA+Pj4gc3RydWN0
IGlibXZ0cG1fY3JxIGluIHRwbV9pYm12dHBtX3N1c3BlbmQgaXMgdW5pbml0aWFsaXplZC4NCj4g
Pj4+DQo+ID4+PiBUaGUgc3RydWN0dXJlIGlzIGRlZmluZWQgYXMNCj4gPj4+DQo+ID4+PiBzdHJ1
Y3QgaWJtdnRwbV9jcnEgew0KPiA+Pj4gICAgICAgICB1OCB2YWxpZDsNCj4gPj4+ICAgICAgICAg
dTggbXNnOw0KPiA+Pj4gICAgICAgICBfX2JlMTYgbGVuOw0KPiA+Pj4gICAgICAgICBfX2JlMzIg
ZGF0YTsNCj4gPj4+ICAgICAgICAgX19iZTY0IHJlc2VydmVkOw0KPiA+Pj4gfSBfX2F0dHJpYnV0
ZV9fKChwYWNrZWQsIGFsaWduZWQoOCkpKTsNCj4gPj4+DQo+ID4+PiBpbml0aWFsaXplZCBhcw0K
PiA+Pj4NCj4gPj4+ICAgICAgICAgc3RydWN0IGlibXZ0cG1fY3JxIGNycTsNCj4gPj4+ICAgICAg
ICAgdTY0ICpidWYgPSAodTY0ICopICZjcnE7DQo+ID4+PiAuLi4NCj4gPj4+ICAgICAgICAgY3Jx
LnZhbGlkID0gKHU4KUlCTVZUUE1fVkFMSURfQ01EOw0KPiA+Pj4gICAgICAgICBjcnEubXNnID0g
KHU4KVZUUE1fUFJFUEFSRV9UT19TVVNQRU5EOw0KPiA+Pj4NCj4gPj4+IGFuZCBzdWJtaXR0ZWQg
d2l0aA0KPiA+Pj4NCj4gPj4+ICAgICAgICAgcmMgPSBpYm12dHBtX3NlbmRfY3JxKGlibXZ0cG0t
PnZkZXYsIGNwdV90b19iZTY0KGJ1ZlswXSksDQo+ID4+PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBjcHVfdG9fYmU2NChidWZbMV0pKTsNCg0KSXNuJ3QgdGhlIHJlYWwgZnViYXIgaGVy
ZSB0aGUgdXNlIG9mIHRoYXQgbWVtb3J5IGxheW91dCBzdHJ1Y3R1cmUgYXQgYWxsPw0KSXQgd291
bGQgcHJvYmFibHkgYWxsIGJlIGJldHRlciBpZiB0aGUgY2FsbCBsb29rZWQgbGlrZToNCglyYyA9
IGlibXZ0cG1fc2VuZF9jcnEoaWJtdnRwbS0+dmRldiwgTUFLRV9SRVEoSUJNVlRQTV9WQUxJRF9D
TUQsDQoJCVZUUE1fUFJFUEFSRV9UT19TVVNQRU5ELCB4eHhfbGVuLCB4eHhfZGF0YSksIDApOw0K
YW5kIE1BS0VfUkVRKCkgZGlkIGFsbCB0aGUgcmVxdWlyZWQgZW5kaWFuIGluZGVwZW5kYW50IHNo
aWZ0cyB0byBnZW5lcmF0ZQ0KdGhlIGNvcnJlY3QgMzJiaXQgdmFsdWUuDQoNCglEYXZpZA0KDQo=
