From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix a race condition tpm2_unseal_trusted()
Date: Tue, 9 Aug 2016 13:36:29 +0300
Message-ID: <20160809103629.GA17800@intel.com>
References: <1468973792-17598-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160720164818.GA21460@obsidianresearch.com>
 <20160720205314.GA6525@intel.com>
 <20160720211332.GA32417@obsidianresearch.com>
 <20160721090245.GA7999@intel.com>
 <20160721162536.GC19849@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160721162536.GC19849@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 21, 2016 at 10:25:36AM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 21, 2016 at 12:02:45PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Jul 20, 2016 at 03:13:32PM -0600, Jason Gunthorpe wrote:
> > > On Wed, Jul 20, 2016 at 11:53:14PM +0300, Jarkko Sakkinen wrote:
> > > 
> > > > The only use cases I see at the moment for it work this way:
> > > > 
> > > > 1. Call tpm_try_get_ops.
> > > > 2. Send a TPM command.
> > > > 3. Call tpm_put_ops.
> > > 
> > > Right, but that is just a reflection of what the in kernel users are
> > > doing today, not necessarily what they should be doing.
> > > 
> > > We should not break the put/get semantics..
> > > 
> > > > I did not find any other form of use. The only use is to make sure that
> > > > there are no transactions running before the ops are cleared. Or did I
> > > > overlook something perhaps?
> > > 
> > > The put/get is intended to allow a kapi user to hold a ref to tpm
> > > without it geting destroyed. It is not intended to be an exclusive lock.
> > 
> > These operations *are not* exposed to kapi. They are interal to the
> > driver. That's why it does not make sense speak about kapi user.
> 
> Right now yes, but look at other subsystems and you will see
> operations like that, because that is typical design pattern. When I
> wrote them I made sure they could be used in that typical way.
> 
> We have issues in our kapi users with regards to hot plug and multiple
> tpms. Fortunately that basically never happens, but it does indicate
> the API is not sufficient..

Functionally my patch should not break anything. I understand the need
for clean up of locking but why doing this now to make the driver
non-racy would make clean up later on any harder?

I would rather think of clean up after the code is non-racy than doing a
huge clean up for racy code. Correct functionality is more important
than clean code because it has direct effect to users.

/Jarkko
