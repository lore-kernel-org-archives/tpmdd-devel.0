Return-Path: <SRS0=Laqv=KU=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F68C2B9F8
	for <tpmdd-devel@archiver.kernel.org>; Tue, 25 May 2021 16:45:08 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B8B6B60FF3
	for <tpmdd-devel@archiver.kernel.org>; Tue, 25 May 2021 16:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8B6B60FF3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-1.v29.lw.sourceforge.com)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1llaAu-0004OU-0f; Tue, 25 May 2021 16:45:00 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-1.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <jmorris@namei.org>) id 1llaAs-0004OD-UP
 for tpmdd-devel@lists.sourceforge.net; Tue, 25 May 2021 16:44:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:References:Message-ID:
 In-Reply-To:Subject:cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
 :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=gPhJw8Ek+CdBR2v42LRCyEpZ0guCZ/GtDCmipt+KqG8=; b=QKNBpqe1REE3Hcp75Y8QMygK8f
 QBg4GmTk+ucZLzv6CvzQCFI2Llieae4fCxJenx+0NHlJD2d02G+6jeksAiOyKbjRQyMtdldoDBNbD
 MJZgqljRRlDSI+Q2Wkkr/d+Nne3XUHshaiXqWH49RykNE57Hsw7my2xd4Stk0yYDkPvw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:References:Message-ID:In-Reply-To:Subject:cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=gPhJw8Ek+CdBR2v42LRCyEpZ0guCZ/GtDCmipt+KqG8=; b=iD3bwLWvuinPizjqf9OYLvmhal
 SOBcHcO4JFQHh61caDMTtgby/Cav+98/5DxYtMvgOkm/XFHIAYNMR9me7UN6ZLtaXOAfSl/TSyt6U
 hvjYH0VKIk2CVo2Vs52dko1gmBADabp22Ugi3UVBYRacZti2QPDEVNtWZ3BfAmt8wqO4=;
Received: from namei.org ([65.99.196.166] helo=mail.namei.org)
 by sfi-mx-2.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.92.3)
 id 1llaAn-0005t8-Es
 for tpmdd-devel@lists.sourceforge.net; Tue, 25 May 2021 16:44:58 +0000
Received: from localhost (localhost [127.0.0.1])
 by mail.namei.org (Postfix) with ESMTPS id 9AC61DCF;
 Tue, 25 May 2021 16:24:35 +0000 (UTC)
Date: Wed, 26 May 2021 02:24:35 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
In-Reply-To: <c244f77-56a1-c089-521d-2e670488c10@namei.org>
Message-ID: <5b3a0bf-226d-6ee-d0b-d6673eff32b2@namei.org>
References: <c244f77-56a1-c089-521d-2e670488c10@namei.org>
MIME-Version: 1.0
X-Headers-End: 1llaAn-0005t8-Es
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
 Audit-ML <linux-audit@redhat.com>, linux-crypto@vger.kernel.org, lwn@lwn.net,
 linux-integrity@vger.kernel.org, fedora-selinux-list@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

Note that the venue of LSS 2021 has now changed to Seattle, USA.

See https://events.linuxfoundation.org/linux-security-summit-north-america/

The new event dates are 29 September to 01 October.

The CFP closes on June 27th.





On Tue, 9 Feb 2021, James Morris wrote:

> ==============================================================================
>                    ANNOUNCEMENT AND CALL FOR PARTICIPATION
> 
>                          LINUX SECURITY SUMMIT 2021
>                              
>                               27-29 September
>                               Dublin, Ireland
> ==============================================================================
> 
> DESCRIPTION
>  
> Linux Security Summit (LSS) is a technical forum for collaboration between
> Linux developers, researchers, and end-users.  Its primary aim is to foster
> community efforts in analyzing and solving Linux security challenges.
> 
>  The program committee currently seeks proposals for:
>  
>    * Refereed Presentations:
>      45 minutes in length.
>  
>    * Panel Discussion Topics:
>      45 minutes in length.
>  
>    * Short Topics:
>      30 minutes in total, including at least 10 minutes discussion.
>  
>    * Tutorials
>      90 minutes in length.
>  
> Tutorial sessions should be focused on advanced Linux security defense
> topics within areas such as the kernel, compiler, and security-related
> libraries.  Priority will be given to tutorials created for this conference,
> and those where the presenter a leading subject matter expert on the topic.
>  
> Topic areas include, but are not limited to:
>  
>    * Kernel self-protection
>    * Access control
>    * Cryptography and key management
>    * Integrity policy and enforcement
>    * Hardware Security
>    * IoT and embedded security
>    * Virtualization and containers
>    * System-specific system hardening
>    * Case studies
>    * Security tools
>    * Security UX
>    * Emerging technologies, threats & techniques
> 
>   Proposals should be submitted via:
>     https://events.linuxfoundation.org/linux-security-summit-europe/program/cfp/
> 
> 
> ** Note that for 2021, the North American and European events are combined into
> a single event planned for Dublin, Ireland. **
>  
> 
> DATES
>  
>   * CFP close:            June 27
>   * CFP notifications:    July 20
>   * Schedule announced:   July 22
>   * Event:                September 27-29
> 
> WHO SHOULD ATTEND
>  
> We're seeking a diverse range of attendees and welcome participation by
> people involved in Linux security development, operations, and research.
>  
> LSS is a unique global event that provides the opportunity to present and
> discuss your work or research with key Linux security community members and
> maintainers.  It's also useful for those who wish to keep up with the latest
> in Linux security development and to provide input to the development
> process.
> 
> WEB SITE
> 
>     https://events.linuxfoundation.org/linux-security-summit-europe/
> 
> TWITTER
> 
>   For event updates and announcements, follow:
> 
>     https://twitter.com/LinuxSecSummit
>   
>     #linuxsecuritysummit
> 
> PROGRAM COMMITTEE
> 
>   The program committee for LSS 2021 is:
> 
>     * James Morris, Microsoft
>     * Serge Hallyn, Cisco
>     * Paul Moore, Cisco
>     * Stephen Smalley, NSA
>     * Elena Reshetova, Intel
>     * John Johansen, Canonical
>     * Kees Cook, Google
>     * Casey Schaufler, Intel
>     * Mimi Zohar, IBM
>     * David A. Wheeler, Institute for Defense Analyses
> 
>   The program committee may be contacted as a group via email:
>     lss-pc () lists.linuxfoundation.org
> 
> 

-- 
James Morris
<jmorris@namei.org>



_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
