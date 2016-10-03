From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Mon, 3 Oct 2016 11:14:19 -0600
Message-ID: <20161003171419.GE6801@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475051682-23060-4-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Wed, Sep 28, 2016 at 04:34:37AM -0400, Nayna Jain wrote:
> @@ -323,34 +315,19 @@ static int tpm_bios_measurements_open(struct inode *inode,
>  					    struct file *file)
>  {
>  	int err;
> -	struct tpm_bios_log *log;
>  	struct seq_file *seq;
> -	const struct seq_operations *seqops =
> -		(const struct seq_operations *)inode->i_private;
> -
> -	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
> -	if (!log)
> -		return -ENOMEM;
> -
> -	err = read_log(log);
> -	if (err)
> -		goto out_free;
> +	const struct tpm_securityfs_data *sfs_data =
> +		(const struct tpm_securityfs_data *)inode->i_private;
> +	const struct seq_operations *seqops = sfs_data->seqops;

You need a get_device(&chip->dev) here, and the matching put_device in fops->release().

> +		seq->private = sfs_data->log;

So store the chip here

> +	chip->bin_sfs_data.log = &chip->log;

And pass the chip in here

And other related changes.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
