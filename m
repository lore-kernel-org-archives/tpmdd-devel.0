From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1] tpm/st33zp24: Switch to
 devm_acpi_dev_add_driver_gpios()
Date: Mon, 19 Jun 2017 02:34:46 +0200
Message-ID: <1497832486.14670.0.camel@linux.intel.com>
References: <20170612154416.82847-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170612154416.82847-1-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

T24gTW9uLCAyMDE3LTA2LTEyIGF0IDE4OjQ0ICswMzAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
Cj4gU3dpdGNoIHRvIHVzZSBtYW5hZ2VkIHZhcmlhbnQgb2YgYWNwaV9kZXZfYWRkX2RyaXZlcl9n
cGlvcygpIHRvCnNpbXBsaWZ5Cj4gZXJyb3IgcGF0aCBhbmQgZml4IHBvdGVudGlhbGx5IHdyb25n
IGFzc2lnbm1lbnQgaWYgLT5wcm9iZSgpIGZhaWxzLgo+wqAKPiBTaWduZWQtb2ZmLWJ5OiBBbmR5
IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4KClJldmlld2Vk
LWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrby5zYWtraW5lQGxpbnV4LmludGVsLmNvbT4KVGVz
dGVkLWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrby5zYWtraW5lQGxpbnV4LmludGVsLmNvbT4K
KGNvbXBpbGF0aW9uKQoKL0phcmtrbwoKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkNoZWNrIG91dCB0
aGUgdmlicmFudCB0ZWNoIGNvbW11bml0eSBvbiBvbmUgb2YgdGhlIHdvcmxkJ3MgbW9zdAplbmdh
Z2luZyB0ZWNoIHNpdGVzLCBTbGFzaGRvdC5vcmchIGh0dHA6Ly9zZG0ubGluay9zbGFzaGRvdApf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp0cG1kZC1kZXZl
bCBtYWlsaW5nIGxpc3QKdHBtZGQtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8v
bGlzdHMuc291cmNlZm9yZ2UubmV0L2xpc3RzL2xpc3RpbmZvL3RwbWRkLWRldmVsCg==
