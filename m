From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: tpm_tis regression in 4.9?
Date: Fri, 28 Oct 2016 17:37:45 +0300
Message-ID: <20161028143745.3iaevn4sunbmuiln@intel.com>
References: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
 <20161028030916.GA29851@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161028030916.GA29851@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 27, 2016 at 09:09:16PM -0600, Jason Gunthorpe wrote: > On Thu, Oct 27, 2016 at 05:33:57PM -0700, Andy Lutomirski wrote:
> > Hi-
> > 
> > I think this error on my laptop is new on 4.9 kernels:
> > 
> > [  +0.014696] tpm_tis 00:09: 1.2 TPM (device-id 0xFE, rev-id 2)
> > [  +0.012228] tpm tpm0: TPM self test failed
> > [  +0.000019] tpm_tis: probe of 00:09 failed with error -14
> > 
> > Is this known?
> 
> I think this patch from Jarkko's next is the fix:
> 
> http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/65da72b7ddcdd8990e4783d09c7e86d90ccb4121
> 
> Jarkko? Can you hurry that along to go in for -rc?

Do you think I should resend the pull request?

/Jarkko
