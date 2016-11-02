From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 04/12] xen: make use of
 xenbus_read_unsigned() in xen-tpmfront
Date: Wed, 2 Nov 2016 04:34:16 -0600
Message-ID: <20161102103416.ruo6qatr2gwblubp@intel.com>
References: <1477932510-28594-1-git-send-email-jgross@suse.com>
	<1477932510-28594-5-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477932510-28594-5-git-send-email-jgross-IBi9RG/b67k@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 31, 2016 at 05:48:22PM +0100, Juergen Gross wrote:
> Use xenbus_read_unsigned() instead of xenbus_scanf() when possible.
> This requires to change the type of one read from int to unsigned,
> but this case has been wrong before: negative values are not allowed
> for the modified case.
> 
> Cc: peterhuewe-Mmb7MZpHnFY@public.gmane.org
> Cc: tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
> Cc: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
> Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> 
> Signed-off-by: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/xen-tpmfront.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 62028f4..50072cc 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -337,18 +337,14 @@ static int tpmfront_resume(struct xenbus_device *dev)
>  static void backend_changed(struct xenbus_device *dev,
>  		enum xenbus_state backend_state)
>  {
> -	int val;
> -
>  	switch (backend_state) {
>  	case XenbusStateInitialised:
>  	case XenbusStateConnected:
>  		if (dev->state == XenbusStateConnected)
>  			break;
>  
> -		if (xenbus_scanf(XBT_NIL, dev->otherend,
> -				"feature-protocol-v2", "%d", &val) < 0)
> -			val = 0;
> -		if (!val) {
> +		if (!xenbus_read_unsigned(dev->otherend, "feature-protocol-v2",
> +					  0)) {
>  			xenbus_dev_fatal(dev, -EINVAL,
>  					"vTPM protocol 2 required");
>  			return;
> -- 
> 2.6.6
> 

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
