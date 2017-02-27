From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device
 link /dev/tpms<n>
Date: Mon, 27 Feb 2017 06:55:54 -0800
Message-ID: <1488207354.3004.4.camel@HansenPartnership.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
	<20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
	<58AFD9C1.1050507@linux.vnet.ibm.com>
	<1487940829.2249.15.camel@HansenPartnership.com>
	<58B41184.7020200@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <58B41184.7020200-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-02-27 at 17:16 +0530, Nayna wrote:
> 
> On 02/24/2017 06:23 PM, James Bottomley wrote:
> > On Fri, 2017-02-24 at 12:29 +0530, Nayna wrote:
> > > 
> > > On 02/17/2017 12:55 AM, Jarkko Sakkinen wrote:
> > > > From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > > > 
> > > > Currently the tpm spaces are not exposed to userspace.  Make 
> > > > this exposure via a separate device, which can now be opened
> > > > multiple times because each read/write transaction goes 
> > > > separately via the space.
> > > > 
> > > > Concurrency is protected by the chip->tpm_mutex for each 
> > > > read/write transaction separately.  The TPM is cleared of all 
> > > > transient objects by the time the mutex is dropped, so there 
> > > > should be no interference between the kernel and userspace.
> > > 
> > > To understand, I have two questions:
> > > 
> > > 1. How would a userspace application using TPM know whether to 
> > > use /dev/tpm0 or /dev/tpms0 ?
> > 
> > Likely they can't use /dev/tpm0 becuase it will be root only, but 
> > the major indicator will be whether /dev/tpms0 exists or not.
> 
> Thanks James !!
> Currently, I see even /dev/tpms0 is also only root accessible. I did 
> see the discussion to make it 0666, and I understand adding command
> filtering is part of enabling /dev/tpms0 as all-accessible.

I don't think we'd ever do that from the kernel.  Accessibility would
be a userspace policy.

This is what I have on my system to make it accessible:

/etc/udev/rules.d/80-tpm-2.rules:
# tpm 2 devices need to be world readable
SUBSYSTEM=="tpms", ACTION=="add", MODE="0666"

> Sorry, I didn't understand when you said, "major indicator will be 
> whether /dev/tpms0" exists or not ? I mean in what case it might not 
> exist..

If the kernel is too old or you have a 1.2 TPM.

> > 
> > > 2. How would a userspace RM know to build on top of /dev/tpm0 or
> > > /dev/tpms0. And if it is built on top of /dev/tpms0, can there be
> > > issues with one RM on top of other RM.
> > 
> > There's a known problem with RMs in that they're not fully 
> > stackable, so I suspect the answer is that if tpms0 exists you 
> > won't use an RM, but this is currently an area of active research. 
> >  The other potential problem is that if you build a RM on tpm0 in 
> > userspace, it will fight with the kernel when the kernel uses
> > sessions.
> 
> Does it imply that there should be restriction to disallow any RM 
> specific commands from userspace on /dev/tpm0 ?

The only such command would be session or policy context save.  It's
debateable whether we should interfere.

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
