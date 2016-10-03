From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND 2/3] tpm: replace dynamically allocated bios_dir
 with a static array
Date: Mon, 3 Oct 2016 15:21:35 +0300
Message-ID: <20161003122135.GB9990@intel.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1475349926-476-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20161002212801.GC25872@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161002212801.GC25872@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Nayna Jain <nayna@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 02, 2016 at 03:28:01PM -0600, Jason Gunthorpe wrote:
> On Sat, Oct 01, 2016 at 10:25:25PM +0300, Jarkko Sakkinen wrote:
> 
> > +	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
> > +		if (chip->bios_dir[i])
> 
> The entries can't actually be null here, right?

They can because this function is called as a rollbcak procedure for
tpm_bios_log_setup.

> Jason

/Jarkko
