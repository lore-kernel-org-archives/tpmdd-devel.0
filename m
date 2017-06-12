From: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Subject: Re: [PATCH] char: tmp: fix potential null pointer
 dereference
Date: Mon, 12 Jun 2017 17:25:44 -0500
Message-ID: <20170612172544.Horde.Br2grYSXmXw3bfXZefqg8tb@gator4166.hostgator.com>
References: <20170530215123.GA7484@embeddedgus>
	<20170531121129.f3576lq7peott6gd@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170531121129.f3576lq7peott6gd-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

Please, see my comments below

Quoting Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:

> On Tue, May 30, 2017 at 04:51:23PM -0500, Gustavo A. R. Silva wrote:
>> NULL check at line 147: if (chip) {, implies chip might be NULL.
>> Function dev_get_drvdata() dereference pointer chip.
>> Move pointer priv assignment inside the IF block that checks
>> pointer chip.
>>
>> Addresses-Coverity-ID: 1397646
>> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
>
> It cannot be.
>

I got it.

> /Jarkko
>
>> ---
>>  drivers/char/tpm/tpm_atmel.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
>> index 0d322ab..0826efd 100644
>> --- a/drivers/char/tpm/tpm_atmel.c
>> +++ b/drivers/char/tpm/tpm_atmel.c
>> @@ -142,9 +142,10 @@ static struct platform_device *pdev;
>>  static void atml_plat_remove(void)
>>  {
>>  	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
>> -	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>> +	struct tpm_atmel_priv *priv;
>>
>>  	if (chip) {

So, this NULL check could be removed?

>> +		priv = dev_get_drvdata(&chip->dev);
>>  		tpm_chip_unregister(chip);
>>  		if (priv->have_region)
>>  			atmel_release_region(priv->base, priv->region_size);
>> --
>> 2.5.0
>>

Thank you
--
Gustavo A. R. Silva





------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
