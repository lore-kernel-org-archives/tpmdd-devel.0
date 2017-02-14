From: "Dr. Greg Wettstein" <gw@idfusion.org>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session exhaustion
Date: Tue, 14 Feb 2017 08:38:29 -0600
Message-ID: <20170214143829.GA28175@wind.enjellic.com>
References: <201702101003.v1AA3plF029882@wind.enjellic.com> <1486745163.2502.26.camel@HansenPartnership.com> <OFA049276F.2B32440E-ON852580C3.00742287-852580C3.00748E6B@notes.na.collabserv.com>
Reply-To: "Dr. Greg Wettstein" <gw@idfusion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OFA049276F.2B32440E-ON852580C3.00742287-852580C3.00748E6B@notes.na.collabserv.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, greg@enjellic.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 10, 2017 at 04:13:05PM -0500, Kenneth Goldman wrote:

Good morning to everyone.

> James Bottomley <James.Bottomley@HansenPartnership.com> wrote on 
> 02/10/2017 11:46:03 AM:
> 
> > > quote: 810 milliseconds
> > > verify signature: 635 milliseconds

For those who may be interested in this sort of thing I grabbed a few
minutes and ran these basic verification primitives against a Kaby
Lake system.

Average time for a quote is 600 milliseconds with a signature
verification clocking in at 100 milliseconds.  The latter is
consistent with what James found on his Skylake machine.

Latencies are still significant with things like container start
times.

> > Part of the way of reducing the latency is not to use the TPM for
> > things that don't require secrecy: 

> Agreed.  There are a few times one would verify a signature inside the 
> TPM,
> but they're far from mainstream:
> 
> 1 - Early in the boot cycle, when there's no crypto library.
> 
> 2 - When the crypto library doesn't support the required algorithm.
> 
> 3 - When a ticket is needed to prove to the TPM later that it verified
> the signature.

I don't think there is any doubt that running cryptographic primitives
in userspace is going to be faster then going to hardware.  Obviously
that also means there is no need for a TPM resource manager which has
been the subject of much discussion here.

The CoreOS paper makes significant reference to increased security
guarantees inherent in the use of a TPM.  Obviously whatever uses
those are will have the noted latency constraints.

We have extended our behavior measurement verifications to the
container level so we offer an explicit guarantee that a container has
not operated in a manner which is inconsistent with the intent of its
designer.  Getting the security guarantee we need requires that an
linkage to a hardware root of trust hence our concerns about hardware
latency.

Have a good day.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"UNIX is simple and coherent, but it takes a genious (or at any rate,
 a programmer) to understand and appreciate its simplicity."
                                -- Dennis Ritchie
                                   USENIX '87
