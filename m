From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] tpm: add tpm 2.0 support to nuvoton
 chips on i2c bus
Date: Wed, 23 Mar 2016 10:38:36 -0600
Message-ID: <20160323163836.GA16283@obsidianresearch.com>
References: <510d6333a3fc49b297a82bd69c89a05e@NTILML02.nuvoton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510d6333a3fc49b297a82bd69c89a05e-qcV2a/0u7bE377JQJD9m/laTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org
Cc: shmulik.hager-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Eyal.Cohen-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 20, 2016 at 08:02:58AM +0000, andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org wrote:
 
>  /* read burstCount field from TPM_STS register
> - * return -1 on fail to read */
> + * return -1 on fail to read
> +*/

Put all these random style changes in a dedicated patch.

> -if (tpm_get_timeouts(chip))
> -return -ENODEV;
> +rc = tpm2_probe(chip);
> +if (rc)
> +return rc;

Something is broken with your mailer, all the whitespace is gone

> -if (tpm_do_selftest(chip))
> +if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +chip->vendor.timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
> +chip->vendor.timeout_b = msecs_to_jiffies(TPM2_TIMEOUT_B);
> +chip->vendor.timeout_c = msecs_to_jiffies(TPM2_TIMEOUT_C);
> +chip->vendor.timeout_d = msecs_to_jiffies(TPM2_TIMEOUT_D);
> +chip->vendor.duration[TPM_SHORT] =
> +msecs_to_jiffies(TPM2_DURATION_SHORT);
> +chip->vendor.duration[TPM_MEDIUM] =
> +msecs_to_jiffies(TPM2_DURATION_MEDIUM);
> +chip->vendor.duration[TPM_LONG] =
> +msecs_to_jiffies(TPM2_DURATION_LONG);
> +
> +rc = tpm2_do_selftest(chip);
> +if (rc == TPM2_RC_INITIALIZE) {
> +if (tpm2_startup(chip, TPM2_SU_CLEAR))
> +return -ENODEV;
> +
> +rc = tpm2_do_selftest(chip);
> +}
> +
> +} else {
> +if (tpm_get_timeouts(chip))
> +return -ENODEV;
> +
> +rc = tpm_do_selftest(chip);
> +}
> +
> +if (rc)

I don't want to see this pattern open coded into drivers. Now is
probably the time to pull the startup sequence of
startup/selftest/get_timeouts/etc into the core code.

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
