From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: vtpm_proxy: Introduce flag to prevent sysfs entries
Date: Mon, 27 Jun 2016 21:32:20 +0300
Message-ID: <20160627183220.GD7268@intel.com>
References: <1466779015-26965-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160624174803.GA14506@obsidianresearch.com>
 <576D7F34.50201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <576D7F34.50201@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 24, 2016 at 02:43:00PM -0400, Stefan Berger wrote:
> On 06/24/2016 01:48 PM, Jason Gunthorpe wrote:
> >On Fri, Jun 24, 2016 at 10:36:55AM -0400, Stefan Berger wrote:
> >>Introduce TPM_VTPM_PROXY_NO_SYSFS flag that prevents a vtpm_proxy driver
> >>instance from having the typical sysfs entries that shows the state of the
> >>TPM. The flag is to be set in the ioctl creating the vtpm_proxy device
> >>pair and maps on a new chip flags TPM_CHIP_FLAG_NO_SYSFS.
> >No other subsystem does something so goofy, this really needs to be
> >part of namespace support for TPM.
> 
> And I am not sure how to go about this. TPM2 by the way doesn't have such
> entries, so it's much better from that perspective.
> 
> >
> >Why can't you just make the sysfs files unreadable in user space?
> 
> There are actually ways to go about this. Likely bind-mounting over
> /sys/device/virtual/tpm would be one solution to hide all virtual TPM
> device. Another is applying an AppArmor policy to the container denying
> access to tpm directories or entries. SELinux would not be so easy.
> 
> The flag in this patch seemed like a 'cheap' way to eliminate that problem
> as well.

Does it have any other qualities that would make this better than bind
mounting?

/Jarkko
