From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 4/9] tpm: drop tpm1_chip_register(/unregister)
Date: Thu, 24 Nov 2016 13:52:04 +0200
Message-ID: <20161124115204.5hkqpuyh2cl64vje@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-5-git-send-email-nayna@linux.vnet.ibm.com>
 <20161122112200.55khdxtctt5rel4j@intel.com>
 <20161122164240.GC3956@obsidianresearch.com>
 <5835E103.90600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5835E103.90600@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 24, 2016 at 12:03:39AM +0530, Nayna wrote:
> 
> 
> On 11/22/2016 10:12 PM, Jason Gunthorpe wrote:
> > On Tue, Nov 22, 2016 at 01:22:00PM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Nov 14, 2016 at 05:00:51AM -0500, Nayna Jain wrote:
> > > > Check for TPM2 chip in tpm_sysfs_add_device, tpm_bios_log_setup and
> > > > tpm_bios_log_teardown in order to make code flow cleaner and to enable
> > > > to implement TPM 2.0 support later on. This is partially derived from
> > > > the commit by Nayna Jain with the extension that also tpm1_chip_register
> > > > is dropped.
> > > > 
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > 
> > > This commit remains unreviewed and tested. I'm in the author role here
> > > so I cannot help with this. If that does not happen soon I cannot put
> > > this into the pull request.
> > 
> > I tested it on my ARM system when I tested your branch.
> > 
> > I think it looks better this way..
> > 
> > Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > 
> > Jason
> > 
> 
> From my side also, as part of testing the whole patchset, I have tested this
> patch.
> 
> Tested-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> Reviewed-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> 
> Thanks & Regards,
>   - Nayna

Thanks Nayna! I'll go on creating pull request...

/Jarkko
