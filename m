Return-Path: <tpmdd-devel-bounces@lists.sourceforge.net>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0703C433F5
	for <tpmdd-devel@archiver.kernel.org>; Fri, 18 Mar 2022 23:04:16 +0000 (UTC)
Received: from [127.0.0.1] (helo=sfs-ml-2.v29.lw.sourceforge.com)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtp (Exim 4.94.2)
	(envelope-from <tpmdd-devel-bounces@lists.sourceforge.net>)
	id 1nVLde-0000sD-RK; Fri, 18 Mar 2022 23:04:05 +0000
Received: from [172.30.20.202] (helo=mx.sourceforge.net)
 by sfs-ml-2.v29.lw.sourceforge.com with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <jmorris@namei.org>) id 1nVLdd-0000s6-8s
 for tpmdd-devel@lists.sourceforge.net; Fri, 18 Mar 2022 23:04:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Type:MIME-Version:References:Message-ID:
 In-Reply-To:Subject:cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
 :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=BZqDGcl4o9Xdi1tmgY5xW03TbMhpKwFz2zY2lit+duU=; b=IN3Sn2AllDttHQRGX3jzHB/2oA
 96bVgpjGRRMi8/0KR2g70yEnrCggsXm8Hj18iDgwI3AgT3AUZ9qVN3dsHb5arP3Zs+D0YQtYeQT3p
 i1S66/N6kJnmjq7tmaO0LyNPW9YcY+6gurWZR+NqB1SP0N4g9d8VXW9cDLz0JKyCFUi0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Type:MIME-Version:References:Message-ID:In-Reply-To:Subject:cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=BZqDGcl4o9Xdi1tmgY5xW03TbMhpKwFz2zY2lit+duU=; b=R3vKPegS9uLcWy0ye4erqdk0kc
 TGLozEjId+hOF+Ea2PH702KK8tXD5Y4Nz6EfaJxPFstXT/mvcvUgLj2kCRMn1t2iLrdwH1b4NclAx
 hJ4tiYDFe1laqxsje9IdZjPnjyC5wPvLHNeBhk+Ga4eW7OZaeGNfPKgYgmf0kKhSB7FA=;
Received: from namei.org ([65.99.196.166] helo=mail.namei.org)
 by sfi-mx-1.v28.lw.sourceforge.com with esmtps
 (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.94.2)
 id 1nVLdZ-003XUA-3e
 for tpmdd-devel@lists.sourceforge.net; Fri, 18 Mar 2022 23:04:03 +0000
Received: from localhost (localhost [127.0.0.1])
 by mail.namei.org (Postfix) with ESMTPS id 2EAFA54E;
 Fri, 18 Mar 2022 22:31:55 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 2EAFA54E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
 t=1647642715; bh=BZqDGcl4o9Xdi1tmgY5xW03TbMhpKwFz2zY2lit+duU=;
 h=Date:From:To:cc:Subject:In-Reply-To:References:From;
 b=0TadzwHr15LTwfizUFip6H4pI3PAx0t6kiX1pSKaHZtrSeiTKZ5755Fp9HWxrgvKf
 4tcy3l8Px/hTrLtlWSPlDj/76pw8p5ovHGT01GTBIurqnG0tBB5aHeOmv4fbMasoMa
 FEjy5O3FKGFA1pMOWJNUW2KQeAcL7T/rymjP59w0=
Date: Sat, 19 Mar 2022 09:31:55 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
In-Reply-To: <3e5acc67-829-fafb-c82-833fc22b35a@namei.org>
Message-ID: <3f2d2915-b2b9-1646-d0e9-192296327633@namei.org>
References: <3e5acc67-829-fafb-c82-833fc22b35a@namei.org>
MIME-Version: 1.0
X-Headers-End: 1nVLdZ-003XUA-3e
Subject: Re: [tpmdd-devel] [ANNOUNCE][CFP] Linux Security Summit North
 America 2022
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

On Tue, 8 Feb 2022, James Morris wrote:

>   * Event:                September 23-24

Correction: This should be 23-24 June per the top of the email.


-- 
James Morris
<jmorris@namei.org>



_______________________________________________
tpmdd-devel mailing list
tpmdd-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
