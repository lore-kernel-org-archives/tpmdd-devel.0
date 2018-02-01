From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH 1/3] tpm: cmd_ready command can be issued only after
 granting locality
Date: Thu, 1 Feb 2018 22:08:19 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B94214CFE@hasmsx108.ger.corp.intel.com>
References: <20180123112731.3687-1-tomas.winkler@intel.com>
 <20180123125426.t6xjgrqcfbkmvkdl@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B94203771@hasmsx108.ger.corp.intel.com>
 <20180129084441.6oc4m4jgbqzsfq3v@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20180129084441.6oc4m4jgbqzsfq3v@linux.intel.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "Usyskin, Alexander" <alexander.usyskin@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> 
> On Wed, Jan 24, 2018 at 06:33:53PM +0000, Winkler, Tomas wrote:
> > > > -	pm_runtime_put(dev);
> > > > +	pm_runtime_put_sync(dev);
> > >
> > > Change to put_sync is needed so that the idle handshake gets
> completed?
> >
> > Right.
> 
> Since we seem to agree that your change to get rid of the use of PM runtime
> should that be actually the first change in the patch set?
> 
> Or are you looking forward to get these backported to stable kernels?

Yes, that was one of the reason behind for splitting this into two patches. 
So this first patch is the actual fix and second is the rather non user visible fix 
as runtime_pm should be enabled by default.  But .. maybe both need to be backported.

Thanks
Tomas
