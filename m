From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: Use the right clean up after
	cdev_add completes
Date: Fri, 24 Feb 2017 22:59:50 +0200
Message-ID: <20170224205949.u63xb5qhqzd7lqtp@intel.com>
References: <20170223211914.GA12752@obsidianresearch.com>
	<20170224174354.w5e2v3nxntod72je@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170224174354.w5e2v3nxntod72je-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 24, 2017 at 07:43:54PM +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 23, 2017 at 02:19:14PM -0700, Jason Gunthorpe wrote:
> > Once cdev_add is done the device node is visible to user space and
> > could have been opened. Thus we have to go through the locking
> > process in tpm_del_char_device if device_add fails.
> > 
> > Fixes: 2c91ce8523a ("tpm: fix the rollback in tpm_chip_register()")
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> Pushed.

It would make easier to merge this with resource manager commits if
there was instead

void tpm_chip_shutdown(struct tpm_chip *chip)
{
	/* Make the driver uncallable. */
	down_write(&chip->ops_sem);
	if (chip->flags & TPM_CHIP_FLAG_TPM2)
		tpm2_shutdown(chip, TPM2_SU_CLEAR);
	chip->ops = NULL;
	up_write(&chip->ops_sem);
}

And you would call this instead of wiring into tpm_del_char_device.

I can update the commit.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
