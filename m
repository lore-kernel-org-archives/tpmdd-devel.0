Return-Path: <tpmdd-devel-bounces@lists.sourceforge.net>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258CAC433EF
	for <tpmdd-devel@archiver.kernel.org>; Mon,  7 Feb 2022 22:52:47 +0000 (UTC)
Received: from [127.0.0.1] (helo=sfs-ml-4.v29.lw.sourceforge.com)
	by sfs-ml-4.v29.lw.sourceforge.com with esmtp (Exim 4.94.2)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1nHCsB-0006ml-Aj; Mon, 07 Feb 2022 22:52:38 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-4.v29.lw.sourceforge.com with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <jmorris@namei.org>) id 1nHCs8-0006mf-Vw
 for tpmdd-devel@lists.sourceforge.net; Mon, 07 Feb 2022 22:52:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:cc:To:
 From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=0BY/V/NIgDIevFQdF+wBys4ty26sYhLszDEPcdK7lds=; b=VJNegQUaCgioptlNLWv02umQfj
 RgJ856oHMzdBudLU9DKHOr5jQOIgV+Xss7Eofe81i3dM2dKhBE+uPZzf2QBznqpmP4iXajSCkU7h7
 UmdrmBI/DlDlrm/aWZrQ3W1gbXTjScOHy7W0ADmzW9cUV4zKAk7ZBSthnOvuWiT1qAEo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:Message-ID:Subject:cc:To:From:Date:Sender:
 Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
 :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=0BY/V/NIgDIevFQdF+wBys4ty26sYhLszDEPcdK7lds=; b=E
 IImobg8XrLYHA9f8CB68KV1T0UktMVIdNt3e8pXuUHYf1J8kf9H30IbxPWZJj+GPK0NYc3AJ/k2fN
 fOqlmdAUu3uVErhgn9Lblp43U+4D1XkfbGr5CVxBwU1Er8jIUrgIzefPvfvzXyaRdA5fBNWtxPJ/q
 Mxv0TezhuR5iEIQg=;
Received: from namei.org ([65.99.196.166] helo=mail.namei.org)
 by sfi-mx-2.v28.lw.sourceforge.com with esmtps
 (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.94.2)
 id 1nHCs5-0004pE-OC
 for tpmdd-devel@lists.sourceforge.net; Mon, 07 Feb 2022 22:52:35 +0000
Received: from localhost (localhost [127.0.0.1])
 by mail.namei.org (Postfix) with ESMTPS id 7235C424;
 Mon,  7 Feb 2022 22:24:49 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 7235C424
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
 t=1644272689; bh=0BY/V/NIgDIevFQdF+wBys4ty26sYhLszDEPcdK7lds=;
 h=Date:From:To:cc:Subject:From;
 b=1XdVNc4ggTblHTpzOBwW/SI45jMQCePu37bX4zNovZerTp2MOne46L47WP/LiNVcQ
 421qWS3h/u+x/sEhDPYdUVx6j1/HOySQeMLRET18Vh6cPbgvFQVHx9SLn8H3N4ca4H
 X2un323LTy/67B8EZaOPlHzv6fGuyaWcO3Gq0NjY=
Date: Tue, 8 Feb 2022 09:24:49 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Message-ID: <3e5acc67-829-fafb-c82-833fc22b35a@namei.org>
MIME-Version: 1.0
X-Headers-End: 1nHCs5-0004pE-OC
Subject: [tpmdd-devel] [ANNOUNCE][CFP] Linux Security Summit North America
 2022
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

==============================================================================
                   ANNOUNCEMENT AND CALL FOR PARTICIPATION

                   LINUX SECURITY SUMMIT NORTH AMERICA 2022
                             
                                 23-24 June
                           Austin, Texas & Virtual
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
    https://events.linuxfoundation.org/linux-security-summit-north-america/


Note that for 2022, we are returning to having both North American and
European events (LSS-EU will be held in September).
 

LSS-NA DATES
 
  * CFP close:            March 30
  * CFP notifications:    April 15
  * Schedule announced:   April 19
  * Event:                September 23-24

WHO SHOULD ATTEND
 
We're seeking a diverse range of attendees and welcome participation by
people involved in Linux security development, operations, and research.
 
LSS is a unique global event that provides the opportunity to present and
discuss your work or research with key Linux security community members and
maintainers.  It's also useful for those who wish to keep up with the latest
in Linux security development and to provide input to the development
process.

WEB SITE

    https://events.linuxfoundation.org/linux-security-summit-north-america/

TWITTER

  For event updates and announcements, follow:

    https://twitter.com/LinuxSecSummit
  
    #linuxsecuritysummit

PROGRAM COMMITTEE

  The program committee for LSS 2021 is:

    * James Morris, Microsoft
    * Serge Hallyn, Cisco
    * Paul Moore, Microsoft
    * Stephen Smalley, NSA
    * Elena Reshetova, Intel
    * John Johansen, Canonical
    * Kees Cook, Google
    * Casey Schaufler, Intel
    * Mimi Zohar, IBM
    * David A. Wheeler, Linux Foundation

  The program committee may be contacted as a group via email:
    lss-pc () lists.linuxfoundation.org

-- 




_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
