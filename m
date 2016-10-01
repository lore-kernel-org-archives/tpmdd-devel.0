From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: replace dynamically allocated bios_dir with a
 static array
Date: Sat, 1 Oct 2016 22:22:07 +0300
Message-ID: <20161001192207.GA31992@intel.com>
References: <1475325678-16573-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1475325678-16573-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20161001164932.GA13462@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161001164932.GA13462@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Nayna Jain <nayna@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 01, 2016 at 10:49:32AM -0600, Jason Gunthorpe wrote:
> On Sat, Oct 01, 2016 at 03:41:17PM +0300, Jarkko Sakkinen wrote:
> > -	bin_file =
> > +	chip->bios_dir[cnt] =
> >  	    securityfs_create_file("binary_bios_measurements",
> > -				   S_IRUSR | S_IRGRP, tpm_dir,
> > +				   S_IRUSR | S_IRGRP, chip->bios_dir[cnt],
> 
> That is certainly not right, Nayna's version was correct, the function
> argument is the directory to create under and bios_dir[0] is setup as the
> directory for tpm. This is also why removal is done in reverse order,
> files are removed then the directory that contains them.

Right. I overlooked this.

> Jason

/Jarkko
