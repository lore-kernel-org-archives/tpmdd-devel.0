From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 4/4] tmp/tpm_crb: implement runtime pm for tpm_crb
Date: Sat, 8 Oct 2016 19:01:12 +0300
Message-ID: <20161008160112.GB25893@intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
 <1475927979-23484-5-git-send-email-tomas.winkler@intel.com>
 <20161008124708.GA10317@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F6741@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F6741@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 08, 2016 at 01:37:31PM +0000, Winkler, Tomas wrote:
> > 
> > On Sat, Oct 08, 2016 at 02:59:39PM +0300, Tomas Winkler wrote:
> > > From: "Winkler, Tomas" <tomas.winkler@intel.com>
> > >
> > > Utilize runtime_pm for driving tpm crb idle states.
> > > The framework calls cmd_ready from the pm_runtime_resume handler and
> > > go idle from the pm_runtime_suspend handler.
> > > The TPM framework should wake the device before transmit and receive.
> > > In case the runtime_pm framework is not compiled in or enabled, the
> > > device will be in the permanent ready state.
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > 
> > I would rather want the fix as a separate patch to make review + testing easier
> > (without and with). Thanks.
> 
> But you've dropped the patches, so I've resent them. 
> Can you do the diff yourself, just branch it off.  it's really just few lines 

Nope. I have only dropped the workaround.

/Jarkko
