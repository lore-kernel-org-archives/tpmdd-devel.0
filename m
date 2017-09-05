From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 1/2] tpm-dev-common: Reject too
 short writes
Date: Tue, 5 Sep 2017 22:02:49 +0300
Message-ID: <20170905190249.tsy5l6ou2z5p55te@linux.intel.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
 <20170824083545.13280-2-Alexander.Steffen@infineon.com>
 <20170825165451.b7lv7t5w3nhbz7da@linux.intel.com>
 <6039fbecc07044a88706a41441f62d18@MUCSE603.infineon.com>
 <20170830104059.sglgybn3fxh24qjr@linux.intel.com>
 <dd865ba5751e4d568709e0aaf209633b@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <dd865ba5751e4d568709e0aaf209633b-nFblLGNE8XKJSz+rYg/bSJowlv4uC7bZ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 04, 2017 at 05:35:00PM +0000, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> > On Mon, Aug 28, 2017 at 05:11:00PM +0000,
> > Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> > > > > diff --git a/drivers/char/tpm/tpm-dev-common.c
> > > > > b/drivers/char/tpm/tpm-dev-common.c
> > > > > index 610638a..c39b581 100644
> > > > > --- a/drivers/char/tpm/tpm-dev-common.c
> > > > > +++ b/drivers/char/tpm/tpm-dev-common.c
> > > > > @@ -119,7 +119,7 @@ ssize_t tpm_common_write(struct file *file,
> > > > > const
> > > > char __user *buf,
> > > > >  		return -EPIPE;
> > > > >  	}
> > > > >  	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
> > > > > -				sizeof(priv->data_buffer), 0);
> > > > > +				sizeof(priv->data_buffer), in_size, 0);
> > > >
> > > > Why you couldn't just
> > > >
> > > > unsigned int bufsiz;
> > > >
> > > > /* ... */
> > > >
> > > > bufsiz = sizeof(priv->data_buffer);
> > > > if (in_size < bufsiz)
> > > > 	bufsiz = in_size;
> > > >
> > > > out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
> > > > bufsiz, 0);
> > >
> > > Because the code needs to know both how large the buffer is (in order to
> > avoid buffer overflows when writing to it) and how much of the data in the
> > buffer is valid (in order not to send random junk to the TPM). This is made
> > more explicit in PATCH 2/2.
> > >
> > > Your example fails as soon as the response is longer than the command.
> > >
> > > Alexander
> > 
> > Got you.
> > 
> > Do the comparison for count tpm-dev-common.c as it is the only call site
> > where this is needed instead of scrabbling with the parameters. In other call
> > sites this is unnecessary at this point.
> > 
> > This will also make backporting a factor more sleek.
> 
> I am not entirely happy with that approach, since it leads to worse
> code, splitting the buffer size validation logic over multiple places,
> but I can see how it makes backporting easier thanks to a smaller
> diff. A new patch is on its way.

Well I do not see it as part of the common buffer validation logic if it
is required only when you access from user space.

It's not only about smaller diff but also unnecessary change of
semantics in the places where it is no absolutely needed.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
