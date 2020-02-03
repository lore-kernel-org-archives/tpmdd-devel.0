Return-Path: <SRS0=TLLb=3Y=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D437FC35247
	for <tpmdd-devel@archiver.kernel.org>; Tue,  4 Feb 2020 00:17:40 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93EAF20720
	for <tpmdd-devel@archiver.kernel.org>; Tue,  4 Feb 2020 00:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="JtWPYK9W";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="PMvT4rJh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93EAF20720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-1.v29.lw.sourceforge.com)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1iyluH-0008V9-FV; Tue, 04 Feb 2020 00:17:33 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-1.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <jmorris@namei.org>) id 1iyluF-0008Us-VB
 for tpmdd-devel@lists.sourceforge.net; Tue, 04 Feb 2020 00:17:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-ID:Content-Type:MIME-Version:Message-ID:
 Subject:cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=civ6iG0b/6pea3YDZxKAjWDPzTpz3lzLY0fpJ4AK8jg=; b=JtWPYK9WdTte773b5zGNTInkvk
 r+VZirAS9Qgue3Ri4nKP0W5vVc+CgcmL+oBqhgBNZWM/HAafnIDcA7utP2T+4zBJEzbkmUpBpHIYh
 JaC3nJ3p74KT4P238bVtfeQS3EI2RVYAg94DCbSxUu043SPTewW9QwAvPgkzr1dwWVyM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-ID:Content-Type:MIME-Version:Message-ID:Subject:cc:To:From:Date:
 Sender:Reply-To:Content-Transfer-Encoding:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=civ6iG0b/6pea3YDZxKAjWDPzTpz3lzLY0fpJ4AK8jg=; b=P
 MvT4rJhPnxgp79GIeRkyoK7xVQdfh3zXDmT2r9+01KLf2VBTIdP95gbP745gYIqftvob5LA2yzcOG
 bzdt8VDTChuPqJCZ7iMG3KPqUzVRHNthXXZxnnpe4hf8Xx8fl/lmqjIUq060bo46vywbGC/BOBPte
 8yH9bM9i36cwOz38=;
Received: from namei.org ([65.99.196.166])
 by sfi-mx-3.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.92.2)
 id 1iyluC-009Us0-7V
 for tpmdd-devel@lists.sourceforge.net; Tue, 04 Feb 2020 00:17:31 +0000
Received: from localhost (localhost [127.0.0.1])
 by namei.org (8.14.4/8.14.4) with ESMTP id 013Nxnn2015307;
 Mon, 3 Feb 2020 23:59:49 GMT
Date: Tue, 4 Feb 2020 10:59:49 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Message-ID: <alpine.LRH.2.21.2002041054320.12768@namei.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 BOUNDARY="1665246916-1737447927-1580774163=:12768"
Content-ID: <alpine.LRH.2.21.2002041056360.12768@namei.org>
X-Headers-End: 1iyluC-009Us0-7V
Subject: [tpmdd-devel] [ANNOUNCE][CFP] Linux Security Summit North America
 2020
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
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1737447927-1580774163=:12768
Content-Type: text/plain; CHARSET=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2002041056361.12768@namei.org>

==============================================================================
		   ANNOUNCEMENT AND CALL FOR PARTICIPATION

		   LINUX SECURITY SUMMIT NORTH AMERICA 2020
                             
			        24-26 JUNE
			    AUSTIN, TEXAS, USA
==============================================================================

DESCRIPTION
 
Linux Security Summit North America (LSS-NA) is a technical forum for
collaboration between Linux developers, researchers, and end-users.  Its
primary aim is to foster community efforts in analyzing and solving Linux
security challenges.
 
 The program committee currently seeks proposals for:
 
   * Refereed Presentations:
     45 minutes in length.
 
   * Panel Discussion Topics:
     45 minutes in length.
 
   * Short Topics:
     30 minutes in total, including at least 10 minutes discussion.
 
   * Tutorials
     90 minutes in length.
 
Tutorial sessions should be focused on advanced Linux security defense
topics within areas such as the kernel, compiler, and security-related
libraries.  Priority will be given to tutorials created for this conference,
and those where the presenter a leading subject matter expert on the topic.
 
Topic areas include, but are not limited to:
 
   * Kernel self-protection
   * Access control
   * Cryptography and key management
   * Integrity policy and enforcement
   * Hardware Security
   * IoT and embedded security
   * Virtualization and containers
   * System-specific system hardening
   * Case studies
   * Security tools
   * Security UX
   * Emerging technologies, threats & techniques

  Proposals should be submitted via:

    https://events.linuxfoundation.org/linux-security-summit-north-america/program/cfp/
 

DATES
 
  * CFP close:            March 31
  * CFP notifications:    April 13
  * Schedule announced:   April 16
  * Event:                June 24-26


WHO SHOULD ATTEND
 
We're seeking a diverse range of attendees and welcome participation by
people involved in Linux security development, operations, and research.
 
LSS-NA is a unique global event that provides the opportunity to present and
discuss your work or research with key Linux security community members and
maintainers.  It¢s also useful for those who wish to keep up with the latest
in Linux security development and to provide input to the development
process.

WEB SITE

    https://events.linuxfoundation.org/linux-security-summit-north-america/

TWITTER

  For event updates and announcements, follow:

    https://twitter.com/LinuxSecSummit
  
    #linuxsecuritysummit

PROGRAM COMMITTEE

  The program committee for LSS 2020 is:

    * James Morris, Microsoft
    * Serge Hallyn, Cisco
    * Paul Moore, Cisco
    * Stephen Smalley, NSA
    * Elena Reshetova, Intel
    * John Johansen, Canonical
    * Kees Cook, Google
    * Casey Schaufler, Intel
    * Mimi Zohar, IBM
    * David A. Wheeler, Institute for Defense Analyses

  The program committee may be contacted as a group via email:
    lss-pc () lists.linuxfoundation.org
--1665246916-1737447927-1580774163=:12768
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--1665246916-1737447927-1580774163=:12768
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--1665246916-1737447927-1580774163=:12768--

