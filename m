From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [tpmdd-devel] [PATCH 2/2] tpm: fix bad constant expressions
Date: Tue, 20 Sep 2016 09:57:48 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542EBC24@hasmsx108.ger.corp.intel.com>
References: <1474316530-17315-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1474316530-17315-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542EB9D8@hasmsx108.ger.corp.intel.com>
 <20160920095605.GA32433@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920095605.GA32433@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> On Tue, Sep 20, 2016 at 07:08:40AM +0000, Winkler, Tomas wrote:
> >
> > > -----Original Message-----
> > > From: Jarkko Sakkinen [mailto:jarkko.sakkinen@linux.intel.com]
> > > Sent: Monday, September 19, 2016 23:22
> > > To: Peter Huewe <peterhuewe@gmx.de>
> > > Cc: moderated list:TPM DEVICE DRIVER <tpmdd-
> > > devel@lists.sourceforge.net>; open list
> > > <linux-kernel@vger.kernel.org>
> > > Subject: [tpmdd-devel] [PATCH 2/2] tpm: fix bad constant expressions
> > >
> > > Sparse reports "bad constant expression" for the use of cpu_to_be32
> > > inside enums tpm_capabilities and tpm_sub_capabilities. Even though
> > > it is probably expanded to a constant expression, it is probably cleaner
> not to use it there.
> >
> >
> > Swap macros were rewritten due to possible compiler bug
> > https://lkml.org/lkml/2016/5/2/597
> > And the warning is actually a bug in sparse, it fails to detect constant
> expression now.
> 
> I still think that these must be change in order to have some consistency in
> the subsystem. Now there are two differing conventions.

Nothing against the convention just the commit message is misleading in that sense. 
Tomas
