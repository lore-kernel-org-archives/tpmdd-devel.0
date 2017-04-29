From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Sat, 29 Apr 2017 14:52:34 +0300
Message-ID: <20170429115234.lwnllq3ostdjcvxe@intel.com>
References: <20170427182659.403-1-joshz@google.com>
	<20170428121226.7xnpfbxcjszrnz5d@intel.com>
	<20170428152748.GA32017@obsidianresearch.com>
	<CAHSjozC=1GgKazv5m19X6Oe321+mkMUFCfFBQ=_c7kPQ-WESDA@mail.gmail.com>
	<20170428184325.GA15327@obsidianresearch.com>
	<CAHSjozDRHbuHD6dPfTGMnF4j66hPV-_WiD22y5WRpawPFMQmfQ@mail.gmail.com>
	<20170428213905.GA19326@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170428213905.GA19326-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Apr 28, 2017 at 03:39:05PM -0600, Jason Gunthorpe wrote:
> On Fri, Apr 28, 2017 at 02:32:31PM -0700, Josh Zimmerman wrote:
> > On Fri, Apr 28, 2017 at 11:43 AM, Jason Gunthorpe
> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > > On Fri, Apr 28, 2017 at 11:27:16AM -0700, Josh Zimmerman wrote:
> > >> It sounds like there are several intertwined issues here. I'd like to
> > >> keep this patch relatively minimal, so here are my current thoughts on
> > >> a path forward:
> > >>
> > >> * Refactor references to chip->ops to go through tpm_try_get_ops, as
> > >> mentioned in the previous patch
> > >
> > > As I said, if you rely on the fact that sysfs does not exist for TPM2
> > > then this should already be done for the TPM2 case and an incremental
> > > later patch could solve this problem in sysfs to turn shutdown on for
> > > tpm1. As long as this logic is clearly documented it is probably an OK
> > > step for now.
> > 
> > This I'm not actually sure about: it seems that there are other places
> > than sysfs where chip->ops is referenced without being guarded by
> > tpm_try_get_ops. If we rely on just NULLing out chip->ops this could
> > be dangerous.  I'll look at sending a patch for this first.
> 
> If that is the case then we have an existing bug..
> 
> The only other user entry point is via the cdev, and those call
> try_get_ops around all calls down into the tpm code.
> 
> Everything coming in via the kapi must call tpm_chip_find_get, which
> does try_get_ops.

See the comment in tpm_sysfs_add_device. 

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
