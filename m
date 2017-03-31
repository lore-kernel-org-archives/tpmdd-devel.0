From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: TPM resource manager - persistent objects should
 be global
Date: Fri, 31 Mar 2017 10:57:15 -0400
Message-ID: <0a9a4380-e7cc-8927-e594-bbf5d9fa60c8@linux.vnet.ibm.com>
References: <e89db1e1-7996-3106-c034-e6d4c2c5f887@linux.vnet.ibm.com>
	<1490812802.5647.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1490812802.5647.4.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patch worked.  Can you merge it with Jarkko's latest?

I can report that my attestation client works unmodified with the 
resource manager.  I just had to point it to /dev/tpmrm0.  It's a 
Nuvoton TPM, I2C bus, POWER architecture.

It does quite a bit - transient and persistent objects, getcapability,
reading NV indexes, policy sessions.  I did the RSA and ECC variants in 
parallel, so there should have been a bit of swapping.

On 3/29/2017 2:40 PM, James Bottomley wrote:
> On Tue, 2017-03-28 at 17:39 -0400, Ken Goldman wrote:
>> I have a persistent object at 81000001.
>>
>> getcapability through /dev/tpm0 shows it.  The same command through
>> /dev/tpmrm0 does not.  This causes further problems in the
>> application.
>>
>> While transient objects are per connection, IMHO persistent objects
>> should be global.
>>
>> ~~
>>
>> Warning:  I think I'm using the latest TPM device driver from
>>
>> git://git.infradead.org/users/jjs/linux-tpmdd.git
>>
>> but I'm new to both git and kernel building, so I could be wrong.  If
>> you think the above should work, it could be my error.
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
