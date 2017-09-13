From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 1/4] tpm: ignore burstcount to improve tpm_tis send()
 performance.
Date: Wed, 13 Sep 2017 16:10:07 -0700
Message-ID: <20170913231007.22yb57hlx45aznt6@linux.intel.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-2-nayna@linux.vnet.ibm.com>
 <20170912222010.ltm76m5vy2kupydi@linux.intel.com>
 <CB43D154-BE47-4016-AE2D-C372AFCAD5F9@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CB43D154-BE47-4016-AE2D-C372AFCAD5F9@gmx.de>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 13, 2017 at 11:39:03AM -0700, Peter Huewe wrote:
> 
> 
> Am 12. September 2017 17:45:08 GMT-07:00 schrieb Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>:
> >On Wed, Sep 06, 2017 at 08:56:36AM -0400, Nayna Jain wrote:
> >> The TPM burstcount status indicates the number of bytes that can
> >> be sent to the TPM without causing bus wait states.  Effectively,
> >> it is the number of empty bytes in the command FIFO. Further,
> >> some TPMs have a static burstcount, when the value remains zero
> >> until the entire FIFO is empty.
> >> 
> >> This patch adds an optimization to check for burstcount only once.
> >> And if it is valid, it writes all the bytes at once, permitting
> >> wait states. The performance of a 34 byte extend on a TPM 1.2 with
> >> an 8 byte burstcount improved from 41 msec to 14 msec.
> >> 
> >> This functionality is enabled only by passing module
> >> parameter ignore_burst_count=1. By default, this parameter
> >> is disabled.
> >> 
> >> After this change, performance on a TPM 1.2 with an 8 byte
> >> burstcount for 1000 extends improved from ~41sec to ~14sec.
> >> 
> >> Suggested-by: Ken Goldman <kgold@linux.vnet.ibm.com> in
> >> conjunction with the TPM Device Driver work group.
> >> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> >> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >> ---
> >>  Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
> >>  drivers/char/tpm/tpm_tis_core.c                 | 24
> >+++++++++++++++++++++---
> >>  2 files changed, 29 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/Documentation/admin-guide/kernel-parameters.txt
> >b/Documentation/admin-guide/kernel-parameters.txt
> >> index 4e303be83df6..3c59bb91e1ee 100644
> >> --- a/Documentation/admin-guide/kernel-parameters.txt
> >> +++ b/Documentation/admin-guide/kernel-parameters.txt
> >> @@ -1465,6 +1465,14 @@
> >>  			mode generally follows that for the NaN encoding,
> >>  			except where unsupported by hardware.
> >>  
> >> +	ignore_burst_count [TPM_TIS_CORE]
> >> +			tpm_tis_core driver queries for the burstcount before
> >> +			every send call in a loop. However, it causes delay to
> >> +			the send command for TPMs with low burstcount value.
> >> +			Setting this value to 1, will make driver to query for
> >> +			burstcount only once in the loop to improve the
> >> +			performance. By default, its value is set to 0.
> >> +
> >>  	ignore_loglevel	[KNL]
> >>  			Ignore loglevel setting - this will print /all/
> >>  			kernel messages to the console. Useful for debugging.
> >> diff --git a/drivers/char/tpm/tpm_tis_core.c
> >b/drivers/char/tpm/tpm_tis_core.c
> >> index 63bc6c3b949e..6b9bf4c4d434 100644
> >> --- a/drivers/char/tpm/tpm_tis_core.c
> >> +++ b/drivers/char/tpm/tpm_tis_core.c
> >> @@ -31,6 +31,11 @@
> >>  #include "tpm.h"
> >>  #include "tpm_tis_core.h"
> >>  
> >> +static bool ignore_burst_count = false;
> >> +module_param(ignore_burst_count, bool, 0444);
> >> +MODULE_PARM_DESC(ignore_burst_count,
> >> +		"Ignore burstcount value while writing data");
> >> +
> >>  /* Before we attempt to access the TPM we must see that the valid
> >bit is set.
> >>   * The specification says that this bit is 0 at reset and remains 0
> >until the
> >>   * 'TPM has gone through its self test and initialization and has
> >established
> >> @@ -256,6 +261,7 @@ static int tpm_tis_send_data(struct tpm_chip
> >*chip, u8 *buf, size_t len)
> >>  {
> >>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> >>  	int rc, status, burstcnt;
> >> +	int sendcnt;
> >>  	size_t count = 0;
> >>  	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
> >>  
> >> @@ -271,19 +277,31 @@ static int tpm_tis_send_data(struct tpm_chip
> >*chip, u8 *buf, size_t len)
> >>  	}
> >>  
> >>  	while (count < len - 1) {
> >> +
> >> +		/*
> >> +		 * Get the initial burstcount to ensure TPM is ready to
> >> +		 * accept data, even when waiting for burstcount is disabled.
> >> +		 */
> >>  		burstcnt = get_burstcount(chip);
> >>  		if (burstcnt < 0) {
> >>  			dev_err(&chip->dev, "Unable to read burstcount\n");
> >>  			rc = burstcnt;
> >>  			goto out_err;
> >>  		}
> >> -		burstcnt = min_t(int, burstcnt, len - count - 1);
> >> +
> >> +		if (ignore_burst_count)
> >> +			sendcnt = len - 1;
> >> +		else
> >> +			sendcnt = min_t(int, burstcnt, len - count - 1);
> >> +
> >>  		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
> >> -					 burstcnt, buf + count);
> >> +					 sendcnt, buf + count);
> >>  		if (rc < 0)
> >>  			goto out_err;
> >>  
> >> -		count += burstcnt;
> >> +		count += sendcnt;
> >> +		if (ignore_burst_count)
> >> +			continue;
> >>  
> >>  		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
> >>  					&priv->int_queue, false) < 0) {
> >> -- 
> >> 2.13.3
> >> 
> >
> >Makes sense to discuss whether to have the kernel command-line
> >parameter or not before applying this.
> >
> >To fuel the discussion, alternative to this would be:
> >
> >1. Have this always on i.e. no command-line parameter.
> >2. If someone yells, we add the command-line parameter later on.
> >
> According to what I've read in the tcg ddwg group this patch should
> not cause problems on _sane_ tpms.
> 
> I'm not 100%convinced that all tpms are sane all the time, but I think
> we do not want yet another cmdline parameter.
> 
> So if we want to pull it in (and ddwg does not see an issue, so yes)
> it should be on by default, without a kernel parameter.
> 
> If there is a kernel parameter, then it should only be one called
> "failsafe" - which includes the force behavior and maybe the "broken"
> tpm path.
> 
> But I agree with Alex, every additonal code path reduces testing coverage.
> 
> 
> We would be happy to test a "default on" patch.
> 
> Peter
> 
> >/Jarkko

I'm starting to dilate to this direction.

It is hard to believe that any such TPM would be in active use anywhere
assuming that there exist a TPM where this causes issues. This combined
to the assumption that you would run the latest mainline on it makes it
a pretty insignificant scenario.

/Jarkko
