From: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 5/5] Use __func__ instead of function name
Date: Fri, 18 Aug 2017 10:03:17 +0200
Message-ID: <0e2d9ac4f5ee02e9df98610ed07eaec9@suse.de>
References: <20170729072433.13194-1-sz.lin@moxa.com>
 <20170729072433.13194-6-sz.lin@moxa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170729072433.13194-6-sz.lin-D4fb9hXD9d4@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: SZ Lin <sz.lin-D4fb9hXD9d4@public.gmane.org>
Cc: Linuxppc-dev <linuxppc-dev-bounces+msuchanek=suse.de-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, tpmdd-yWjUBOtONeeDGRHsOpWV0g@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 2017-07-29 09:24, SZ Lin wrote:
> Fix following checkpatch.pl warning:
> WARNING: Prefer using '"%s...", __func__' to using
> the function's name, in a string
> 
> Signed-off-by: SZ Lin <sz.lin-D4fb9hXD9d4@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_ibmvtpm.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c 
> b/drivers/char/tpm/tpm_ibmvtpm.c
> index e75a674b44ac..2d33acc43e25 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -151,7 +151,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip,
> u8 *buf, size_t count)
>  	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
>  			      be64_to_cpu(word[1]));
>  	if (rc != H_SUCCESS) {
> -		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
> +		dev_err(ibmvtpm->dev, "%s failed rc=%d\n", __func__, rc);

Can function name contain a %?

I would prefer dev_err(ibmvtpm->dev, __func__ " failed rc=%d\n", rc);

It's not what checkpatch advises in the above message, though.

Presumably with many messages from the same function using %s would
save space but that is not the usual case.

Thanks

Michal



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
