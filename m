Return-Path: <tpmdd-devel-bounces@lists.sourceforge.net>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C88C05027
	for <tpmdd-devel@archiver.kernel.org>; Fri, 20 Jan 2023 23:08:18 +0000 (UTC)
Received: from [127.0.0.1] (helo=sfs-ml-2.v29.lw.sourceforge.com)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtp (Exim 4.95)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1pJ0US-0001PQ-3y;
	Fri, 20 Jan 2023 23:08:07 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-2.v29.lw.sourceforge.com with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <jmorris@namei.org>) id 1pJ0UR-0001PK-4y
 for tpmdd-devel@lists.sourceforge.net;
 Fri, 20 Jan 2023 23:08:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:cc:To:
 From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=832X1wFeFvBP7zn6qg1MnTozywg+pZKIevCV58PkLuU=; b=Y8CLOykBW30MCmWHoql3oDfBYD
 P9WjSQq5iDgCMaURfXKjfUeN6nQ21ggPash7SmFOnIyFLwyS6V4muQ6hD2s3nAQQEjuL17YELGYu9
 KVzIdlNWfkpNFVpHikEpKalqMMkLlXFhIApZQhLan1eGusbMrPUFcxXA1TMSLOCmx7xY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:Message-ID:Subject:cc:To:From:Date:Sender:
 Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
 :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=832X1wFeFvBP7zn6qg1MnTozywg+pZKIevCV58PkLuU=; b=b
 pxXJiPxE9gDzqE6jXVcVFKqFmIFEpw9oueRf2Emg+OD4OQAWw6fZBPliW/UX5ty3u1H5bT0crqrar
 N1bjaJ8o+qUXU7rRvoz9lo8nMC/A6D52zMwTRjsDsjbnesiXO55YfX+xUFlfQe6UPRlNMZgxHJGvC
 0mjjW/qFmgBDKw50=;
Received: from namei.org ([65.99.196.166] helo=mail.namei.org)
 by sfi-mx-1.v28.lw.sourceforge.com with esmtps
 (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.95)
 id 1pJ0UM-00ApjF-JM for tpmdd-devel@lists.sourceforge.net;
 Fri, 20 Jan 2023 23:08:06 +0000
Received: from localhost (localhost [127.0.0.1])
 by mail.namei.org (Postfix) with ESMTPS id E3C12AD;
 Fri, 20 Jan 2023 22:24:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org E3C12AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
 t=1674253497; bh=832X1wFeFvBP7zn6qg1MnTozywg+pZKIevCV58PkLuU=;
 h=Date:From:To:cc:Subject:From;
 b=2OvRPlLlu0IRwFkzk7r/g4QoHBpbqWNvQvLLAd2FjSSRQ6uTnF7VFpFfWdQljqLZ9
 K0mp8sBsE3y6tP/GGTGqEJRSeyPNGKBVyggPNZ1agSJKeQ528q5mouUmCxAgh9G8bm
 V0OqQUV/M4DT+zX+z0EyR7SGjqKsLz/n3bAbAhHk=
Date: Sat, 21 Jan 2023 09:24:57 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Message-ID: <3a8f10eb-df2-cfad-1d-5aeab14568e@namei.org>
MIME-Version: 1.0
X-Headers-End: 1pJ0UM-00ApjF-JM
Subject: [tpmdd-devel] [ANNOUNCE] Linux Security Summit North Americ
 (LSS-NA) CfP
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
 Audit-ML <linux-audit@redhat.com>, linux-crypto@vger.kernel.org, lwn@lwn.net,
 linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

The Call for Participation for the 2023 LSS-NA conference is open!

See details of the event and information on submitting proposals here:
https://events.linuxfoundation.org/linux-security-summit-north-america/

LSS-NA 2023 will be in Vancouver, BC, Canada, from May 10th to May 12th. 
This will be a three day event, co-located with Open Source Summit North 
America [1].

The LSS-NA CfP is open until March 1st, 2023.


Note that announcements relating to the Linux Security Summit may be found 
now on the Fediverse, via: https://social.kernel.org/LinuxSecSummit


-- 
James Morris
<jmorris@namei.org>


[1] https://events.linuxfoundation.org/open-source-summit-north-america/


_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
