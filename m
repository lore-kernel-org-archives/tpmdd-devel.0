From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Mon, 16 Jan 2017 11:52:36 +0200
Message-ID: <20170116095236.dlhqf4ghv2xv2sas@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
	<20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
	<1484253532.5807.16.camel@linux.vnet.ibm.com>
	<20170113162855.dddgsomp7m4c3inc@intel.com>
	<o5dohv$60l$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <o5dohv$60l$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Jan 14, 2017 at 12:53:15PM -0500, Ken Goldman wrote:
> On 1/13/2017 11:28 AM, Jarkko Sakkinen wrote:
> 
> > > > +
> > > > +       if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
> > > > +               /* should never happen */
> > > > +               dev_err(&chip->dev, "TPM returned a different CC:
> > > > 0x%04x\n",
> > > > +                       cc);
> > > > +               rc = -EFAULT;
> > > > +               goto out_err;
> > > > +       }
> 
> Something is strange here.  Is "CC" command code?
> 
> The TPM does not return a command code.  The mapping should use the
> command code from the command.
> 
> It could be the code is correct - the command code mapped OK in the command
> but then failed in the response.  But the error message is strange.

Thanks. I'll update that message.

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
