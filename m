From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 5/7] tpm: Replace the
 of_find_node_by_name() with dev of_node property
Date: Tue, 30 Aug 2016 11:55:06 -0600
Message-ID: <20160830175506.GE6373@obsidianresearch.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-6-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472532619-22170-6-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 30, 2016 at 12:50:17AM -0400, Nayna Jain wrote:
> Using device of_node property is better way to refer to device node
> rather than of_find_node_by_name().
> 
> Additionally, this patch replaces all currently used pr_err()  with
> recommended dev_dbg().
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>  drivers/char/tpm/tpm-chip.c |  2 ++
>  drivers/char/tpm/tpm_of.c   | 20 ++++++++++----------
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 307130e..a040080 100644
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -171,6 +171,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
>  	chip->dev.release = tpm_dev_release;
>  	chip->dev.parent = dev;
>  	chip->dev.groups = chip->groups;
> +	if (dev->of_node)
> +		chip->dev.of_node = chip->dev.parent->of_node;

No, that could cause all manner of problems.

> +	if (chip->dev.of_node)
> +		np = chip->dev.of_node;

Just use chip->dev.parent->of_node here

Jason

------------------------------------------------------------------------------
