From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 0/9] tpm: cleanup/fixes in existing event log support
Date: Tue, 15 Nov 2016 10:54:53 -0800
Message-ID: <20161115185453.e52miq2em7gj4qyi@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20161114223322.5uzdc7sob2vukwrq@intel.com>
 <20161115002514.qhweuyzg5mgebusq@intel.com>
 <20161115021543.d4wgjqid7fut4y4c@intel.com>
 <582A9EAE.5000505@linux.vnet.ibm.com>
 <20161115174012.3pfxzz2ugrdglj4o@intel.com>
 <20161115180610.GA1852@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161115180610.GA1852@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Nayna <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 15, 2016 at 11:06:10AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 15, 2016 at 09:40:12AM -0800, Jarkko Sakkinen wrote:
> 
> > I applied fix from Colin. I for OF specific patches in this patch set
> > I do not have means to test the code paths that exercise OF specific
> > functionality. This is what worries me a bit. If I had tested-by from
> > someone running a system that can exercise those code paths, I would
> > be less worried.
> 
> I can probably check it next week on my OF systems that do not use event log

Thanks Jason. I'll apppend your Tested-by's to the commits when you're
done. Probably doing pull request in the latter part of next week.

/Jarkko
