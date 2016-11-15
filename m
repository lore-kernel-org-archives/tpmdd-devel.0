From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 0/9] tpm: cleanup/fixes in existing event log support
Date: Tue, 15 Nov 2016 09:40:12 -0800
Message-ID: <20161115174012.3pfxzz2ugrdglj4o@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20161114223322.5uzdc7sob2vukwrq@intel.com>
 <20161115002514.qhweuyzg5mgebusq@intel.com>
 <20161115021543.d4wgjqid7fut4y4c@intel.com>
 <582A9EAE.5000505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <582A9EAE.5000505@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 15, 2016 at 11:05:42AM +0530, Nayna wrote:
> 
> 
> On 11/15/2016 07:45 AM, Jarkko Sakkinen wrote:
> > On Mon, Nov 14, 2016 at 04:25:14PM -0800, Jarkko Sakkinen wrote:
> > > On Mon, Nov 14, 2016 at 02:33:23PM -0800, Jarkko Sakkinen wrote:
> > > > On Mon, Nov 14, 2016 at 05:00:47AM -0500, Nayna Jain wrote:
> > > > > This patch set includes the cleanup and bug fixes patches, previously
> > > > > part of the "tpm: add the securityfs pseudo files support for TPM 2.0
> > > > > firmware event log" patch set, in order to upstream them more quickly.
> > > > 
> > > > I applied the patches. I'm not yet sure whether these are part of the
> > > > 4.10 pull request or whether I postpone to 4.11 (my preference would be
> > > > 4.10 but I do not want to close that right now). I'll do testing next
> > > > week before doing pull request.
> > > > 
> > > > I hope that the commits gets some reviews and testing now that they are
> > > > easily testable in my master branch.
> > > 
> > > Event log still works and they do not seem to break TPM 2.0 (tried both
> > > machine with tpm_crb and tpm_tis).
> > > 
> > > Stefan: would you mind check that these do not break your TPM 1.2
> > > environment? I already tried wih TPM 1.2 machine but probably would
> > > make sense to peer test.
> > 
> > I'm dropping commits 8/9 and 9/9 from my tree and *will not* include
> > them to my 4.10 pull request.
> 
> Will fix this and resend the patch 8/9 and 9/9 again.

I applied fix from Colin. I for OF specific patches in this patch set
I do not have means to test the code paths that exercise OF specific
functionality. This is what worries me a bit. If I had tested-by from
someone running a system that can exercise those code paths, I would
be less worried.

/Jarkko
