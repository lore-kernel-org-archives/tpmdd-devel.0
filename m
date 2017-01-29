From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix RC value check in
	tpm2_seal_trusted
Date: Sun, 29 Jan 2017 17:11:58 +0200
Message-ID: <20170129151158.6gr4oxluj4tprbca@intel.com>
References: <20170125210348.13790-1-jarkko.sakkinen@linux.intel.com>
	<20170125221245.GB713@obsidianresearch.com>
	<20170126112714.xvvvb72dybmfgitw@intel.com>
	<20170126183252.GA16502@obsidianresearch.com>
	<20170127064327.esussb6itanaqibq@intel.com>
	<20170127162416.GA32330@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170127162416.GA32330-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 27, 2017 at 09:24:16AM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 27, 2017 at 08:43:27AM +0200, Jarkko Sakkinen wrote:
> > On Thu, Jan 26, 2017 at 11:32:52AM -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 26, 2017 at 01:27:14PM +0200, Jarkko Sakkinen wrote:
> > > 
> > > > "The error code handling is bogus as any error code that has the bits
> > > > set that TPM_RC_HASH could pass. Implemented tpm2_rc_value() helper to
> > > > parse the error value from FMT0 and FMT1 error codes to use to check the
> > > > error so that these types of mistakes is prevented in the future."
> > > 
> > > Great thanks
> > > 
> > > Jason
> > 
> > Can I put your Reviewed-by? I would like to get this into 4.11.
> 
> I'm not up to speed on the TPM2 parsing, but it looks OK based on your
> description.
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> Jason

Thanks I applied this patch to master.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
