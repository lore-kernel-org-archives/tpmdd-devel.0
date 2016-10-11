From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RESEND 2/3] tpm: replace dynamically
 allocated bios_dir with a static array
Date: Tue, 11 Oct 2016 10:53:55 -0600
Message-ID: <20161011165355.GB6881@obsidianresearch.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475349926-476-3-git-send-email-jarkko.sakkinen@linux.intel.com>
	<57FBE39B.2030301@linux.vnet.ibm.com>
	<20161011112315.GB21688@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161011112315.GB21688-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 11, 2016 at 02:23:15PM +0300, Jarkko Sakkinen wrote:
> > >+	chip->bios_dir[cnt] =
> > >  	    securityfs_create_file("ascii_bios_measurements",
> > >-				   S_IRUSR | S_IRGRP, tpm_dir,
> > >+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
> > >  				   (void *)&tpm_ascii_b_measurments_seqops,
> > >  				   &tpm_bios_measurements_ops);

> > >+	if (is_bad(chip->bios_dir[cnt]))
> > >+		goto err;

> > >+err:
> > >+	chip->bios_dir[cnt] = NULL;
> > 
> > The updated patch looks fine.
> > Just, I am not sure if NULL assignment is needed.
> 
> It's not needed.

It is required to switch an ERR_PTR to NULL, see is_bad()

The original version that used a counter in chip did not need it.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
