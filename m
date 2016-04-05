From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: remove redundant code from self-test functions
Date: Tue, 5 Apr 2016 12:42:21 +0300
Message-ID: <20160405094221.GA12672@intel.com>
References: <1459344045-21602-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160331054623.GB20504@obsidianresearch.com>
 <20160331063756.GA6393@intel.com>
 <20160402031615.GA28449@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160402031615.GA28449@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Apr 01, 2016 at 09:16:15PM -0600, Jason Gunthorpe wrote:
> On Thu, Mar 31, 2016 at 09:37:56AM +0300, Jarkko Sakkinen wrote:
> > On Wed, Mar 30, 2016 at 11:46:23PM -0600, Jason Gunthorpe wrote:
> > > On Wed, Mar 30, 2016 at 04:20:45PM +0300, Jarkko Sakkinen wrote:
> > >   
> > > > -		rc = be32_to_cpu(cmd.header.out.return_code);
> > > >  		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
> > > 
> > > This line is the entire reason it is open coded, I see it being
> > > removed, but I don't see how the functionality is maintained?
> > 
> > When tpm_trance_cmd() returns a positive number it is the TPM error code
> > that it returns. tpm_pcr_read() does pass through whatever
> > tpm_trace_cmd() returns so the above condition should still work as
> > expected.
> 
> Okay, everything looks fine to me

I applied this to http://git.infradead.org/users/jjs/linux-tpmdd.git in
order to get exposure (tested-by's are always welcome).

> Jason

/Jarkko
