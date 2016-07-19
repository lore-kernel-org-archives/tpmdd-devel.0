From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [RESEND][PATCH] tpm: read burstcount from TPM_STS
 in one 32-bit transaction
Date: Tue, 19 Jul 2016 17:41:39 +0300
Message-ID: <20160719144139.GB14878@intel.com>
References: <1467307543-44566-1-git-send-email-apronin@chromium.org>
 <20160701084323.GA15718@intel.com>
 <20160701084545.GA16059@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160701084545.GA16059@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: apronin@chromium.org
Cc: Christophe Ricard <christophe.ricard@gmail.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, leendert@watson.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 01, 2016 at 11:45:45AM +0300, Jarkko Sakkinen wrote:
> On Fri, Jul 01, 2016 at 11:43:23AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Jun 30, 2016 at 10:25:43AM -0700, apronin@chromium.org wrote:
> > > From: Andrey Pronin <apronin@chromium.org>
> > > 
> > > Some chips incorrectly support partial reads from TPM_STS register
> > > at non-zero offsets. Read the entire 32-bits register instead of
> > > making two 8-bit reads to support such devices and reduce the number
> > > of bus transactions when obtaining the burstcount from TPM_STS.
> > > 
> > > Signed-off-by: Andrey Pronin <apronin@chromium.org>
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Applied to my master branch.

I added also added a fixes line.

/Jarkko
