From: "Dr. Greg Wettstein" <greg@enjellic.com>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session exhaustion
Date: Thu, 16 Feb 2017 14:06:42 -0600
Message-ID: <20170216200642.GA20942@wind.enjellic.com>
References: <201702101003.v1AA3plF029882@wind.enjellic.com> <1486745163.2502.26.camel@HansenPartnership.com> <OFA049276F.2B32440E-ON852580C3.00742287-852580C3.00748E6B@notes.na.collabserv.com> <20170214143829.GA28175@wind.enjellic.com> <71dc0e80-6678-a124-9184-1f93c8532d09@linux.vnet.ibm.com>
Reply-To: "Dr. Greg Wettstein" <greg@enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <71dc0e80-6678-a124-9184-1f93c8532d09@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 16, 2017 at 09:04:47AM -0500, Ken Goldman wrote:

Good morning to everyone, leveraging some time between planes.

> On 2/14/2017 9:38 AM, Dr. Greg Wettstein wrote:
> >
> >I don't think there is any doubt that running cryptographic primitives
> >in userspace is going to be faster then going to hardware.  Obviously
> >that also means there is no need for a TPM resource manager which has
> >been the subject of much discussion here.

> I don't understand that comment.
>
> The resource manager schedules user space access to the TPM.  It also
> handles swapping of objects in and out of the limited number of
> TPM slots.
> 
> Without a RM, either you'd have to permit only a single TPM connection,
> blocking all other connections, or you'd have different connections
> interfering with each other.

Yes, if multiple contexts of execution require access to the TPM a
resource manager is needed to arbitrate that access.

I think, however, that we are talking past one another a bit.

We design and build systems which implement autonomous
self-regulation.  As such we need a hardware based confirmation that
the machine is in a given behavioral state.  This requires that we
reference a hardware root of trust, ie. the TPM.

Depending on the assurance granularity requirements, that may mean a
high rate of TPM verifications.  When I noticed you and James talking
about 'cloud based' levels of transactions I was assuming you were
operating at transaction rates we build for, ie. 10-100's/second.
That didn't seem feasible given our hardware measurements on Skylake
and Kabylake based systems.

James had cited the CoreOS/Tectonic white paper as an example of TPM's
working at cloud scale.  Our conversation to date seems to indicate
that the accepted modality of security appers to be to do userspace
verification of container signatures.  Given the extensive dialogue in
the paper about using TPM's for security we had inadvertently believed
that container verifications were being pinned to current platform
status which didn't correlate with expected container start time
latencies.

Our behavioral assessment code is namespaced so a supervisory system
can make statements about the behavior of a container.  We have
concluded the only way that is possible is to use userspace TPM
implementations which can meet the necessary latency requirements.

Our point in all this is that it doesn't seem to make any sense to
implement anything in the kernel more then basic resource management.
If other 'virtualization' is needed, such as session state management
and the like, the community would seem to be served better by having a
solid userspace simulation environment, with appropriate hardware
security guarantees.  That would serve needs like re-keying support
for VPNaaS applications as well as high transaction rate environments,
ie. why load the kernel with code to virtualize a resource when a
'user' can just be given its own TPM2 instance.

Just as an aside, has anyone given any thought about TPM2 resource
management in things like TXT/tboot environments?  The current tboot
code makes a rather naive assumption that it can take a handle slot to
protect its platform verification secret.  Doing resource management
correctly will require addressing extra-OS environments such as this
which may have TPM2 state requirement issues.

Our take away from all this is that it doesn't seem that we need to
worry about the fact that someone may have invented TPM2 hardware
which is faster then what we are developing on.... :-)

Have a good weekend.

Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you ever teach a yodeling class, probably the hardest thing is to
 keep the students from just trying to yodel right off. You see, we build
 to that."
                                -- Jack Handey
                                   Deep Thoughts
