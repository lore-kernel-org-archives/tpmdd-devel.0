From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] tpmdd fixes for 4.13
Date: Tue, 20 Jun 2017 11:22:00 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1706201121401.10628@namei.org>
References: <1497833925.14670.3.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-843631732-1497921720=:10628"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1497833925.14670.3.camel@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-843631732-1497921720=:10628
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 19 Jun 2017, Jarkko Sakkinen wrote:

> Hi
> 
> Here are thpdates for 4.13.
> 
> Major changes:
> 
> - Releasing and relinquishing of locality in tpm_vtpm_proxy for each
>   command/response sequence.
> - Consolidating platform and ACPI driver in tpm_tis.
> - Sanitize endian conversions for TPM 1.2 commands i.e. call
>   cpu_to_be32() in place when required. Do not have it in the constant
>   definition.

Pulled to -next, thanks.


-- 
James Morris
<jmorris@namei.org>

--1665246916-843631732-1497921720=:10628--
