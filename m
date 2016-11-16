From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: Check the bios_dir entry for NULL
 before accessing it
Date: Wed, 16 Nov 2016 14:06:33 -0800
Message-ID: <20161116220633.yfvpnvps3e222527@intel.com>
References: <1479304573-13601-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116203853.GA22708@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161116203853.GA22708-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 16, 2016 at 01:38:53PM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 16, 2016 at 08:56:13AM -0500, Stefan Berger wrote:
> > Check the bios_dir entry for NULL before accessing it. Currently
> > this crashes the driver when a TPM 2 is attached and the entries
> > are NULL.
> 
> Yep
> 
> >  	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
> > -		inode = d_inode(chip->bios_dir[i]);
> > -		inode_lock(inode);
> > -		inode->i_private = NULL;
> > -		inode_unlock(inode);
> > -		securityfs_remove(chip->bios_dir[i]);
> > +		if (chip->bios_dir[i]) {
> 
> Nope, this must be is_err_or_null, we store err ptrs in this array.

"
err:
        chip->bios_dir[cnt] = NULL;
"

There is assignment to NULL so this should be fine.

/JArko

------------------------------------------------------------------------------
