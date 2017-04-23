From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 3/3] tpm: vtpm_proxy: Add ioctl to request
 locality prepended to command
Date: Sun, 23 Apr 2017 15:18:06 +0300
Message-ID: <20170423121806.olcfmnhrettyjqus@intel.com>
References: <1492442371-30252-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1492442371-30252-4-git-send-email-stefanb@linux.vnet.ibm.com>
 <10c67f88-35cc-be0e-9acf-e85c9e94d790@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10c67f88-35cc-be0e-9acf-e85c9e94d790@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Apr 20, 2017 at 07:58:58AM -0400, Stefan Berger wrote:
> On 04/17/2017 11:19 AM, Stefan Berger wrote:
> > Add an ioctl to request that the locality be prepended to every TPM
> > command.
> >
> > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > ---
> >   drivers/char/tpm/tpm_vtpm_proxy.c | 16 ++++++++++++----
> >   include/uapi/linux/vtpm_proxy.h   |  4 +++-
> >   2 files changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> > index bf59426..5f34973 100644
> > --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> > +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> > @@ -52,7 +52,8 @@ struct proxy_dev {
> >   };
> >
> >   /* all supported flags */
> > -#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
> > +#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2 | \
> > +			       VTPM_PROXY_FLAG_PREPEND_LOCALITY)
> >
> >   static struct workqueue_struct *workqueue;
> >
> > @@ -77,8 +78,9 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
> >   				    size_t count, loff_t *off)
> >   {
> >   	struct proxy_dev *proxy_dev = filp->private_data;
> > -	size_t len;
> > -	int sig, rc;
> > +	size_t len, offset = 0;
> > +	int sig, rc = 0;
> > +	uint8_t locality;
> >
> >   	sig = wait_event_interruptible(proxy_dev->wq,
> >   		proxy_dev->req_len != 0 ||
> > @@ -102,7 +104,13 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
> >   		return -EIO;
> >   	}
> >
> > -	rc = copy_to_user(buf, proxy_dev->buffer, len);
> > +	if (proxy_dev->flags & VTPM_PROXY_FLAG_PREPEND_LOCALITY) {
> > +		locality = proxy_dev->chip->locality;
> > +		offset = sizeof(locality);
> > +		rc = copy_to_user(buf, &locality, offset);
> > +	}
> > +	if (!rc)
> > +		rc = copy_to_user(&buf[offset], proxy_dev->buffer, len);
> >   	memset(proxy_dev->buffer, 0, len);
> >   	proxy_dev->req_len = 0;
> 
> There 'return' statement of this function needs to say 'return len + 
> offset'. So I'll resubmit a V2 for that.
> 
> Apart from that, any comments?
> 
>     Stefan

Will give a proper look next week.

/Jarkko
