From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Fri, 13 Jan 2017 18:28:55 +0200
Message-ID: <20170113162855.dddgsomp7m4c3inc@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
 <1484253532.5807.16.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484253532.5807.16.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 12:38:52PM -0800, James Bottomley wrote:
> On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> > +static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp,
> > size_t len)
> > +{
> > +       struct tpm_space *space = &chip->work_space;
> > +       u32 phandle;
> > +       u32 vhandle;
> > +       u32 attrs;
> > +       int i;
> > +       int rc;
> > +
> > +       if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
> > +               /* should never happen */
> > +               dev_err(&chip->dev, "TPM returned a different CC:
> > 0x%04x\n",
> > +                       cc);
> > +               rc = -EFAULT;
> > +               goto out_err;
> > +       }
> > +
> > +       if (!((attrs >> TPM2_CC_ATTR_RHANDLE) & 1))
> > +               return 0;
> > +
> > +       phandle = be32_to_cpup((__be32 *)&rsp[TPM_HEADER_SIZE]);
> 
> I think we have to check the command return code here.  We can't
> blindly fish handles out of the response if the TPM returned an error
> because they won't exist and we'll pull rubbish from the buffer. 
>  Incremental patch below.
> 
> Note I think we should use get_unaligned_be32 because we're pulling a
> 32 bit word from something that's on byte 6 (so misaligned): some
> architectures will trigger an unaligned trap for this (it's not a
> problem: they trap handle it, it just slows down processing a lot).
> 
> James
> 
> ---
> 
> commit d17ad905ff7b114f7efd23f930e9a541ccdf7621
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Wed Jan 11 22:01:29 2017 -0800
> 
>     check return code
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 61422e6..8009ed4 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -90,6 +90,7 @@ enum tpm2_structures {
>  };
>  
>  enum tpm2_return_codes {
> +	TPM2_RC_SUCCESS		= 0x0000,
>  	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
>  	TPM2_RC_HANDLE		= 0x008B,
>  	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index ca55feb..44e5501 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -16,6 +16,7 @@
>   */
>  
>  #include <linux/gfp.h>
> +#include <asm/unaligned.h>
>  #include "tpm.h"
>  
>  enum tpm2_handle_types {
> @@ -167,9 +168,13 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
>  	u32 phandle;
>  	u32 vhandle;
>  	u32 attrs;
> +	u32 return_code = get_unaligned_be32((__be32 *)&rsp[6]);
>  	int i;
>  	int rc;
>  
> +	if (return_code != TPM2_RC_SUCCESS)
> +		return 0;
> +
>  	if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
>  		/* should never happen */
>  		dev_err(&chip->dev, "TPM returned a different CC: 0x%04x\n",
> 

[x]

I'll squash this to the next patch set version.

/Jarkko
