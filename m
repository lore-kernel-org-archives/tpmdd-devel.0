From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 1/2] tpm: Issue a TPM2_Shutdown for
 TPM2 devices.
Date: Tue, 20 Jun 2017 00:21:22 +0200
Message-ID: <20170619222122.55m5goanayw3gkeo@linux.intel.com>
References: <20170616172531.28464-1-joshz@google.com>
	<1497828091.2552.6.camel@linux.intel.com>
	<1497828407.2552.8.camel@linux.intel.com>
	<20170619155122.GA10188@obsidianresearch.com>
	<20170619221220.kfk5dldducxvou5b@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170619221220.kfk5dldducxvou5b-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jun 20, 2017 at 12:12:20AM +0200, Jarkko Sakkinen wrote:
> On Mon, Jun 19, 2017 at 09:51:22AM -0600, Jason Gunthorpe wrote:
> > On Mon, Jun 19, 2017 at 01:26:47AM +0200, Jarkko Sakkinen wrote:
> >  
> > > Feels weird that you have to call framework functions like that in the
> > > driver. You must have brilliant reason to do so and that should be very
> > > well documented in the code. This is terrible...
> > 
> > This was all discussed on the list. It the way these callbacks work,
> > the higher levels in the callback stack call the lower levels, this
> > allows each level the place the next level's callback properly, eg do
> > things before/after as necessary.
> > 
> > Jason
> 
> I tried to look up for discussion from the patchwork. These had appeared
> in v6. I guess I have to backtrack the discussions from my maidir
> because I honestly don't understand why class shutdown would have to
> call bus callback explicitly. There's nothing in the commit message
> about this nor  is there any comment in the code.
> 
> This must be fairly recent development that I've missed?
> 
> /Jarkko

Found it:

"Looking at this closer, now you definately have to change the TPM
patch to call through to the other shutdown methods. We can say
current TPM drivers have no driver->shutdown, but we cannot be sure
about the bus->shutdown, so may as well call both from tpm's
class->shutdown.

I would say this should be done after the tpm2_shutdown completes as
lower level shutdowns could remove register access.

Jason"

And makes sense.

This patch is a NAK for two reasons:

1. No comment explaining this.
2. Patches are broken and they are in wrong order and cover letter is
   missing

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
