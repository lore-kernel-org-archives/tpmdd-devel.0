From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v6 3/9] tpm: replace dynamically allocated bios_dir with
 a static array
Date: Fri, 25 Nov 2016 12:38:13 -0700
Message-ID: <20161125193813.GE16504@obsidianresearch.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-4-git-send-email-nayna@linux.vnet.ibm.com>
 <20161122112333.7ootyrbssd6pkrjb@intel.com>
 <20161122165856.GD3956@obsidianresearch.com>
 <20161124135723.kfafipftppjyr5ip@intel.com>
 <20161124165313.GB4930@obsidianresearch.com>
 <20161125080838.mpzflnz7epo6wv6g@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161125080838.mpzflnz7epo6wv6g@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Nov 25, 2016 at 10:08:38AM +0200, Jarkko Sakkinen wrote:

> > This is no good at this point in the series - we need the ENODEV
> > detection in tpm_chip_register() from the 'Fix handle of missing event
> > log' moved into this patch, because it now returns ENODEV due to
> > sercurityfs
> 
> Sure it would be cleaner but not really necessary. Do you really think
> this is mandatory? No matter how I reorder patches this will require
> time and effort to fix various merge conflicts because of the replacemnt
> of event log. After that I have to test everything.

Well, once you started editing patches to fix them you should make
them fully correct so bisection works.

If you applied the patch I gave you on top of the tree then I would
have said to leave it...

> The commit message otherwise great except for the short summary, which
> is now fixed.

It is good now

Jason
