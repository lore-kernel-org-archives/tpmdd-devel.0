From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 2/3] tpm: replace dynamically
 allocated bios_dir with a static array
Date: Tue, 11 Oct 2016 21:12:11 +0300
Message-ID: <20161011181211.GB6900@intel.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475349926-476-3-git-send-email-jarkko.sakkinen@linux.intel.com>
	<57FBE39B.2030301@linux.vnet.ibm.com>
	<20161011112315.GB21688@intel.com>
	<20161011165355.GB6881@obsidianresearch.com>
	<57FD1F3C.6070705@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57FD1F3C.6070705-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 11, 2016 at 10:49:56PM +0530, Nayna wrote:
> 
> 
> On 10/11/2016 10:23 PM, Jason Gunthorpe wrote:
> >On Tue, Oct 11, 2016 at 02:23:15PM +0300, Jarkko Sakkinen wrote:
> >>>>+	chip->bios_dir[cnt] =
> >>>>  	    securityfs_create_file("ascii_bios_measurements",
> >>>>-				   S_IRUSR | S_IRGRP, tpm_dir,
> >>>>+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
> >>>>  				   (void *)&tpm_ascii_b_measurments_seqops,
> >>>>  				   &tpm_bios_measurements_ops);
> >
> >>>>+	if (is_bad(chip->bios_dir[cnt]))
> >>>>+		goto err;
> >
> >>>>+err:
> >>>>+	chip->bios_dir[cnt] = NULL;
> >>>
> >>>The updated patch looks fine.
> >>>Just, I am not sure if NULL assignment is needed.
> >>
> >>It's not needed.
> >
> >It is required to switch an ERR_PTR to NULL, see is_bad()
> 
> My understanding is that securityfs_remove() takes care of both NULL and
> ERR_PTR().
> 
> From securityfs_remove():
> 
>  if (!dentry || IS_ERR(dentry))
>                 return;

Right. I just checked from LXR. Seems weird that they have that kind of
special handling for IS_ERR. Checking for NULL is more usual.  I think I
keep setting NULL anyway if nothing else for robustness.  Anyway, thanks
for pointing this out.

> Thanks & Regards,
>   - Nayna

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
