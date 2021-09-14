Return-Path: <SRS0=OMdi=OE=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE22EC433EF
	for <tpmdd-devel@archiver.kernel.org>; Tue, 14 Sep 2021 03:11:41 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98E2460FDA
	for <tpmdd-devel@archiver.kernel.org>; Tue, 14 Sep 2021 03:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98E2460FDA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-1.v29.lw.sourceforge.com)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1mPyr8-0002Zx-Ri; Tue, 14 Sep 2021 03:11:34 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-1.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <jmorris@namei.org>) id 1mPyr7-0002Zk-DY
 for tpmdd-devel@lists.sourceforge.net; Tue, 14 Sep 2021 03:11:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:References:Message-ID:
 In-Reply-To:Subject:cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
 :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=U7JBhDMH9ievC0SX9kmvA4/Nk8Q5WSRUdZREf6oN2yg=; b=WRlMf0lqttsyIb7o7EAXyIDjdO
 /Mapa+trI9TuPxHQY58Gvs9Fk9fbwUVtN7aEQH/A5r2ltmAtBo4Aade1wK2ffjP6/62J6dJTnUjac
 a4pNPuj6sz4LWPYh6Qk8aMbtiuBMGGy2d5Cfs13hZAzAQ8IfRpLGRCOz/3tY5hmD3sag=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:References:Message-ID:In-Reply-To:Subject:cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=U7JBhDMH9ievC0SX9kmvA4/Nk8Q5WSRUdZREf6oN2yg=; b=Ok90qi8r9RseXVerIzIn9m3NPM
 UUJ+6SllhsQc3Y7zhIHVEzPTVHBbe7C77FDFBOUg8CJVUvNQOk+tyO7903uEr/+PDAG+Bj06BeV4D
 t60O5agD9OfAnZgyGazjS6fCKOYqsVOqKzn2qxlgNy+c6/q3jz5T7cGaLG6l6ysMA4jU=;
Received: from namei.org ([65.99.196.166] helo=mail.namei.org)
 by sfi-mx-2.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.92.3)
 id 1mPyr6-0003S2-G5
 for tpmdd-devel@lists.sourceforge.net; Tue, 14 Sep 2021 03:11:33 +0000
Received: from localhost (localhost [127.0.0.1])
 by mail.namei.org (Postfix) with ESMTPS id 5473196E;
 Tue, 14 Sep 2021 02:44:46 +0000 (UTC)
Date: Tue, 14 Sep 2021 12:44:46 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
In-Reply-To: <2db579ee-1d1c-102c-c2d4-c268d89aae8c@namei.org>
Message-ID: <8c864314-e0b9-e394-2271-5fab5e9cd11a@namei.org>
References: <c244f77-56a1-c089-521d-2e670488c10@namei.org>
 <5b3a0bf-226d-6ee-d0b-d6673eff32b2@namei.org>
 <2db579ee-1d1c-102c-c2d4-c268d89aae8c@namei.org>
MIME-Version: 1.0
X-Headers-End: 1mPyr6-0003S2-G5
Subject: Re: [tpmdd-devel] [ANNOUNCE][CFP] Linux Security Summit 2021
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
Cc: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>,
 keyrings@linux-nfs.org, gentoo-hardened@gentoo.org,
 kernel-hardening@lists.openwall.com, selinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
 Audit-ML <linux-audit@redhat.com>, linux-crypto@vger.kernel.org,
 linux-integrity@vger.kernel.org, fedora-selinux-list@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

For folks presenting remotely, the deadline for video talks is extended to 
20th September, 2021.

Reminder: you can keep track LSS event information via: 
https://twitter.com/LinuxSecSummit


-- 
James Morris
<jmorris@namei.org>



_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
