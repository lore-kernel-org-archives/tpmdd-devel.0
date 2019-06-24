Return-Path: <SRS0=2xwi=UX=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A05C43613
	for <tpmdd-devel@archiver.kernel.org>; Mon, 24 Jun 2019 16:39:18 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59B0B20665
	for <tpmdd-devel@archiver.kernel.org>; Mon, 24 Jun 2019 16:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="TVhJfjZ3";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="aUHfaAsX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59B0B20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-4.v29.lw.sourceforge.com)
	by sfs-ml-4.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1hfRzm-0006B3-Nn; Mon, 24 Jun 2019 16:39:06 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-4.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <jarkko.sakkinen@linux.intel.com>) id 1hfRzk-0006Ao-EG
 for tpmdd-devel@lists.sourceforge.net; Mon, 24 Jun 2019 16:39:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:Content-Type
 :References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jnGUP4MqsSSljjzS3kdLEbhqEsA2Gxzxk1AYsMnHGEE=; b=TVhJfjZ3MeVgrx5M9sDJHHpXS/
 d/YQgd4mHxEMd3fCKS6oGbdrY/e5OfBZQs3AqVmu2QI6ansG2ju2UGVpjQmY5RXoW2Dx24CzQbmQ5
 znHrsSVKRlS2Smzo70A417Jzx1PCVdmuHWXlrFF4wJZOdBnwEfiC1gc+R7LLYhU5tsGM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:
 In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=jnGUP4MqsSSljjzS3kdLEbhqEsA2Gxzxk1AYsMnHGEE=; b=aUHfaAsXSWbdmbdvX1nAgvgDJQ
 IzMh4/T9jWPDHTJgMClb59FZmJKk7qiH+MpBFprpXMhgyWXxkVaxRl0MmjWaCvnswCilP4u0MGhK5
 NYkKmzfkT7zs53LUvh0JiktzIBm4xz+ZictTP5eWnlIA3YRm6k2UlouvXC+vpFUloVfk=;
Received: from mga12.intel.com ([192.55.52.136])
 by sfi-mx-3.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 id 1hfRzo-00CIyu-GE
 for tpmdd-devel@lists.sourceforge.net; Mon, 24 Jun 2019 16:39:10 +0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 24 Jun 2019 09:23:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; d="scan'208";a="182666147"
Received: from akolosov-mobl1.ger.corp.intel.com ([10.249.33.80])
 by fmsmga001.fm.intel.com with ESMTP; 24 Jun 2019 09:23:31 -0700
Message-ID: <8acf82b7066f260332f9353682d4b83e44b68b88.camel@linux.intel.com>
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Matthew Garrett <mjg59@google.com>
Date: Mon, 24 Jun 2019 19:23:30 +0300
In-Reply-To: <CACdnJusDaGkTAEWJ41+dGQxRWqxbgk8a_iNq5pCuGp=NsdEXgg@mail.gmail.com>
References: <20190615040210.GA9112@hari-Inspiron-1545>
 <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
 <CACdnJuudmE-MNuO7z87Mm65VaXbRzhOrBEpU5F=yC67uSLytGQ@mail.gmail.com>
 <20190620213722.GA17841@linux.intel.com>
 <CACdnJusDaGkTAEWJ41+dGQxRWqxbgk8a_iNq5pCuGp=NsdEXgg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
X-Headers-End: 1hfRzo-00CIyu-GE
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

On Thu, 2019-06-20 at 15:00 -0700, Matthew Garrett wrote:
> On Thu, Jun 20, 2019 at 2:37 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > Right! OK, I squashed just the fix to the earlier patch. Master and
> > next are updated. Can you take a peek of [1] and see if it looks
> > legit given all the fuzz around these changes? Then I'm confident
> > enough to do the 5.3 PR.
> 
> All looks good to me. Thanks!

Thank you! I'll send the PR now.

/Jarkko



_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
