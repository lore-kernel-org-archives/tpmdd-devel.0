From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Thu, 19 Jan 2017 12:49:22 +0200
Message-ID: <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
 <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
 <1484751663.2717.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484751663.2717.10.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 18, 2017 at 10:01:03AM -0500, James Bottomley wrote:
> On Mon, 2017-01-16 at 15:12 +0200, Jarkko Sakkinen wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > Currently the Resource Manager (RM) is not exposed to userspace. 
> >  Make
> > this exposure via a separate device, which can now be opened multiple
> > times because each read/write transaction goes separately via the RM.
> > 
> > Concurrency is protected by the chip->tpm_mutex for each read/write
> > transaction separately.  The TPM is cleared of all transient objects
> > by the time the mutex is dropped, so there should be no interference
> > between the kernel and userspace.
> 
> There's actually a missing kfree of context_buf on the tpms_release
> path as well.  This patch fixes it up.

Can you send me a fresh version of the whole patch so that I can include
to v4 that includes also changes that I requested in my recent comments
+ all the fixes?

/Jarkko

> 
> James
> 
> ---
> 
> commit 778425973c532a0c1ec2b5b2ccd7ff995e2cc9db
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Wed Jan 18 09:58:23 2017 -0500
> 
>     add missing kfree to tpms_release
> 
> diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
> index c10b308..6bb687f 100644
> --- a/drivers/char/tpm/tpms-dev.c
> +++ b/drivers/char/tpm/tpms-dev.c
> @@ -37,6 +37,7 @@ static int tpms_release(struct inode *inode, struct file *file)
>  	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
>  
>  	tpm_common_release(file, fpriv);
> +	kfree(priv->space.context_buf);
>  	kfree(priv);
>  
>  	return 0;
> 
