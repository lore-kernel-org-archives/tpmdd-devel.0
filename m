Return-Path: <SRS0=W0Vr=SL=lists.sourceforge.net=tpmdd-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308C3C10F0E
	for <tpmdd-devel@archiver.kernel.org>; Tue,  9 Apr 2019 23:11:04 +0000 (UTC)
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EDE1D20857
	for <tpmdd-devel@archiver.kernel.org>; Tue,  9 Apr 2019 23:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sourceforge.net header.i=@sourceforge.net header.b="hLcJ70Uk";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sf.net header.i=@sf.net header.b="N3FRzMmE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDE1D20857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=tpmdd-devel-bounces@lists.sourceforge.net
Received: from [127.0.0.1] (helo=sfs-ml-4.v29.lw.sourceforge.com)
	by sfs-ml-4.v29.lw.sourceforge.com with esmtp (Exim 4.90_1)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1hDztJ-0003ry-GK; Tue, 09 Apr 2019 23:10:57 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-4.v29.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <jmorris@namei.org>) id 1hDztI-0003rn-2e
 for tpmdd-devel@lists.sourceforge.net; Tue, 09 Apr 2019 23:10:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:cc:To:
 From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=UETkuRITVQyF60zkzwMgCXGTAxhnWMcZcadgzbuXPq0=; b=hLcJ70Uky9/3lb7JB76g4J+ruQ
 +pi1M3OoulOT/HYQC44QZCgUv75mzTpW1JpE1rTmPush+wu+ywMggOKtUSDir6YXjwEBQI736klTH
 MkLwXLhQ4lXl+8ZX8uK/JWDlYC85EmbOTma/+/dTDB/D+XdrbJV7C65IFKyS/sTbHyK0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:Message-ID:Subject:cc:To:From:Date:Sender:
 Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
 :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=UETkuRITVQyF60zkzwMgCXGTAxhnWMcZcadgzbuXPq0=; b=N
 3FRzMmEMWMvDl1TOcpwsRGsMP0RzDUSZwUuTxbFJB9sFUY7dQuX69L117QVmquXSgn79qSDe/uoHF
 SSIqR3fX/+wYl6PdFQQuJ7NFEydt0AeYGKBXfH1ioUA43zED2zGEggA+sEMSaJIKVquA79tJi3RKa
 l6CwVX858C7MBIvI=;
Received: from namei.org ([65.99.196.166])
 by sfi-mx-1.v28.lw.sourceforge.com with esmtps
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 id 1hDztF-00AVAn-PN
 for tpmdd-devel@lists.sourceforge.net; Tue, 09 Apr 2019 23:10:55 +0000
Received: from localhost (localhost [127.0.0.1])
 by namei.org (8.14.4/8.14.4) with ESMTP id x39MYpkB016645;
 Tue, 9 Apr 2019 22:34:51 GMT
Date: Wed, 10 Apr 2019 08:34:51 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <alpine.LRH.2.21.1904100829230.16313@namei.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="1665246916-1292412540-1554849292=:16313"
X-Headers-End: 1hDztF-00AVAn-PN
Subject: [tpmdd-devel] [ANNOUNCE][CFP] Linux Security Summit North America
 2019
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
 gentoo-hardened@gentoo.org, kernel-hardening@lists.openwall.com,
 selinux@vger.kernel.org, keyrings@linux-nfs.org,
 tpmdd-devel@lists.sourceforge.net, Audit-ML <linux-audit@redhat.com>,
 linux-crypto@vger.kernel.org, lwn@lwn.net, linux-integrity@vger.kernel.org,
 fedora-selinux-list@redhat.com
Errors-To: tpmdd-devel-bounces@lists.sourceforge.net
Message-ID: <20190409223451.T9PEfW7WuAwghfOJO5zqxfzoO3y1zbbJRBtVE9vm5O8@z>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1292412540-1554849292=:16313
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

==============================================================================
		   ANNOUNCEMENT AND CALL FOR PARTICIPATION

		   LINUX SECURITY SUMMIT NORTH AMERICA 2019
                             
			         19-21 August
			     SAN DIEGO, CA, USA
==============================================================================


DESCRIPTION

  The Linux Security Summit (LSS) is a technical forum for collaboration
  between Linux developers, researchers, and end users. Its primary aim is to
  foster community efforts in analyzing and solving Linux security challenges.

  LSS will be held this year as two separate events, one in North America
  (LSS-NA), and one in Europe (LSS-EU), to facilitate broader participation in
  Linux Security development. Note that this CFP is for LSS-NA; a separate CFP
  will be announced for LSS-EU in May. We encourage everyone to attend both
  events.


  The program committee currently seeks proposals for:

    * Refereed Presentations:
      45 minutes in length.

    * Panel Discussion Topics:
      45 minutes in length.

    * Short Topics:
      30 minutes in total, including at least 10 minutes discussion.

    * Tutorials (NEW for 2019)
      90 minutes in length.

    * Hackfest Sessions (NEW for 2019)
      1/2 day.


  Note that LSS NA is now a 3-day event. The third day will be a mix of
  tutorials and hackfest sessions:

    * Tutorial sessions should be focused on advanced Linux security defense
      topics within areas such as the kernel, compiler, and security-related
      libraries.  Priority will be given to tutorials created for this
      conference.

    * Hackfest proposals should aim to solve, or make significant progress on
      a well-defined problem in the Linux security defense space, and be
      supported by multiple community developers.

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
    https://events.linuxfoundation.org/events/linux-security-summit-north-america-2019/program/cfp/


DATES

  * CFP Close: May 31, 2019
  * CFP Notifications: June 17, 2019
  * Schedule Announced: June 19, 2019
  * Event: August 19-21, 2019


WHO SHOULD ATTEND

  We're seeking a diverse range of attendees, and welcome participation by
  people involved in Linux security development, operations, and research.

  The LSS is a unique global event which provides the opportunity to present
  and discuss your work or research with key Linux security community members
  and maintainers. It¢s also useful for those who wish to keep up with the
  latest in Linux security development, and to provide input to the
  development process.


WEB SITE

  https://events.linuxfoundation.org/events/linux-security-summit-north-america-2019/


TWITTER

  For event updates and announcements, follow:

    https://twitter.com/LinuxSecSummit
  

PROGRAM COMMITTEE

  The program committee for LSS 2019 is:

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


--1665246916-1292412540-1554849292=:16313
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--1665246916-1292412540-1554849292=:16313
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--1665246916-1292412540-1554849292=:16313--

