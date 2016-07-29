From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] TPM2.0: Refactor eventlog init
 functions for TPM1.2 and
Date: Fri, 29 Jul 2016 10:57:08 -0600
Message-ID: <20160729165708.GA6331@obsidianresearch.com>
References: <1469774679-25232-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1469774679-25232-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469774679-25232-2-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Fri, Jul 29, 2016 at 02:44:38AM -0400, Nayna Jain wrote:
> Refactored eventlog.c file into tpm_eventlog.c and tpm_eventlog_init.c

If you are going to work on this stuff (and have the ability to test
it) can you fix some of the generic pre-existing problems too?

> +static int tpm_ascii_bios_measurements_open(struct inode *inode,
> +					    struct file *file)

> +static int tpm_binary_bios_measurements_open(struct inode *inode,
> +					     struct file *file)

We don't need two (or more!) identical versions of this function, and it
is easy to fix:

> +	bin_file =
> +	    securityfs_create_file("binary_bios_measurements",
> +				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
> +				   &tpm_binary_bios_measurements_ops);

Replace NULL with &tpm_binary_b_measurments_seqops and recover it  in
the generic open using the inode->i_private pointer.

> +	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
> +	if (!ret)
> +		goto out_ascii;

I can't find a kfree for this memory, looks like it is leaking, please
fix it.

Do not allocate memory for this, just include the dentry array
directly in the tpm_chip as the sysfs does today.

You can change the signatures to accept tpm_chip in a cleanup patch as
well, moving from the tpm2 patch.

Jason

------------------------------------------------------------------------------
