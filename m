From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/7] tpm: fix the race condition
 between event log access and chip getting unregistered
Date: Thu, 20 Oct 2016 14:28:40 -0600
Message-ID: <20161020202840.GA13922@obsidianresearch.com>
References: <1476838185-24007-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1476838185-24007-5-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476838185-24007-5-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Tue, Oct 18, 2016 at 08:49:42PM -0400, Nayna Jain wrote:
> +	struct tpm_chip_seqops *chip_seqops;
> +	const struct seq_operations *seqops;
> +	struct tpm_chip *chip;
> +
> +	inode_lock(inode);
> +	if (!inode->i_private) {
> +		inode_unlock(inode);
> +		return -ENODEV;
> +	}
> +	chip_seqops = (struct tpm_chip_seqops *)inode->i_private;
> +	seqops = chip_seqops->seqops;
> +	chip = chip_seqops->chip;
> +	get_device(&chip->dev);

The inode_unlock should be here, not further below - reduces the risk of
deadlocking.

> +	rc = read_log(chip);
> +	/*
> +	 * read_log failure means event log is not supported except for ENOMEM
> +	 */
> +	if (rc < 0) {
> +		if (rc == -ENOMEM)

It would be more consistent to use -ENODEV as indicating no support,
and everything else is pass as an error

Rest looks right to me

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
