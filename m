From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/3] tpm: separate cmd_ready/go_idle from runtime_pm
Date: Mon, 29 Jan 2018 10:42:21 +0200
Message-ID: <20180129084221.deudcqbsh22hcrrb@linux.intel.com>
References: <20180123112731.3687-1-tomas.winkler@intel.com>
 <20180123112731.3687-2-tomas.winkler@intel.com>
 <20180123130841.ub2amxalgr2oapu6@linux.intel.com>
 <20180123153322.GB30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180123153322.GB30670@ziepe.ca>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Tomas Winkler <tomas.winkler@intel.com>, Alexander Usyskin <alexander.usyskin@intel.com>, tpmdd-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 23, 2018 at 08:33:22AM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 23, 2018 at 03:08:41PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 23, 2018 at 01:27:30PM +0200, Tomas Winkler wrote:
> > > We cannot use go_idle cmd_ready commands via runtime_pm handles
> > > as with the introduction of localities this is no longer an optional
> > > feature, while runtime pm can be not enabled.
> > > Though cmd_ready/go_idle provides power saving feature, it's also part of
> > > TPM2 protocol and should be called explicitly.
> > > This patch exposes cmd_read/go_idle via tpm class ops and removes
> > > runtime pm support as it is not used by any driver.
> > > 
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > 
> > Thank you.
> > 
> > LGTM
> > 
> > Jason, what do you think?
> 
> The PM stuff has been the source of confusion for a while, seems
> reasonable to get rid of it.

I'll test this ASAP.

/Jarkk
