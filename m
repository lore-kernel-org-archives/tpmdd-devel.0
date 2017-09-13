From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v2 1/4] tpm: ignore burstcount to improve
 tpm_tis send() performance.
Date: Wed, 13 Sep 2017 14:52:12 -0400
Message-ID: <3c418974-a4c7-518e-b218-f6373c10209e@linux.vnet.ibm.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-2-nayna@linux.vnet.ibm.com>
 <20170906161246.GA9747@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170906161246.GA9747@obsidianresearch.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On 9/6/2017 12:12 PM, Jason Gunthorpe wrote:
> 
> The problem with this approach is that the TPM could totally block
> the CPU for very long periods of time.
> 
> It seems very risky to enable..
> 

How would you characterize "very long"?

The TPM vendors confirm that they empty the FIFO at internal speeds that
are comparable to the bus speed.  Thus, any stall will be sub-usec.  Is
that an issue?

In addition, new TPMs have ever larger FIFO's, making stalls less likely
going forward.

