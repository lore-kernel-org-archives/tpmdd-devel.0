From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v6 0/9] tpm: cleanup/fixes in existing event log support
Date: Mon, 21 Nov 2016 11:25:04 -0700
Message-ID: <20161121182504.GA9234@obsidianresearch.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20161114223322.5uzdc7sob2vukwrq@intel.com>
 <20161115002514.qhweuyzg5mgebusq@intel.com>
 <20161115021543.d4wgjqid7fut4y4c@intel.com>
 <582A9EAE.5000505@linux.vnet.ibm.com>
 <20161115174012.3pfxzz2ugrdglj4o@intel.com>
 <20161115180610.GA1852@obsidianresearch.com>
 <20161115185453.e52miq2em7gj4qyi@intel.com>
 <20161119183627.GC22775@obsidianresearch.com>
 <20161120095848.4e5vq26oxagyrrp5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161120095848.4e5vq26oxagyrrp5@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Nayna <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Nov 20, 2016 at 09:58:48AM +0000, Jarkko Sakkinen wrote:
> On Sat, Nov 19, 2016 at 11:36:27AM -0700, Jason Gunthorpe wrote:
> > On Tue, Nov 15, 2016 at 10:54:53AM -0800, Jarkko Sakkinen wrote:
> > > On Tue, Nov 15, 2016 at 11:06:10AM -0700, Jason Gunthorpe wrote:
> > > > On Tue, Nov 15, 2016 at 09:40:12AM -0800, Jarkko Sakkinen wrote:
> > > > 
> > > > > I applied fix from Colin. I for OF specific patches in this patch set
> > > > > I do not have means to test the code paths that exercise OF specific
> > > > > functionality. This is what worries me a bit. If I had tested-by from
> > > > > someone running a system that can exercise those code paths, I would
> > > > > be less worried.
> > > > 
> > > > I can probably check it next week on my OF systems that do not use event log
> > > 
> > > Thanks Jason. I'll apppend your Tested-by's to the commits when you're
> > > done. Probably doing pull request in the latter part of next week.
> > 
> > What are we testing? Your master now? It will need the patch I just
> > sent or it will fail for me.

Your TOT works for me (60632de288aac485b328e0863f0c987062ca9b49)

There is one tiny regression, I'll send a patch for it..

Jason
