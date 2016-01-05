From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: keys,
	trusted: seal with a TPM2 authorization policy
Date: Tue, 5 Jan 2016 13:48:47 +0200
Message-ID: <20160105114847.GA3713@intel.com>
References: <20160105095826.GH23619@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160105095826.GH23619@mwanda>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 05, 2016 at 12:58:26PM +0300, Dan Carpenter wrote:
> Hello Jarkko Sakkinen,
> 
> The patch 5beb0c435bdd: "keys, trusted: seal with a TPM2
> authorization policy" from Oct 31, 2015, leads to the following
> static checker warning:
> 
> 	drivers/char/tpm/tpm2-cmd.c:481 tpm2_seal_trusted()
> 	warn: this array is probably non-NULL. 'options->policydigest'
> 
> drivers/char/tpm/tpm2-cmd.c
>    479  
>    480          /* public */
>    481          if (options->policydigest)
>    482                  tpm_buf_append_u16(&buf, 14 + options->digest_len);
>    483          else
>    484                  tpm_buf_append_u16(&buf, 14);
> 
> This line is dead code.  We should remove the NULL test or perhaps a
> different test was intended?

It's a regression caused by me when I changed the patch not allocate
this buffer dynamically but used a static array. The right way to fix
this is to check the digest length.

Thank you for catching this! I'll implement and include a fix to my next
pull request.

>    485  
>    486          tpm_buf_append_u16(&buf, TPM2_ALG_KEYEDHASH);
>    487          tpm_buf_append_u16(&buf, hash);
>    488
>    489          /* policy */
>    490          if (options->policydigest) {
> 
> Same.

Yup, and similar fix applies here.

>    491                  tpm_buf_append_u32(&buf, 0);
>    492                  tpm_buf_append_u16(&buf, options->digest_len);
>    493                  tpm_buf_append(&buf, options->policydigest,
>    494                                 options->digest_len);
>    495          } else {
>    496                  tpm_buf_append_u32(&buf, TPM2_ATTR_USER_WITH_AUTH);
>    497                  tpm_buf_append_u16(&buf, 0);
>    498          }
>    499
> 
> regards,
> dan carpenter

/Jarkko

------------------------------------------------------------------------------
