From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] Do not disable driver and bus shutdown hook when
 class shutdown hook is set.
Date: Sat, 19 Aug 2017 20:29:59 +0300
Message-ID: <20170819172959.iu46r2jm7unmbb4x@linux.intel.com>
References: <20170811134443.770-1-msuchanek@suse.de>
 <20170819120353.mpwswylg2qulci75@linux.intel.com>
 <20170819170340.GA12870@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170819170340.GA12870@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Suchanek <msuchanek@suse.de>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Phil Sutter <phil@nwl.cc>, Josh Zimmerman <joshz@google.com>, Madalin Bucur <madalin.bucur@nxp.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ludovic Desroches <ludovic.desroches@o2linux.fr>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Aug 19, 2017 at 10:03:40AM -0700, Greg Kroah-Hartman wrote:
> On Sat, Aug 19, 2017 at 03:03:53PM +0300, Jarkko Sakkinen wrote:
> > On Fri, Aug 11, 2017 at 03:44:43PM +0200, Michal Suchanek wrote:
> > > As seen from the implementation of the single class shutdown hook this
> > > is not very sound design.
> > > 
> > > Rename the class shutdown hook to shutdown_pre to make it clear it runs
> > > before the driver shutdown hook.
> > > 
> > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > 
> > I already gave this reviewed-by but cannot apply it because there's no
> > ack from device maintainers yet.
> 
> I'm on vacation at the moment and will look at this when I get back in a
> week, please give me a chance.
> 
> thanks,
> 
> greg k-h

Take your time! I don't think this patch is critical. Thanks.

/Jarkko
