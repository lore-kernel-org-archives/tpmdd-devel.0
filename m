From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device link /dev/tpms<n>
Date: Fri, 24 Feb 2017 15:29:15 -0500
Message-ID: <1487968155.2190.14.camel@HansenPartnership.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
         <20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
         <20170223090917.jq7thil5ggjmagil@intel.com>
         <1487941328.2249.23.camel@HansenPartnership.com>
         <20170224173922.qwuhfxeitbyct52o@intel.com>
         <20170224181126.GC22491@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170224181126.GC22491@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, dhowells@redhat.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-02-24 at 11:11 -0700, Jason Gunthorpe wrote:
> On Fri, Feb 24, 2017 at 07:39:22PM +0200, Jarkko Sakkinen wrote:
> 
> > > I think therefore that tpmns<n> for TPM Namespace would be very
> > > appropriate.
> > 
> > Makes sense. We can go with tpmns.
> 
> When we have talked about TPM namespaces in the past it has been
> around the idea of restricting which TPMs the namespace has access 
> too and changing the 'kernel tpm' for that namespace.

Well, you know, nothing in the TPM Space code prevents us from exposing
the namespace so that it could be shared.  However, I think the
namespace follows connect (device open) paradigm is pretty much the
behaviour everyone (including the kernel) wants, mostly because TPM2
has such a tiny amount of resources that you're always dealing with
loadable keys meaning you don't really want to see anyone else's
volatile state.

James



