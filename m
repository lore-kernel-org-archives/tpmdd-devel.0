From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND 1/2] tpm-dev-common: Reject too short writes
Date: Wed, 30 Aug 2017 13:40:59 +0300
Message-ID: <20170830104059.sglgybn3fxh24qjr@linux.intel.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
 <20170824083545.13280-2-Alexander.Steffen@infineon.com>
 <20170825165451.b7lv7t5w3nhbz7da@linux.intel.com>
 <6039fbecc07044a88706a41441f62d18@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6039fbecc07044a88706a41441f62d18@MUCSE603.infineon.com>
Sender: stable-owner@vger.kernel.org
To: Alexander.Steffen@infineon.com
Cc: tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 28, 2017 at 05:11:00PM +0000, Alexander.Steffen@infineon.com wrote:
> > > diff --git a/drivers/char/tpm/tpm-dev-common.c
> > > b/drivers/char/tpm/tpm-dev-common.c
> > > index 610638a..c39b581 100644
> > > --- a/drivers/char/tpm/tpm-dev-common.c
> > > +++ b/drivers/char/tpm/tpm-dev-common.c
> > > @@ -119,7 +119,7 @@ ssize_t tpm_common_write(struct file *file, const
> > char __user *buf,
> > >  		return -EPIPE;
> > >  	}
> > >  	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
> > > -				sizeof(priv->data_buffer), 0);
> > > +				sizeof(priv->data_buffer), in_size, 0);
> > 
> > Why you couldn't just
> > 
> > unsigned int bufsiz;
> > 
> > /* ... */
> > 
> > bufsiz = sizeof(priv->data_buffer);
> > if (in_size < bufsiz)
> > 	bufsiz = in_size;
> > 
> > out_size = tpm_transmit(priv->chip, space, priv->data_buffer, bufsiz, 0);
> 
> Because the code needs to know both how large the buffer is (in order to avoid buffer overflows when writing to it) and how much of the data in the buffer is valid (in order not to send random junk to the TPM). This is made more explicit in PATCH 2/2.
> 
> Your example fails as soon as the response is longer than the command.
> 
> Alexander

Got you.

Do the comparison for count tpm-dev-common.c as it is the only call site
where this is needed instead of scrabbling with the parameters. In other
call sites this is unnecessary at this point.

This will also make backporting a factor more sleek.

/Jarkko
