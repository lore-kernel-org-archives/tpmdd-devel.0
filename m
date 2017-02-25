From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device
 link /dev/tpms<n>
Date: Sat, 25 Feb 2017 12:04:49 -0500
Message-ID: <1488042289.2250.22.camel@HansenPartnership.com>
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
	<20170225002514.GA10605@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170225002514.GA10605-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-02-24 at 17:25 -0700, Jason Gunthorpe wrote:
> On Fri, Feb 24, 2017 at 06:43:27PM -0500, James Bottomley wrote:
> 
> > > It just seems confusing to call something a namespace that isn't 
> > > also a CLONE_NEW* option..
> > 
> > Well, there's namespace behaviour and then there's how you enter 
> > them.  We have namespace behaviour with the /dev/tpms<n> but the
> > namespace is entered on opening the device, even if the same 
> > process opens the device more than once.  So we have namespace 
> > behaviour with a non clone entry mechanism.  Since we're 
> > namespaceing a device, that seems to me to be the correct semantic.
> 
> I'm looking at it from a documentation perspective, look at
> namespaces(7) for instance

The term "namespace" is way broader than that

https://en.wikipedia.org/wiki/Namespace

> Lots of FD things have 'namespace behavior' but we don't call
> them namespaces..

At it's simplest, the virtual memory process model of UNIX is a
namespace.  That doesn't make the term inapplicable in this case.

> > > Stefan was concerned about information leakage via sysfs of TPM
> > > data, eg that a container could still touch the host's TPM. I
> > > wonder if device cgroup could be extended to block access to the
> > > sysfs directories containing a disallowed 'dev' ?
> > 
> > It doesn't need to.  The sysfs entries (those that ask the TPM
> > something) are surrounded by chip->tpm_mutex, so when it asks, we 
> > know all the spaces are context saved (i.e. the only TPM visible 
> > state is global not anything space local).
> 
> Yes, I understand that - the concern is that a container can still
> read the global state from tpm0 (eg ek/srk/pcrs) even if it is setup 
> to exclusively use a vtpm.

The TPM2 namespace as laid out by these patches only applies to objects
of type 80, 02 and 03.  The Storage and Endorsement seeds can't be
virtualized because they're one per physical instance.  81 objects
could be virtualised, but I don't really think we should. PCR
virtualisation is another whole interesting area of study.

>  device cgroup blocks access to the cdevs of tpm0 but not to the
> sysfs files.

What the device cgroup currently does for us and what it could do are
two different things.  It seems if it exported
__devcgroup_check_permission, we could use that as a check to gate the
sysfs file access.

> Maybe we should just make those debug files readable only by root and
> forget about that worry.
> 
> > > I was also wondering about kernel use from within the container -
> > > all kernel consumers are locked to physical tpm0.. But maybe the
> > > kernel can consult the right device cgroup to find an allowed
> > > TPM?
> > 
> > I'd use the device cgroup to determine what's allowable per 
> > container (i.e. what tpm you can see) then within the container I'd 
> > open the tpms<n> device ...
> 
> I am talking about using a situation like kernel IMA or keyring in 
> the container with a tpm that is not tpm0, eg a vtpm.

a vtpm appears as a tpm device so it can be controlled by the device
cgroup ... I think I'm not seeing the issue.

I should also say that discussion of mechanisms is usually the wrong
way to begin for OS virtualisation.  Almost anything can be virtualised
in a variety of ways, so to find the best way (or indeed if it should
be done at all) it's usually better to start with use cases.  So
instead of saying we need to virtualize the PCRs we should start with X
container has this requirement for attestation of its Y state.  Often
the best way simply is an extension of the multi user model for the
resource ... in this case no-one's really come up with one for PCRs, so
that might be the place to begin.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
