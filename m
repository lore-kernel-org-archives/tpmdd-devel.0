From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH v2 6/7] tpm: expose spaces via a device
 link /dev/tpms<n>
Date: Fri, 24 Feb 2017 18:01:00 -0500
Message-ID: <1487977260.2190.17.camel@HansenPartnership.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
         <20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
         <20170223090917.jq7thil5ggjmagil@intel.com>
         <1487941328.2249.23.camel@HansenPartnership.com>
         <20170224173922.qwuhfxeitbyct52o@intel.com>
         <20170224181126.GC22491@obsidianresearch.com>
         <1487968155.2190.14.camel@HansenPartnership.com>
         <20170224205200.GA26547@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170224205200.GA26547@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: open list <linux-kernel@vger.kernel.org>, dhowells@redhat.com, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-02-24 at 13:52 -0700, Jason Gunthorpe wrote:
> On Fri, Feb 24, 2017 at 03:29:15PM -0500, James Bottomley wrote:
> > On Fri, 2017-02-24 at 11:11 -0700, Jason Gunthorpe wrote:
> > > On Fri, Feb 24, 2017 at 07:39:22PM +0200, Jarkko Sakkinen wrote:
> > > 
> > > > > I think therefore that tpmns<n> for TPM Namespace would be
> > > > > very
> > > > > appropriate.
> > > > 
> > > > Makes sense. We can go with tpmns.
> > > 
> > > When we have talked about TPM namespaces in the past it has been
> > > around the idea of restricting which TPMs the namespace has
> > > access 
> > > too and changing the 'kernel tpm' for that namespace.
> > 
> > Well, you know, nothing in the TPM Space code prevents us from
> > exposing
> > the namespace so that it could be shared.  However, I think the
> > namespace follows connect (device open) paradigm is pretty much the
> > behaviour everyone (including the kernel) wants, mostly because
> > TPM2
> > has such a tiny amount of resources that you're always dealing with
> > loadable keys meaning you don't really want to see anyone else's
> > volatile state.
> 
> I'm not arguing with that use model, I am asking what do you want to
> call the future feature that restricts which TPMs a process can view
> if you want to use the word namespace for the resource manager?

Well, as a glib answer, I'd say the TPM is a device, so the thing which
restricts device access to containers is the device cgroup ... that's
what we should be plugging into.  I'd have to look, but I suspect the
device cgroup basically operates on device node appearance, so it
should "just work"(tm).  I can explore when I'm back home.

James

> This is something Stephen B has been exploring in conjunction with
> vtpm. (eg restrict a container to only use a single vtpm and ban it
> from the system tpm)
> 
> Jason
> 
> ---------------------------------------------------------------------
> ---------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> 
