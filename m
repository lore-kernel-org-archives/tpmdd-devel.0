From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Future of TPMDD @ Linux Security Summit / Plumbers
Date: Wed, 13 Sep 2017 22:48:43 +0200
Message-ID: <trinity-ab47fab5-3247-446f-add3-baebe7c51350-1505335723429@3c-app-gmx-bs26>
References: <1503697721.4203.151.camel@linux.vnet.ibm.com>
 <20170825220252.uuy43ryhuavoz2jq@linux.intel.com>
 <20170825220416.h2j2sns72kukf466@linux.intel.com>
 <1503699356.4203.159.camel@linux.vnet.ibm.com>
 <20170825222209.GA22199@obsidianresearch.com>
 <1503703596.8359.6.camel@linux.vnet.ibm.com>
 <20170826074135.mx3i3bo6b3lrevdu@linux.intel.com>
 <20170826074843.isaxpmrotyk46u6j@linux.intel.com>
 <1503847647.5847.51.camel@linux.vnet.ibm.com>
 <alpine.LRH.2.20.1708281126230.3474@namei.org>
 <20170829121137.ovgkrcihgy5jcufu@linux.intel.com>
 <alpine.LRH.2.20.1708300003510.19193@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <alpine.LRH.2.20.1708300003510.19193-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, George Wilson <gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

SGkgSmFya2tvLCBNaW1pLCBKYW1lcywgSmFzb24sIGFuZCBldmVyeWJvZHkgZWxzZSwKwqAKaXQg
d291bGQgYmUgZ3JlYXQgaWYgd2UgY291bGQgZmluZCBhIHNsb3QgdG8gZGlzY3VzcyBpbiBwZXJz
b24gaG93IHdlIHByb2NlZWQgd2l0aCB0aGUgbWFpbGluZyBsaXN0cywgcGF0Y2ggZmxvd3MgYW5k
IHJldmlldyBjeWNsZXMuCkkga25vdyB0aGVyZSB3ZXJlIHNvbWUgZGlzY3Vzc2lvbnMsIGJ1dCBh
dGxlYXN0IGZvciBteSBwYXJ0IEkgZGlkIG5vdCBnZXQgdGhlIGZpbmFsIGNvbmNsdXNpb24gb24g
aG93IHdlIHByb2NlZWQgYW5kIHdoeS4KwqAKQWxzbyBJIHdvdWxkIGxpa2UgdG8gZGlzY3VzcyB3
aGF0IGlzIHRoZSBjdXJyZW50IHN0YXR1cyBvZiB0aGUgbW92ZSB0byBrZXJuZWwub3JnIGluZnJh
c3RydWN0dXJlIChvciBhdGxlYXN0IGF3YXkgZnJvbSBzZiksIGFuZCBtYXliZSB3ZSBjYW4gZmlu
ZCBhbnlvbmUgaGVyZSBhdCBQbHVtYmVycyB0byByZW1vdmUgYW55IGJsb2NraW5nIHBvaW50cy4K
Ck1heWJlIHdlIGNvdWxkIGFsc28gZGlzY3VzcyBob3cgd2UgY2FuIGltcHJvdmUgb3VyIHRlc3Rp
bmcgc3RyYXRlZ3kgYW5kIGRpc2N1c3Mgd2hpY2ggdGVzdHMgY3VycmVudGx5IGV4aXN0cy4KV2Ug
aGF2ZSBhIChzZW1pLSlhdXRvbWF0aWMgdGVzdCBlbnZpcm9ubWVudCBmb3IgdGhlIHRwbSBrZXJu
ZWwgcGF0Y2hlcyBhdCB3b3JrIGFuZCB3ZSBhcmUgY3VycmVudGx5IGV4cGxvcmluZyBob3cgdG8g
ZXhwYW5kIHRoaXMgZnVydGhlciBhbmQgYXV0b21hdGUgaXQgY29tcGxldGVseS4gSSBjYW4gZ2l2
ZSB5b3UgYSBxdWljayBydW5kb3duIG9uIHRoaXMgaWYgaW50ZXJlc3RlZC4KCgpUaGFua3MsClBl
dGVyCgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KQ2hlY2sgb3V0IHRoZSB2aWJyYW50IHRlY2ggY29t
bXVuaXR5IG9uIG9uZSBvZiB0aGUgd29ybGQncyBtb3N0CmVuZ2FnaW5nIHRlY2ggc2l0ZXMsIFNs
YXNoZG90Lm9yZyEgaHR0cDovL3NkbS5saW5rL3NsYXNoZG90Cl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnRwbWRkLWRldmVsIG1haWxpbmcgbGlzdAp0cG1k
ZC1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQKaHR0cHM6Ly9saXN0cy5zb3VyY2Vmb3JnZS5u
ZXQvbGlzdHMvbGlzdGluZm8vdHBtZGQtZGV2ZWwK
