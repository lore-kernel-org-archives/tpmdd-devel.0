From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs support,for TPM
 2.0 firmware event log
Date: Wed, 25 Jan 2017 16:22:45 -0500
Message-ID: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

> You do not need to send a new patch set version as long as this
> one gets peer tested. And it needs to be tested without hacks
> like plumbing TCPA with TPM 2.0 in QEMU. OF code paths needs to
> be peer tested to be more specific.
>
> For me the code itself looks good but I simply cannot take it in
> in the current situation.
>
> /Jarkko

Tested-by: Kenneth Goldman <kgold@linux.vnet.ibm.com>

I validated a firmware event log taken from a Power 8 against PCR 0-7 
values for the SHA-1 and SHA-256 banks from a Nuvoton TPM 2.0 chip on 
that same platform.
