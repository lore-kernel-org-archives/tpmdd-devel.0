From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND 1/2] tpm-dev-common: Reject too
 short writes
Date: Mon, 28 Aug 2017 17:11:00 +0000
Message-ID: <6039fbecc07044a88706a41441f62d18@MUCSE603.infineon.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
 <20170824083545.13280-2-Alexander.Steffen@infineon.com>
 <20170825165451.b7lv7t5w3nhbz7da@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170825165451.b7lv7t5w3nhbz7da-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> > diff --git a/drivers/char/tpm/tpm-dev-common.c
> > b/drivers/char/tpm/tpm-dev-common.c
> > index 610638a..c39b581 100644
> > --- a/drivers/char/tpm/tpm-dev-common.c
> > +++ b/drivers/char/tpm/tpm-dev-common.c
> > @@ -119,7 +119,7 @@ ssize_t tpm_common_write(struct file *file, const
> char __user *buf,
> >  		return -EPIPE;
> >  	}
> >  	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
> > -				sizeof(priv->data_buffer), 0);
> > +				sizeof(priv->data_buffer), in_size, 0);
> 
> Why you couldn't just
> 
> unsigned int bufsiz;
> 
> /* ... */
> 
> bufsiz = sizeof(priv->data_buffer);
> if (in_size < bufsiz)
> 	bufsiz = in_size;
> 
> out_size = tpm_transmit(priv->chip, space, priv->data_buffer, bufsiz, 0);

Because the code needs to know both how large the buffer is (in order to avoid buffer overflows when writing to it) and how much of the data in the buffer is valid (in order not to send random junk to the TPM). This is made more explicit in PATCH 2/2.

Your example fails as soon as the response is longer than the command.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
