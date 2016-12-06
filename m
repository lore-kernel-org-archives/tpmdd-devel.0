From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] tpm: add kdoc for tpm_transmit and
 tpm_transmit_cmd
Date: Tue, 6 Dec 2016 12:11:08 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B543378A2@hasmsx108.ger.corp.intel.com>
References: <1479895454-15076-1-git-send-email-tomas.winkler@intel.com>
	<1479895454-15076-2-git-send-email-tomas.winkler@intel.com>
	<20161203153236.jmulnrlvoitvjnhq@intel.com>
	<584681FB.2070708@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <584681FB.2070708-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Nayna [mailto:nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org]
> Sent: Tuesday, December 06, 2016 11:17
> To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; Winkler, Tomas
> <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [tpmdd-devel] [PATCH v2 1/4] tpm: add kdoc for tpm_transmit and
> tpm_transmit_cmd
> 
> 
> 
> On 12/03/2016 09:02 PM, Jarkko Sakkinen wrote:
> > On Wed, Nov 23, 2016 at 12:04:11PM +0200, Tomas Winkler wrote:
> >> Functions tpm_transmit and transmit_cmd are referenced from other
> >> functions kdoc hence deserve documentation.
> >>
> >> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Do you mind if I change TPM_DIGEST_SIZE to SHA1_DIGEST_SIZE?
> >
> > I'm looking to drop TPM_DIGEST_SIZE eventually.
> 
> I was thinking if we should use SHA1_DIGEST_SIZE directly from <crypto/sha.h>,
> or probably <crypto/hash_info.h>

Probably the best approach 
Tomas
> 
> >
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > /Jarkko
> >
> >> ---
> >> V2: Add some missing '.'
> >>   drivers/char/tpm/tpm-interface.c | 33 ++++++++++++++++++++++++++++--
> ---
> >>   1 file changed, 28 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/char/tpm/tpm-interface.c
> >> b/drivers/char/tpm/tpm-interface.c
> >> index a2688ac2b48f..769d8b0d31a3 100644
> >> --- a/drivers/char/tpm/tpm-interface.c
> >> +++ b/drivers/char/tpm/tpm-interface.c
> >> @@ -328,8 +328,17 @@ unsigned long tpm_calc_ordinal_duration(struct
> tpm_chip *chip,
> >>   }
> >>   EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
> >>
> >> -/*
> >> - * Internal kernel interface to transmit TPM commands
> >> +/**
> >> + * tmp_transmit - Internal kernel interface to transmit TPM commands.
> >> + *
> >> + * @chip: TPM chip to use
> >> + * @buf: TPM command buffer
> >> + * @bufsiz: length of the TPM command buffer
> >> + * @flags: tpm transmit flags - bitmap
> >> + *
> >> + * Return:
> >> + *     0 when the operation is successful.
> >> + *     A negative number for system errors (errno).
> >>    */
> >>   ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
> >>   		     unsigned int flags)
> >> @@ -409,9 +418,21 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const
> u8 *buf, size_t bufsiz,
> >>   	return rc;
> >>   }
> >>
> >> -#define TPM_DIGEST_SIZE 20
> >> -#define TPM_RET_CODE_IDX 6
> >> -
> >> +/**
> >> + * tmp_transmit_cmd - send a tpm command to the device
> >> + *    The function extracts tpm out header return code
> >> + *
> >> + * @chip: TPM chip to use
> >> + * @cmd: TPM command buffer
> >> + * @len: length of the TPM command
> >> + * @flags: tpm transmit flags - bitmap
> >> + * @desc: command description used in the error message
> >> + *
> >> + * Return:
> >> + *     0 when the operation is successful.
> >> + *     A negative number for system errors (errno).
> >> + *     A positive number for a TPM error.
> >> + */
> >>   ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
> >>   			 int len, unsigned int flags, const char *desc)
> >>   {
> >> @@ -434,6 +455,8 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip,
> const void *cmd,
> >>   	return err;
> >>   }
> >>
> >> +#define TPM_DIGEST_SIZE 20
> >> +#define TPM_RET_CODE_IDX 6
> >>   #define TPM_INTERNAL_RESULT_SIZE 200
> >>   #define TPM_ORD_GET_CAP cpu_to_be32(101)
> >>   #define TPM_ORD_GET_RANDOM cpu_to_be32(70)
> >> --
> >> 2.7.4
> >>
> >
> > ----------------------------------------------------------------------
> > -------- Check out the vibrant tech community on one of the world's
> > most engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> > _______________________________________________
> > tpmdd-devel mailing list
> > tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> >


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/xeonphi
