From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Sun, 12 Feb 2017 15:29:45 -0500
Message-ID: <14cb6207-7591-e10a-2d73-b82ede467e40@linux.vnet.ibm.com>
References: <201702101003.v1AA3plF029882@wind.enjellic.com>
 <1486745163.2502.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1486745163.2502.26.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 2/10/2017 11:46 AM, James Bottomley wrote:
> On Fri, 2017-02-10 at 04:03 -0600, Dr. Greg Wettstein wrote:
>> On Feb 9, 11:24am, James Bottomley wrote:

>> quote: 810 milliseconds
>> verify signature: 635 milliseconds
> ...
>
> Part of the way of reducing the latency is not to use the TPM for
> things that don't require secrecy: container signature verification is
> one such because the container is signed with a private key to which
> ...

Agreed.  There are a few times one would verify a signature inside the 
TPM, but they're far from mainstream:

1 - Early in the boot cycle, when there's no crypto library.

2 - When the crypto library doesn't support the required algorithm.

3 - When a ticket is needed to prove to the TPM later that it verified
the signature.


