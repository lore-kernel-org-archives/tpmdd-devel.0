From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: TPM resource manager - persistent objects should
 be global
Date: Fri, 31 Mar 2017 11:14:52 +0300
Message-ID: <20170331081452.6njjzzo4ubhppyvl@intel.com>
References: <e89db1e1-7996-3106-c034-e6d4c2c5f887@linux.vnet.ibm.com>
	<1490812802.5647.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490812802.5647.4.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Ken, James, thank you. I'll squash this before PR.

/Jarkko

On Wed, Mar 29, 2017 at 02:40:02PM -0400, James Bottomley wrote:
> On Tue, 2017-03-28 at 17:39 -0400, Ken Goldman wrote:
> > I have a persistent object at 81000001.
> > 
> > getcapability through /dev/tpm0 shows it.  The same command through 
> > /dev/tpmrm0 does not.  This causes further problems in the
> > application.
> > 
> > While transient objects are per connection, IMHO persistent objects 
> > should be global.
> > 
> > ~~
> > 
> > Warning:  I think I'm using the latest TPM device driver from
> > 
> > git://git.infradead.org/users/jjs/linux-tpmdd.git
> > 
> > but I'm new to both git and kernel building, so I could be wrong.  If
> > you think the above should work, it could be my error.
> 
> It should work.  It turns out the body mapping code is overzealous and
> errors out when it should just pass through.  The same thing happens
> with the PCRs as well.
> 
> This should fix it for both.
> 
> James
> 
> ---
> 
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 009934269514..e2e059d8ffec 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -429,15 +429,11 @@ static int tpm2_map_response_body(struct tpm_chip *chip, u32 cc, u8 *rsp,
>  			data->handles[j] = cpu_to_be32(vhandle);
>  			j++;
>  			break;
> -		case TPM2_HT_HMAC_SESSION:
> -		case TPM2_HT_POLICY_SESSION:
> +
> +		default:
>  			data->handles[j] = cpu_to_be32(phandle);
>  			j++;
>  			break;
> -		default:
> -			dev_err(&chip->dev, "%s: unknown handle 0x%08X\n",
> -				__func__, phandle);
> -			break;
>  		}
>  
>  	}
> 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
