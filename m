Return-Path: <SRS0=syPD=US=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1A9C43613
	for <tpmdd-devel@archiver.kernel.org>; Wed, 19 Jun 2019 23:14:59 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 883E521537
	for <tpmdd-devel@archiver.kernel.org>; Wed, 19 Jun 2019 23:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b="jA8KzN2C";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="LjBevYLU";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="EB70u6ot";
	dkim=neutral (0-bit key) header.d=google.com header.i=@google.com header.b="d6WWNTDf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 883E521537
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.sourceforge.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.sourceforge.net; s=beta; h=Content-Transfer-Encoding:Content-Type:Cc:
	Reply-To:From:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:Subject:To:Message-ID:Date:In-Reply-To:References:
	MIME-Version:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Owner;
	bh=IP9dz5iXusIjseU53+cWwe4k7PorWPz1H7SULq+o20s=; b=jA8KzN2CcVH8uZZ9LjBplfg/Sr
	aSAHRafRpWGeeiHPy4XvWttYu3vrT8dl0YILLl3B+bwJL4Lqy9RzaN3j4ShjNg/1L9X2jzAAGwa8D
	tpBA3vZQ5gglCGvJxml9Wdql65qzTcJwoqR07RULUHLLgASojq2K7tNcT3FILDbSv6pI=;
Received: from [127.0.0.1] (helo=sfs-ml-2.v29.lw.sourceforge.com)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1hdjn3-0002cu-Ov; Wed, 19 Jun 2019 23:14:53 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-2.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <matthewgarrett@google.com>) id 1hdjn2-0002cm-HT
 for tpmdd-devel@lists.sourceforge.net; Wed, 19 Jun 2019 23:14:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:Cc:To:
 Subject:Message-ID:Date:From:In-Reply-To:References:MIME-Version:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YKJaoMjaF4vCZqPi8dwckcEgHtOWdNYvU090tpibj0w=; b=LjBevYLUmtde8UJtCq2V55scjq
 fOtyHfp534DGs7WpGAV9o5E4YTlUz/U3l0lHHIGgEObeLkezP+ngGgIWHSgZB8QNI1gII4IrTpu3S
 Fbvrc9VQrwu4n6XTQEfQb0mknYrOCsH/K5v1d9V+FbZLz+L6hCMkun4XlOBRB9huOe2A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:Message-ID:Date:From
 :In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=YKJaoMjaF4vCZqPi8dwckcEgHtOWdNYvU090tpibj0w=; b=EB70u6ot5/2ei0y+nHtNRzF95p
 drMHOK2wQEBLvA5HqnPF/8YNvHaatv9lm94r3Es/3zZV2gScRUdzDnAOeAjQdBEr1lpDQWbw72ghN
 wO+iRgauF3x1iPsQBkoaAxWMaYrFlKnQMXb++78LQRFoFHGtLI5sbQVy1/WWF48drLfY=;
Received: from mail-io1-f68.google.com ([209.85.166.68])
 by sfi-mx-3.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.90_1)
 id 1hdjn1-005kP8-HK
 for tpmdd-devel@lists.sourceforge.net; Wed, 19 Jun 2019 23:14:52 +0000
Received: by mail-io1-f68.google.com with SMTP id e3so1451329ioc.12
 for <tpmdd-devel@lists.sourceforge.net>; Wed, 19 Jun 2019 16:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=YKJaoMjaF4vCZqPi8dwckcEgHtOWdNYvU090tpibj0w=;
 b=d6WWNTDf8BwpcDeLK3CHrloIi8s3+6D20pkxtkx0tfHOzYzHxUI6l1c1+/LNMs30sM
 BMoSj2tz2++N/8yJG1frilcp+5jbpEvCMOhUNiSdjIaB9yxbr+UO33vHSgypay0UfOhi
 Akil9xVSqel1xTCQ4z11nvl3JpSCjY2nZZtKPRabomxyQWdVOczgB+u+evqwqvTekzlT
 7CcmYKsjG5BewmhtbtVRS1jKryf4TZHc8v0FmbPQ9rAXmEuK8zjbvTCi+lB6n2kUt45z
 0I6TQbCHrUNoR5C3o5YvtxgW4P36jHKWnGvCb01DQFWtUWUI/YyQyNWXVuYoliIbAWgw
 8zEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=YKJaoMjaF4vCZqPi8dwckcEgHtOWdNYvU090tpibj0w=;
 b=NhrmQKFDvfuPBPIfy9G1ZEdRrn6OSeybxdpXNrgwqBKRgu42Y54GZ15IbHNRMXNI0e
 PFFCtUCg1LgkLk+HAXWWAFLq02k8yTDdyw0ucW4yTzcCE7ruSIB9lhbCvp7xys/HkDyK
 KmEJIkmfUXaJv2eqxU+XTyYjNK5VmQLK2RHPQMNfRfbnLGpo0+5Ine+J1PN9jkQ9zjPt
 JhsUzzXgvJC0l2LKglnTsjfsNAMrQ2Ohj/D2aJbEvtQd+me752WhchwE5NSlkwilofkD
 WHoTQWGIYANYn6m3ao0UQ2o/i9S5gf9llzc3xuOMrhcZeHJdG0O4FjVH1tSASzxL38z9
 x4/A==
X-Gm-Message-State: APjAAAXdq5kYfjsoF9V8xLMicFFIVlYebLOlygyfAt7aq6FvB2oiU6qi
 AdrjJjcP4NiO7mWMYNNw26YMzNhXUuPzNs+W0gmliYbh/Tzmeg==
X-Google-Smtp-Source: APXvYqw4FrufMrwsWG20g5Vc8KSbXAfu2/rJlkScfVMpc4fL31bGQq9hagdM9w9y1ld98AaKyaZC78IP96NTZbSLwSY=
X-Received: by 2002:a02:cc6c:: with SMTP id j12mr12111505jaq.102.1560984514733; 
 Wed, 19 Jun 2019 15:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190615040210.GA9112@hari-Inspiron-1545>
 <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
Date: Wed, 19 Jun 2019 15:48:23 -0700
Message-ID: <CACdnJuudmE-MNuO7z87Mm65VaXbRzhOrBEpU5F=yC67uSLytGQ@mail.gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
X-Headers-End: 1hdjn1-005kP8-HK
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
From: Matthew Garrett via tpmdd-devel <tpmdd-devel@lists.sourceforge.net>
Reply-To: Matthew Garrett <mjg59@google.com>
Cc: linux-efi <linux-efi@vger.kernel.org>,
 Hariprasad Kelam <hariprasad.kelam@gmail.com>,
 tpmdd-devel@lists.sourceforge.net,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

T24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMjo1NSBBTSBBcmQgQmllc2hldXZlbAo8YXJkLmJpZXNo
ZXV2ZWxAbGluYXJvLm9yZz4gd3JvdGU6Cj4KPiAoKyBKYXJra28sIHRwbWRkLCBNYXR0aGV3KQo+
Cj4gT24gU2F0LCAxNSBKdW4gMjAxOSBhdCAwNjowMiwgSGFyaXByYXNhZCBLZWxhbQo+IDxoYXJp
cHJhc2FkLmtlbGFtQGdtYWlsLmNvbT4gd3JvdGU6Cj4gPgo+ID4gVGhpcyBwYXRjaCBmaXhlcyBi
ZWxvdyB3YXJuaW5nCj4gPgo+ID4gZHJpdmVycy9maXJtd2FyZS9lZmkvdHBtLmM6Nzg6Mzg6IHdh
cm5pbmc6IHBhc3NpbmcgYXJndW1lbnQgMSBvZgo+ID4g4oCYdHBtMl9jYWxjX2V2ZW50X2xvZ19z
aXpl4oCZIG1ha2VzIHBvaW50ZXIgZnJvbSBpbnRlZ2VyIHdpdGhvdXQgYSBjYXN0Cj4gPiBbLVdp
bnQtY29udmVyc2lvbl0KPiA+Cj4gPiBTaWduZWQtb2ZmLWJ5OiBIYXJpcHJhc2FkIEtlbGFtIDxo
YXJpcHJhc2FkLmtlbGFtQGdtYWlsLmNvbT4KPgo+IEkgdGhpbmsgd2UgYWxyZWFkeSBoYXZlIGEg
Zml4IHF1ZXVlZCBmb3IgdGhpcywgbm8/CgpJdCBsb29rcyBsaWtlIEkgZml4ZWQgdGhpcyBpbiAi
RG9uJ3QgZHVwbGljYXRlIGV2ZW50cyBmcm9tIHRoZSBmaW5hbApldmVudCBsb2cgaW4gdGhlIFRD
RzIgbG9nIiByYXRoZXIgdGhhbiBhIHNlcGFyYXRlIHBhdGNoIC0gSSdtIGZpbmUKbWVyZ2luZyB0
aGlzLCBiYXNlZCBvbiBKYXJra28ncyBwcmVmZXJlbmNlcy4KCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp0cG1kZC1kZXZlbCBtYWlsaW5nIGxpc3QKdHBt
ZGQtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8vbGlzdHMuc291cmNlZm9yZ2Uu
bmV0L2xpc3RzL2xpc3RpbmZvL3RwbWRkLWRldmVsCg==
