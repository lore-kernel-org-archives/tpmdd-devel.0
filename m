From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 08/10] tpm: Driver for supporting
 multiple emulated TPMs
Date: Sat, 5 Mar 2016 00:34:10 +0200
Message-ID: <20160304223410.GA12143@intel.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160304202928.GA32617@intel.com>
	<201603042112.u24LCT7q016369@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603042112.u24LCT7q016369-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 04, 2016 at 04:16:41PM -0500, Stefan Berger wrote:
>    > > +static ssize_t vtpm_fops_write(struct file *filp, const char __user
>    *buf,
>    > > +                size_t count, loff_t *off)
>    > > +{
>    > > +   struct vtpm_dev *vtpm_dev = filp->private_data;
>    > > +
>    > > +   if (count > sizeof(vtpm_dev->buffer) ||
>    > > +       !(vtpm_dev->state & STATE_WAIT_RESPONSE_FLAG))
>    > > +      return -EIO;
>    >
>    > This is not atomic in any sense. You should move this statement after
>    > taking buf_lock.
> 
>    set_bit and friends were all atomic. Now we need to put all of these into
>    the mutex... ?

Hmm... but you have other fields too in struct vtpm_dev so you anyway
need to use mutex for concurrent access to the file. In that statement
you are accessing two fields from that structure.

Lets say someone forks 100 processes that concurrently access this
same open file. How else you would keep the state of vtpm_dev coherent
than protecting with a mutex?

Maybe the problem is that you are only thinking a proper way to use
this infrastructure?

>       Stefan

/Jarkko

------------------------------------------------------------------------------
