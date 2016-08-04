From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Latest tip of the tree issues
Date: Thu, 4 Aug 2016 20:08:19 +0300
Message-ID: <20160804170819.GB14542@intel.com>
References: <OF39017581.C0F42D48-ON00258005.0054AEBE-85258005.00562C33@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF39017581.C0F42D48-ON00258005.0054AEBE-85258005.00562C33-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Stefan,

Since this patch is not going to the next release (it's not merged into
next nor has pull request containing it been sent) can this hold until
next week when I'm back from my four week leave? Thanks.

I'll prioritize this right after I've got through pile of emails early
next week. Thanks and sorry for the inconvience. Next branch should be
ok.


/Jarkko
On Thu, Aug 04, 2016 at 11:40:48AM -0400, Stefan Berger wrote:
>    Jarkko,
> 
>      when building the latest tree I have the following two issues when
>    building with modules:
> 
>    - missing exported symbols tpm_getcap and tpm2_get_tpm_pt. See the patch
>    below that should be squashed into the patch(es) that introduced the
>    problem (so one can bisect)
> 
>    - the probing of TPM 1.2 doesn't work anymore ; the bad patch seems to be
>    the tip:
> 
>    commit 783fa18d7bb7bac20b8591cf575418fce31dd397
>    Author: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>    Date:   Fri Jun 17 13:12:20 2016 +0200
> 
>        tpm: use tpm_pcr_read_dev() in tpm_do_selftest()
>       
>        Instead of a  ad-hoc protocol message construction it is better to
>        call tpm_pcr_read_dev().
>       
>        Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>        Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
>    # dmesg | grep tpm
>    [    4.385205] tpm_tis 00:05: 1.2 TPM (device-id 0x1, rev-id 1)
>    [    4.424537] tpm tpm0: TPM self test failed
>    [    4.426630] tpm_tis: probe of 00:05 failed with error -14
> 
>    The reason for this is that rc in the following is 0.
> 
>           do {
>                    /* Attempt to read a PCR value */
>                    rc = tpm_pcr_read_dev(chip, 0, dummy);
> 
>    Looking at tpm_pcr_read_dev, returning 0 is quite ok.
> 
>    Stefan
> 
>    diff --git a/drivers/char/tpm/tpm-interface.c
>    b/drivers/char/tpm/tpm-interface.c
>    index f43cc3f..3722fc0 100644
>    --- a/drivers/char/tpm/tpm-interface.c
>    +++ b/drivers/char/tpm/tpm-interface.c
>    @@ -458,6 +458,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32
>    subcap_id, cap_t *cap,
>                    *cap = tpm_cmd.params.getcap_out.cap;
>            return rc;
>     }
>    +EXPORT_SYMBOL_GPL(tpm_getcap);
>     
>     #define TPM_ORD_STARTUP cpu_to_be32(153)
>     #define TPM_ST_CLEAR cpu_to_be16(1)
>    diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
>    index e1db404..499f405 100644
>    --- a/drivers/char/tpm/tpm2-cmd.c
>    +++ b/drivers/char/tpm/tpm2-cmd.c
>    @@ -707,6 +707,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32
>    property_id,  u32 *value,
>     
>            return rc;
>     }
>    +EXPORT_SYMBOL_GPL(tpm2_get_tpm_pt);
>     
>     #define TPM2_STARTUP_IN_SIZE \
>            (sizeof(struct tpm_input_header) + \

------------------------------------------------------------------------------
