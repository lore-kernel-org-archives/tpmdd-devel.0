From: Ken Goldman <kgoldman@us.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm2-space: add handling for global
 session exhaustion
Date: Wed, 1 Feb 2017 17:17:16 -0500
Message-ID: <o6tmp7$ihn$1@blaine.gmane.org>
References: <1485563481.3229.39.camel@HansenPartnership.com>
 <1485563634.3229.43.camel@HansenPartnership.com>
 <20170129220219.oqv7fuofvcqy3gzh@intel.com>
 <1485905084.3199.114.camel@HansenPartnership.com>
 <20170201102906.y67owrhw4clvlge7@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170201102906.y67owrhw4clvlge7@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 2/1/2017 5:29 AM, Jarkko Sakkinen wrote:
>
> I've been observing the discussion that you've been going with Ken and
> I've started to think: "why this needs to be put into kernel?" We still
> have quite narrow perspective of TPM 2.0 applications. It's so much more
> capable than TPM 1.2 that it will be definitely have a wider set of
> use cases.

Just session swapping, or the whole resource manager?

Session swapping has to be in the kernel because the TPM typically only 
has 3 session slots.  Something has to do the swapping.

The RM is far better in the kernel because the kernel also needs access 
to the TPM, keys and sessions.  If a user space RM fills all the slots, 
the kernel has to either flush an application's resource (bad) or block 
(really bad).

Putting the RM in the kernel is IMHO the right architecture.



