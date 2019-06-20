Return-Path: <SRS0=z6fh=UT=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83314C43613
	for <tpmdd-devel@archiver.kernel.org>; Thu, 20 Jun 2019 21:53:38 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A1F62075E
	for <tpmdd-devel@archiver.kernel.org>; Thu, 20 Jun 2019 21:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="E+mbEVer";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="MdMg52l1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A1F62075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-4.v29.lw.sourceforge.com)
	by sfs-ml-4.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1he4zr-00054O-AH; Thu, 20 Jun 2019 21:53:31 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-4.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <jarkko.sakkinen@linux.intel.com>) id 1he4zp-00054G-Ar
 for tpmdd-devel@lists.sourceforge.net; Thu, 20 Jun 2019 21:53:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=DIVQ9Od84/69u7+Fi1m32xNlSy31bghEjc946QIRQ28=; b=E+mbEVerh1hgc2Lh8BnK4uXzzu
 tuXLGVDOzn5fvjC0MgHMmUDPEyRFWzYldUcN46xCDtaGqp+COykokUxpa6yPmxfKetFpxR//4IxDn
 p4IqRxizk+sMfsOECbqm+E8/EgCEIzeEVf7lm+WRmpzgEYTBjedc31yZ8lxLisB/2HWQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=DIVQ9Od84/69u7+Fi1m32xNlSy31bghEjc946QIRQ28=; b=MdMg52l1iLasLVQX+6TI9CNhDL
 f/uhcGBvLEkss0s7Qne4PY5SqSOcxKiTmFs0Jpul2tA4wE1wtEQnyZf0Fvwq6q335q7gXm7rSSQ9P
 QWBj0uHEuD8WBWTV8A+IOHAo0fqdPN7I+eIEkJNHAh1YLPismu8Py/2puqzi69nezlHQ=;
Received: from mga06.intel.com ([134.134.136.31])
 by sfi-mx-4.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 id 1he4zn-006bCM-Pz
 for tpmdd-devel@lists.sourceforge.net; Thu, 20 Jun 2019 21:53:31 +0000
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 20 Jun 2019 14:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; d="scan'208";a="162491010"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost)
 ([10.252.61.12])
 by fmsmga007.fm.intel.com with ESMTP; 20 Jun 2019 14:37:48 -0700
Date: Fri, 21 Jun 2019 00:37:46 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Matthew Garrett <mjg59@google.com>
Message-ID: <20190620213722.GA17841@linux.intel.com>
References: <20190615040210.GA9112@hari-Inspiron-1545>
 <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
 <CACdnJuudmE-MNuO7z87Mm65VaXbRzhOrBEpU5F=yC67uSLytGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACdnJuudmE-MNuO7z87Mm65VaXbRzhOrBEpU5F=yC67uSLytGQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Headers-End: 1he4zn-006bCM-Pz
Subject: Re: [tpmdd-devel] [PATCH] drivers: firmware: efi: fix gcc warning
 -Wint-conversion
X-BeenThere: tpmdd-devel@lists.sourceforge.net
X-Mailman-Version: 2.1.21
Precedence: list
List-Id: Tpm Device Driver maintainance <tpmdd-devel.lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel@lists.sourceforge.net>
List-Help: <mailto:tpmdd-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request@lists.sourceforge.net?subject=subscribe>
Cc: linux-efi <linux-efi@vger.kernel.org>,
 Hariprasad Kelam <hariprasad.kelam@gmail.com>,
 tpmdd-devel@lists.sourceforge.net,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

T24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMDM6NDg6MjNQTSAtMDcwMCwgTWF0dGhldyBHYXJyZXR0
IHdyb3RlOgo+IE9uIFdlZCwgSnVuIDE5LCAyMDE5IGF0IDI6NTUgQU0gQXJkIEJpZXNoZXV2ZWwK
PiA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4gd3JvdGU6Cj4gPgo+ID4gKCsgSmFya2tvLCB0
cG1kZCwgTWF0dGhldykKPiA+Cj4gPiBPbiBTYXQsIDE1IEp1biAyMDE5IGF0IDA2OjAyLCBIYXJp
cHJhc2FkIEtlbGFtCj4gPiA8aGFyaXByYXNhZC5rZWxhbUBnbWFpbC5jb20+IHdyb3RlOgo+ID4g
Pgo+ID4gPiBUaGlzIHBhdGNoIGZpeGVzIGJlbG93IHdhcm5pbmcKPiA+ID4KPiA+ID4gZHJpdmVy
cy9maXJtd2FyZS9lZmkvdHBtLmM6Nzg6Mzg6IHdhcm5pbmc6IHBhc3NpbmcgYXJndW1lbnQgMSBv
Zgo+ID4gPiDigJh0cG0yX2NhbGNfZXZlbnRfbG9nX3NpemXigJkgbWFrZXMgcG9pbnRlciBmcm9t
IGludGVnZXIgd2l0aG91dCBhIGNhc3QKPiA+ID4gWy1XaW50LWNvbnZlcnNpb25dCj4gPiA+Cj4g
PiA+IFNpZ25lZC1vZmYtYnk6IEhhcmlwcmFzYWQgS2VsYW0gPGhhcmlwcmFzYWQua2VsYW1AZ21h
aWwuY29tPgo+ID4KPiA+IEkgdGhpbmsgd2UgYWxyZWFkeSBoYXZlIGEgZml4IHF1ZXVlZCBmb3Ig
dGhpcywgbm8/Cj4gCj4gSXQgbG9va3MgbGlrZSBJIGZpeGVkIHRoaXMgaW4gIkRvbid0IGR1cGxp
Y2F0ZSBldmVudHMgZnJvbSB0aGUgZmluYWwKPiBldmVudCBsb2cgaW4gdGhlIFRDRzIgbG9nIiBy
YXRoZXIgdGhhbiBhIHNlcGFyYXRlIHBhdGNoIC0gSSdtIGZpbmUKPiBtZXJnaW5nIHRoaXMsIGJh
c2VkIG9uIEphcmtrbydzIHByZWZlcmVuY2VzLgoKUmlnaHQhIE9LLCBJIHNxdWFzaGVkIGp1c3Qg
dGhlIGZpeCB0byB0aGUgZWFybGllciBwYXRjaC4gTWFzdGVyIGFuZApuZXh0IGFyZSB1cGRhdGVk
LiBDYW4geW91IHRha2UgYSBwZWVrIG9mIFsxXSBhbmQgc2VlIGlmIGl0IGxvb2tzCmxlZ2l0IGdp
dmVuIGFsbCB0aGUgZnV6eiBhcm91bmQgdGhlc2UgY2hhbmdlcz8gVGhlbiBJJ20gY29uZmlkZW50
CmVub3VnaCB0byBkbyB0aGUgNS4zIFBSLgoKWzFdIGdpdDovL2dpdC5pbmZyYWRlYWQub3JnL3Vz
ZXJzL2pqcy9saW51eC10cG1kZC5naXQKCi9KYXJra28KCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp0cG1kZC1kZXZlbCBtYWlsaW5nIGxpc3QKdHBtZGQt
ZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8vbGlzdHMuc291cmNlZm9yZ2UubmV0
L2xpc3RzL2xpc3RpbmZvL3RwbWRkLWRldmVsCg==
