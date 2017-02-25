From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH v2 6/7] tpm: expose spaces via a device
 link /dev/tpms<n>
Date: Fri, 24 Feb 2017 17:25:14 -0700
Message-ID: <20170225002514.GA10605@obsidianresearch.com>
References: <20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
 <20170223090917.jq7thil5ggjmagil@intel.com>
 <1487941328.2249.23.camel@HansenPartnership.com>
 <20170224173922.qwuhfxeitbyct52o@intel.com>
 <20170224181126.GC22491@obsidianresearch.com>
 <1487968155.2190.14.camel@HansenPartnership.com>
 <20170224205200.GA26547@obsidianresearch.com>
 <1487977260.2190.17.camel@HansenPartnership.com>
 <20170224232327.GA9126@obsidianresearch.com>
 <1487979807.2190.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487979807.2190.24.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 24, 2017 at 06:43:27PM -0500, James Bottomley wrote:

> > It just seems confusing to call something a namespace that isn't also
> > a CLONE_NEW* option..
> 
> Well, there's namespace behaviour and then there's how you enter them. 
>  We have namespace behaviour with the /dev/tpms<n> but the namespace is
> entered on opening the device, even if the same process opens the
> device more than once.  So we have namespace behaviour with a non clone
> entry mechanism.  Since we're namespaceing a device, that seems to me
> to be the correct semantic.

I'm looking at it from a documentation perspective, look at
namespaces(7) for instance

Lots of FD things have 'namespace behavior' but we don't call
them namespaces..

> > Stefan was concerned about information leakage via sysfs of TPM data,
> > eg that a container could still touch the host's TPM. I wonder if
> > device cgroup could be extended to block access to the sysfs
> > directories containing a disallowed 'dev' ?
> 
> It doesn't need to.  The sysfs entries (those that ask the TPM
> something) are surrounded by chip->tpm_mutex, so when it asks, we know
> all the spaces are context saved (i.e. the only TPM visible state is
> global not anything space local).

Yes, I understand that - the concern is that a container can still
read the global state from tpm0 (eg ek/srk/pcrs) even if it is setup to
exclusively use a vtpm. device cgroup blocks access to the cdevs of
tpm0 but not to the sysfs files.

Maybe we should just make those debug files readable only by root and
forget about that worry.

> > I was also wondering about kernel use from within the container -
> > all kernel consumers are locked to physical tpm0.. But maybe the
> > kernel can consult the right device cgroup to find an allowed TPM?
> 
> I'd use the device cgroup to determine what's allowable per container
> (i.e. what tpm you can see) then within the container I'd open the
> tpms<n> device ...

I am talking about using a situation like kernel IMA or keyring in the
container with a tpm that is not tpm0, eg a vtpm.

Jason
