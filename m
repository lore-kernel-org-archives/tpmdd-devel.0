From: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] tpm: Fix suspend regression
Date: Wed, 11 May 2016 18:06:09 -0700
Message-ID: <20160512010609.GA3035@hudson.localdomain>
References: <1462980507-21682-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462980507-21682-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Stefan,

On Wed, May 11, 2016 at 11:28:27AM -0400, Stefan Berger wrote:
> Fix the suspend regression due to the wrong way of retrieving the
> chip structure. The suspend functions are attached to the hardware
> device, not the chip and thus must rely on drvdata.
> 
> Fixes: e89f8b1ade9cc1a ("tpm: Remove all uses of drvdata from the TPM Core")
> Reported-by: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Tested-by: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 080dade..5e3c1b6 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -934,7 +934,7 @@ static struct tpm_input_header savestate_header = {
>   */
>  int tpm_pm_suspend(struct device *dev)
>  {
> -	struct tpm_chip *chip = to_tpm_chip(dev);
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	struct tpm_cmd_t cmd;
>  	int rc, try;
>  
> @@ -995,7 +995,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_suspend);
>   */
>  int tpm_pm_resume(struct device *dev)
>  {
> -	struct tpm_chip *chip = to_tpm_chip(dev);
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
>  
>  	if (chip == NULL)
>  		return -ENODEV;
> -- 
> 2.4.3
> 

The patch looks good, thanks :-)

-- 
- Jeremiah Mahler

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
