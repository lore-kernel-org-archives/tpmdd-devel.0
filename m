Return-Path: <SRS0=z6fh=UT=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DC9C43613
	for <tpmdd-devel@archiver.kernel.org>; Thu, 20 Jun 2019 22:01:01 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 067F82075E
	for <tpmdd-devel@archiver.kernel.org>; Thu, 20 Jun 2019 22:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b="FPBRqafd";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="BJDWU0uo";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="cfPkw3Yg";
	dkim=neutral (0-bit key) header.d=google.com header.i=@google.com header.b="nMD9yr5q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 067F82075E
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.sourceforge.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.sourceforge.net; s=beta; h=Content-Transfer-Encoding:Content-Type:Cc:
	Reply-To:From:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:Subject:To:Message-ID:Date:In-Reply-To:References:
	MIME-Version:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Owner;
	bh=4p7XbLt5DFlg7rg6WmstD6nHdkDgc9d2OiJGar8IzM0=; b=FPBRqafdpLn6DB0rMbn8NuUV8p
	cHxl/2dV+RThl7mCjSa9fakVIq3QUulddreNSY6iYPRfhmsOPx20E50snR1mbmEiVfxYXX+lswcya
	cD5gK4Lpa1EEsPBTQTTuqpWiqb9EzIzZMsCbC/jVwbDp6tVC0wPN6je9h01iM8vK5XNQ=;
Received: from [127.0.0.1] (helo=sfs-ml-2.v29.lw.sourceforge.com)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1he572-0004yn-Fi; Thu, 20 Jun 2019 22:00:56 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-2.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <matthewgarrett@google.com>) id 1he571-0004yf-EI
 for tpmdd-devel@lists.sourceforge.net; Thu, 20 Jun 2019 22:00:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:Cc:To:Subject:Message-ID:Date:From:
 In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-Transfer-Encoding
 :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=q1L8uRv2O5Sf9Nnxuq5fcmvqea9J+FoKGX/eSZPI9YI=; b=BJDWU0uoLFsjTcZBTOycADOSKV
 D7z8SJdGvl3vtNfpUsX6vEV+XQ6sNjm7172+IfjyMAje9zXvokZupQH7nTS9bB4YjYgy/yytCLMtT
 Oj+smwD1D9q/noeKAYCkwrejqLIuohUBYOyGfRB9LeqcpxUzPLoWYPun5dtkZa0mOMwU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
 MIME-Version:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=q1L8uRv2O5Sf9Nnxuq5fcmvqea9J+FoKGX/eSZPI9YI=; b=cfPkw3YgAvCMLwI3k9AFG8ItiT
 lqqngfecR0H+G+w86cL2Pl7u5C2Elia0MRd5Ja0lchfMBIe4nCgZp03rqJCUjkc6gGCujKCLAl5EA
 15i277pbh7ZrYh51z0w2a7J8dPmF9+5FuOF/gvB1Zsty41RlERgKDTGzMYl0LyGzGyUQ=;
Received: from mail-io1-f66.google.com ([209.85.166.66])
 by sfi-mx-3.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.90_1)
 id 1he571-006zVW-8f
 for tpmdd-devel@lists.sourceforge.net; Thu, 20 Jun 2019 22:00:56 +0000
Received: by mail-io1-f66.google.com with SMTP id n5so421925ioc.7
 for <tpmdd-devel@lists.sourceforge.net>; Thu, 20 Jun 2019 15:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=q1L8uRv2O5Sf9Nnxuq5fcmvqea9J+FoKGX/eSZPI9YI=;
 b=nMD9yr5qiweWh1Lj7LZj1ylEbvr5Ei8RKKNYbfaQCHbkH8r3fxz8fbn3+I3TC79oT4
 K7ubsATwWtEbYTngqJDoZ7gqd44WiCWyOHJ49UY3o7Y6CFjBnlkppSuZX19Ax30cmibc
 r7KZYTqrIwkBaSK177hShJ/kwf6fzypVpcF0LB5FsrfkPC25ZVp7dKdy/Cc1Gs4pV1WY
 rXobPmwDjq8RhCh89WNhuUeb4GsTsN2On5UtX/xLHzugz3cnLg0MatEJ2DT3+QpeK9AH
 5x+2UAq4KXYjTNSLV/gEkxi6TT9NreFJNO/6k66BmKK8Eeyslb90Dmj8TORHWrG8nKyp
 plRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=q1L8uRv2O5Sf9Nnxuq5fcmvqea9J+FoKGX/eSZPI9YI=;
 b=W2B8mcZR0G5rYi0jZ633o97tuEJzzbEWkY7UpQWta/jHP6sQYRgWEjOi3E7yYFWXt5
 C3F7PHCuxWkBEso3dYu10hMg37NpuoRKDvjPgwbyNgttz0juSkFqEJTHCN8bKlS+Pjiw
 smHx9YVG+ido2UM4ompPiY57q5gNkY7ytSFXjn1T/kI7mXNsSNFbfCchcvs0Ul2RJ6PL
 lCquNIdf1FBSEIUbbmKFDy970Z5Dz+7qdJqOyJpQI4wLRJ5ty+T9kXbkzwYMqOxTXLvG
 SUS4saA/7jHiswG/3MKZqj9UcvbqtlpqrmnG2q9NgF347pYyqTZGQ0a8CNoifz7qynQ7
 /Kog==
X-Gm-Message-State: APjAAAVsdwaNwsUhUIOEBfJ9jalzSMJ62auqtCvaXBQHGTf76znUuJpH
 BdW+yzZIkOSphL1cb+zeiOamOVSyXNc3A5Ap6fKRew==
X-Google-Smtp-Source: APXvYqyrvNV0TAI2T6wKLb6CUaIt2peexavbbYTFmWo2/dmMyrc6AdQDx7XOB8ftB7s+gWh0AQgHtNlirFETQ42BIJM=
X-Received: by 2002:a05:6602:220d:: with SMTP id
 n13mr13392720ion.104.1561068049041; 
 Thu, 20 Jun 2019 15:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190615040210.GA9112@hari-Inspiron-1545>
 <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
 <CACdnJuudmE-MNuO7z87Mm65VaXbRzhOrBEpU5F=yC67uSLytGQ@mail.gmail.com>
 <20190620213722.GA17841@linux.intel.com>
In-Reply-To: <20190620213722.GA17841@linux.intel.com>
Date: Thu, 20 Jun 2019 15:00:37 -0700
Message-ID: <CACdnJusDaGkTAEWJ41+dGQxRWqxbgk8a_iNq5pCuGp=NsdEXgg@mail.gmail.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-Headers-End: 1he571-006zVW-8f
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
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

On Thu, Jun 20, 2019 at 2:37 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> Right! OK, I squashed just the fix to the earlier patch. Master and
> next are updated. Can you take a peek of [1] and see if it looks
> legit given all the fuzz around these changes? Then I'm confident
> enough to do the 5.3 PR.

All looks good to me. Thanks!


_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
