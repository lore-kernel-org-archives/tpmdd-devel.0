From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 10:12:41 -0600
Message-ID: <201701041612.v04GCfPK031525@wind.enjellic.com>
References: <kgoldman@us.ibm.com>
Reply-To: greg@enjellic.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Ken Goldman <kgoldman@us.ibm.com>
       "Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager" (Jan  3,  5:21pm)
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgoldman@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.netlinux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Jan 3,  5:21pm, Ken Goldman wrote:
} Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager

Good morning, I hope this note finds the day going well for everyone.

> On 1/3/2017 4:47 PM, Jason Gunthorpe wrote:
> >
> > I think we should also consider TPM 1.2 support in all of this, it is
> > still a very popular piece of hardware and it is equally able to
> > support a RM.

> I suspect that TPM 2.0 and TPM 1.2 are so different that there may
> be little or no code in common.
>
> My immediate need is for a 2.0 resource manager, since it's a gap in
> the technology, while 1.2 does have tcsd.

In the FWIW department.

I influence architecture and engineering for a company which builds
deterministically modeled and attested computing platforms for high
security assurance environments.  This entity actually builds systems
based on TPM1.2 and TPM2 hardware.  TPM2 prototypes were being
developed based on the simulator which came out of Ken's lab as soon
as it was first made available.

The kernel needs a resource manager.  Everyone needs to think VERY
hard and VERY, VERY carefully about what gets put into the kernel.  In
making a decision, put the ABSOLUTE smallest amount of code into the
kernel which allows various 'TPM2 personalities' to be implemented in
userspace and functionally verified and protected by the physical
instance.  The emergence of commodity TEE's (SGX, et.al) should be in
the back of everyone's mind as a factor in the roadmap.

Repeat incessantly to oneself, TPM1.2 and TPM2 are only similar by
virtue of sharing three ASCII characters.

DO NOT rush this process.  If we do not get this right we will
ultimately end up trying to shove something which is conceptually
worse then tss/tscd into the kernel.

Repeat incesssantly to oneself, policy does not belong in the kernel.

Pay homage to Ken, his TSS2 and TPM2 simulator work are beyond
excellent...

Greg

}-- End of excerpt from Ken Goldman

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"... you should really focus more on simplifying your life.  I
 actually spend most of my time finding ways to de-clog my brain."
                                -- Sarah Wettstein
                                   At the lake
