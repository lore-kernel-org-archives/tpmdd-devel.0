From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] xen-tpmfront: correct return value check on
 xenbus_scanf()
Date: Thu, 7 Jul 2016 13:38:59 +0300
Message-ID: <20160707103859.GA13815@intel.com>
References: <577E291002000078000FBF18@prv-mh.provo.novell.com>
 <20160707103554.GA13244@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160707103554.GA13244@intel.com>
Sender: stable-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: peterhuewe@gmx.de, jgunthorpe@obsidianresearch.com, tpmdd@selhorst.net, david.vrabel@citrix.com, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, Juergen Gross <JGross@suse.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 07, 2016 at 01:35:54PM +0300, Jarkko Sakkinen wrote:
> On Thu, Jul 07, 2016 at 02:04:00AM -0600, Jan Beulich wrote:
> > Only a positive return value indicates success.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Applied. Should this be CC'd to stable or not?

/Jarkko

> /Jarkko
> 
> > ---
> >  drivers/char/tpm/xen-tpmfront.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- 4.7-rc6-xenbus_scanf.orig/drivers/char/tpm/xen-tpmfront.c
> > +++ 4.7-rc6-xenbus_scanf/drivers/char/tpm/xen-tpmfront.c
> > @@ -344,7 +344,7 @@ static void backend_changed(struct xenbu
> >  			break;
> >  
> >  		if (xenbus_scanf(XBT_NIL, dev->otherend,
> > -				"feature-protocol-v2", "%d", &val) < 0)
> > +				"feature-protocol-v2", "%d", &val) <= 0)
> >  			val = 0;
> >  		if (!val) {
> >  			xenbus_dev_fatal(dev, -EINVAL,
> > 
> > 
> > 
