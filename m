From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Wed, 22 Feb 2017 15:56:12 -0500
Message-ID: <213d0ff2-e9c1-da0f-2eb5-c0ded070009d@linux.vnet.ibm.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
 <20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
 <58AC85F2.5000406@linux.vnet.ibm.com>
 <1487785159.2376.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1487785159.2376.27.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 2/22/2017 12:39 PM, James Bottomley wrote:
>
> Right at the moment the kernel use of tpm2 looks like
>
> acquire chip->tpm_mutex
> load key
> process key
> unload key
> release chip->tpm_mutex

The advantage to context save/ context load over load / flush
is that load requires the parent(s).  The parent chain may be long,
a parent may require authorization, or authorization may be impossible 
because PCRs are no longer in the correct state.

In TPM 1.2, there was a performance difference because load was an 
asymmetric key operation, but it's symmetric in TPM 2.0.

> When the kernel needs to use resources that persisted beyond it
> dropping the chip->tpm_mutex (say using policy or audit sessions),
> then it would need to become a customer of the RM.

BTW, use of an EK private key requires a policy session.



