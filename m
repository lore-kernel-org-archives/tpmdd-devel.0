From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 6/9] tpm: fix the missing .owner in
 tpm_bios_measurements_ops
Date: Mon, 14 Nov 2016 14:22:09 -0800
Message-ID: <20161114222209.aa4msezaumvifvwh@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-7-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479117656-12403-7-git-send-email-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 05:00:53AM -0500, Nayna Jain wrote:
> This patch fixes the missing .owner field in
> tpm_bios_measurements_ops definition.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm_eventlog.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index f8c42fe..5575ffc 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -349,6 +349,7 @@ static int tpm_bios_measurements_open(struct inode *inode,
>  }
>  
>  static const struct file_operations tpm_bios_measurements_ops = {
> +	.owner = THIS_MODULE,
>  	.open = tpm_bios_measurements_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,
> -- 
> 2.5.0
> 
