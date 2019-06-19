Return-Path: <SRS0=syPD=US=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E49DC31E49
	for <tpmdd-devel@archiver.kernel.org>; Wed, 19 Jun 2019 10:18:50 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD6CE21479
	for <tpmdd-devel@archiver.kernel.org>; Wed, 19 Jun 2019 10:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="WJcp0XcG";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="Yj30Pfko";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iGE0xIN1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD6CE21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-1.v29.lw.sourceforge.com)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1hdXfx-00076L-Jo; Wed, 19 Jun 2019 10:18:45 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-1.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <ard.biesheuvel@linaro.org>) id 1hdXfw-000760-FD
 for tpmdd-devel@lists.sourceforge.net; Wed, 19 Jun 2019 10:18:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:Cc:To:
 Subject:Message-ID:Date:From:In-Reply-To:References:MIME-Version:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=NOAHJ6UJcXUgY0jPOCunNfj5a/meWoc55ppSw19pMJw=; b=WJcp0XcG8XzR0Ki8vKUMCRpj3h
 uFiPomD1vEhCVh6R1o83tEiIdPESRL6RxuyGs9gC5w5TOQKlt9wLKZ6GJUBfMtcv8bGSR5F7JLUBq
 3m20PJui4Qs/uoxHNn+4APnzNGx+uY1wPXXptB7N5ISpB48DWLblcixdb7cWwCqshIp4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:Message-ID:Date:From
 :In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=NOAHJ6UJcXUgY0jPOCunNfj5a/meWoc55ppSw19pMJw=; b=Yj30PfkoGRwf7CWDgeUt0FhfUV
 gei2FMDk2FHu3XEwVBEQPJ7M1/+pyFB7R+Z1hNOaC0jo/AbwqbjWlwWapGoyxD8EKbgUAJUUSXIeM
 850s1elpJkTEFj5QqoEPhxv3O2yxT+TvQRsbSJ8KrdfK4YRjtDYqraKc0DPA/KG/kOSE=;
Received: from mail-io1-f66.google.com ([209.85.166.66])
 by sfi-mx-1.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.90_1)
 id 1hdXft-00HC2y-VN
 for tpmdd-devel@lists.sourceforge.net; Wed, 19 Jun 2019 10:18:44 +0000
Received: by mail-io1-f66.google.com with SMTP id e5so36972341iok.4
 for <tpmdd-devel@lists.sourceforge.net>; Wed, 19 Jun 2019 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=NOAHJ6UJcXUgY0jPOCunNfj5a/meWoc55ppSw19pMJw=;
 b=iGE0xIN1mnywsd2Ce9XydaQG42uFJVo1Fa+IZlogrgNPhixIiWWhYhymIB7etaoEpb
 l+e97WPf9990nNcy6IpRVWoEb9DkjiD6cKYCIah98nQeNIaH68oYqHRSpke0+NSTMMXo
 KWZ7n1PPMoOzwCWUP58CEHIFKULymNRzLQVCjuiAbXjapCSFJ2ac6D94aLkgPFn/uYpU
 q6CFuiHP31HNHKFFv0p7KwXpQX9CtjGg1stHcPgjO7707+T4hr4luSJqSJ4CWPKkY201
 4GEG4agouZwtYoKwJQqEeartWFSHACEyaX7y1CVp7QTUa+3ZTHDyxb+hkRzEHNWMeDTq
 CJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=NOAHJ6UJcXUgY0jPOCunNfj5a/meWoc55ppSw19pMJw=;
 b=Vzzpyowq8NZUr9CHbJfTLSjdcrqwAckJQk+ZKrKW2tNcj1ZxicGTRphX0E7YNvB/21
 xL3/MeCbrJRbspj8VaZ6nWgdOWDDZTAfEtUdFpkeCdNTtDBRKtY6kFipdF6hpXRCyNGT
 eiPBJmLCTN/Rs/T7IUOwV3bD9mleXhVSnzAAFE78jcauKIOSXiB24azm/1mb06309YrS
 e5tg+KrWLZM4ImX0UrQjNZOvYpuJ2AbHMc7Oi4Dpvya46ZD6DHM+HWEtO1Ri/9y9YDso
 Y5S2HW73fsi+R7M7K6sBSQSRG+WgI4tiZbWKAHFOpZmNlrBKz2pXoQT6PJwtzNh9DcnR
 CfcA==
X-Gm-Message-State: APjAAAUp/a+H+XOGrvrFXuZ/hEXWU3a3n3fHzvZwmQebsnvmrV4ga8p9
 D2zQ5roLsKDnIWKPX9rIVlQwYJNaaNEazzunHY2rOW/N
X-Google-Smtp-Source: APXvYqx0Z9rJjYG9CYyxYrAwmG0di3UeYY5aGWznMiIWIfkmqvQTq3YVD+y6EmDduri62FB0Xj+idglWedVL/2PxuWo=
X-Received: by 2002:a5d:9d97:: with SMTP id 23mr10934397ion.204.1560938124836; 
 Wed, 19 Jun 2019 02:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190615040210.GA9112@hari-Inspiron-1545>
In-Reply-To: <20190615040210.GA9112@hari-Inspiron-1545>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Jun 2019 11:55:14 +0200
Message-ID: <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, 
 Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
 tpmdd-devel@lists.sourceforge.net, Matthew Garrett <mjg59@google.com>
X-Headers-End: 1hdXft-00HC2y-VN
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
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

KCsgSmFya2tvLCB0cG1kZCwgTWF0dGhldykKCk9uIFNhdCwgMTUgSnVuIDIwMTkgYXQgMDY6MDIs
IEhhcmlwcmFzYWQgS2VsYW0KPGhhcmlwcmFzYWQua2VsYW1AZ21haWwuY29tPiB3cm90ZToKPgo+
IFRoaXMgcGF0Y2ggZml4ZXMgYmVsb3cgd2FybmluZwo+Cj4gZHJpdmVycy9maXJtd2FyZS9lZmkv
dHBtLmM6Nzg6Mzg6IHdhcm5pbmc6IHBhc3NpbmcgYXJndW1lbnQgMSBvZgo+IOKAmHRwbTJfY2Fs
Y19ldmVudF9sb2dfc2l6ZeKAmSBtYWtlcyBwb2ludGVyIGZyb20gaW50ZWdlciB3aXRob3V0IGEg
Y2FzdAo+IFstV2ludC1jb252ZXJzaW9uXQo+Cj4gU2lnbmVkLW9mZi1ieTogSGFyaXByYXNhZCBL
ZWxhbSA8aGFyaXByYXNhZC5rZWxhbUBnbWFpbC5jb20+CgpJIHRoaW5rIHdlIGFscmVhZHkgaGF2
ZSBhIGZpeCBxdWV1ZWQgZm9yIHRoaXMsIG5vPwoKPiAtLS0KPiAgZHJpdmVycy9maXJtd2FyZS9l
ZmkvdHBtLmMgfCAyICstCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQo+Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL3RwbS5jIGIvZHJp
dmVycy9maXJtd2FyZS9lZmkvdHBtLmMKPiBpbmRleCA3NGQwY2QxLi4xZDNmNWNhIDEwMDY0NAo+
IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL3RwbS5jCj4gKysrIGIvZHJpdmVycy9maXJtd2Fy
ZS9lZmkvdHBtLmMKPiBAQCAtNzUsNyArNzUsNyBAQCBpbnQgX19pbml0IGVmaV90cG1fZXZlbnRs
b2dfaW5pdCh2b2lkKQo+ICAgICAgICAgICAgICAgICBnb3RvIG91dDsKPiAgICAgICAgIH0KPgo+
IC0gICAgICAgdGJsX3NpemUgPSB0cG0yX2NhbGNfZXZlbnRfbG9nX3NpemUoZWZpLnRwbV9maW5h
bF9sb2cKPiArICAgICAgIHRibF9zaXplID0gdHBtMl9jYWxjX2V2ZW50X2xvZ19zaXplKCh2b2lk
ICopZWZpLnRwbV9maW5hbF9sb2cKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICsgc2l6ZW9mKGZpbmFsX3RibC0+dmVyc2lvbikKPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICsgc2l6ZW9mKGZpbmFsX3RibC0+bnJfZXZlbnRz
KSwKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZpbmFsX3Ri
bC0+bnJfZXZlbnRzLAo+IC0tCj4gMi43LjQKPgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnRwbWRkLWRldmVsIG1haWxpbmcgbGlzdAp0cG1kZC1kZXZl
bEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQKaHR0cHM6Ly9saXN0cy5zb3VyY2Vmb3JnZS5uZXQvbGlz
dHMvbGlzdGluZm8vdHBtZGQtZGV2ZWwK
