From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 2/3] tpm: separate cmd_ready/go_idle from runtime_pm
Date: Tue, 23 Jan 2018 08:33:22 -0700
Message-ID: <20180123153322.GB30670@ziepe.ca>
References: <20180123112731.3687-1-tomas.winkler@intel.com>
 <20180123112731.3687-2-tomas.winkler@intel.com>
 <20180123130841.ub2amxalgr2oapu6@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180123130841.ub2amxalgr2oapu6@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, Alexander Usyskin <alexander.usyskin@intel.com>, tpmdd-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 23, 2018 at 03:08:41PM +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 23, 2018 at 01:27:30PM +0200, Tomas Winkler wrote:
> > We cannot use go_idle cmd_ready commands via runtime_pm handles
> > as with the introduction of localities this is no longer an optional
> > feature, while runtime pm can be not enabled.
> > Though cmd_ready/go_idle provides power saving feature, it's also part of
> > TPM2 protocol and should be called explicitly.
> > This patch exposes cmd_read/go_idle via tpm class ops and removes
> > runtime pm support as it is not used by any driver.
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Thank you.
> 
> LGTM
> 
> Jason, what do you think?

The PM stuff has been the source of confusion for a while, seems
reasonable to get rid of it.

Jason
