From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 9/9] tpm: cleanup of printk error messages
Date: Mon, 14 Nov 2016 16:15:48 -0800
Message-ID: <20161115001548.njycigqoufhfqac5@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-10-git-send-email-nayna@linux.vnet.ibm.com>
 <20161114222406.vupiibtylesbota7@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161114222406.vupiibtylesbota7@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 02:24:06PM -0800, Jarkko Sakkinen wrote:
> On Mon, Nov 14, 2016 at 05:00:56AM -0500, Nayna Jain wrote:
> > This patch removes the unnecessary error messages on failing to
> > allocate memory and replaces pr_err/printk with dev_dbg/dev_info
> > as applicable.
> > 
> > Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
