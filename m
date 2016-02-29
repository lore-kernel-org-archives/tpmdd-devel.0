From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 03/10] tpm: Provide strong locking for
 device removal
Date: Mon, 29 Feb 2016 12:54:01 -0700
Message-ID: <20160229195400.GA32380@obsidianresearch.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229192532.GB15042@obsidianresearch.com>
	<201602291949.u1TJn2Av025592@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602291949.u1TJn2Av025592-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 29, 2016 at 02:48:54PM -0500, Stefan Berger wrote:
>    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/29/2016
>    02:25:32 PM:
>    >
>    > On Mon, Feb 29, 2016 at 12:29:49PM -0500, Stefan Berger wrote:
>    > >   * the device. As the last step this function adds the chip to
>    > the list of TPM
>    > >   * chips available for in-kernel use.
>    > >   *
>    > > + * Once this function returns the driver call backs in 'op's will
>    not be
>    > > + * running and will no longer start.
>    > > + *
>    > >   * This function should be only called after the chip
>    initialization is
>    > >   * complete.
>    > >   */
>    >
>    > Not sure what happened here, but this hunk belongs with
>    > tpm_chip_unregister
>    That's where it is. The context 'tpm1_chip_unregister' the hunk shows
>    is from the function 'above'.

Eh?

https://github.com/stefanberger/linux/blob/63f0cd1bae930167d31bbe5d5779d40a277e91c5/drivers/char/tpm/tpm-chip.c#L311

/*
 * tpm_chip_register() - create a character device for the TPM chip
 * @chip: TPM chip to use.
 *
 * Creates a character device for the TPM chip and adds sysfs attributes for
 * the device. As the last step this function adds the chip to the list of TPM
 * chips available for in-kernel use.
 *
 * Once this function returns the driver call backs in 'op's will not be
 * running and will no longer start.
 *
 * This function should be only called after the chip initialization is
 * complete.
 */
int tpm_chip_register(struct tpm_chip *chip)
{

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
