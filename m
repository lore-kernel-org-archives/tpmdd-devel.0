From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 04/11] tpm: Provide strong locking for
	device removal
Date: Mon, 22 Feb 2016 15:20:17 -0700
Message-ID: <20160222222017.GC27228@obsidianresearch.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222210844.GA3310@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160222210844.GA3310-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 22, 2016 at 11:08:59PM +0200, Jarkko Sakkinen wrote:
> On Fri, Feb 19, 2016 at 07:42:01AM -0500, Stefan Berger wrote:
> > From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > 
> > Add a read/write semaphore around the ops function pointers so
> > ops can be set to null when the driver un-registers.
> > 
> > Previously the tpm core expected module locking to be enough to
> > ensure that tpm_unregister could not be called during certain times,
> > however that hasn't been sufficient for a long time.
> 
> Could you be more concrete with the scenario? You could describe
> a sequence of events where this could happen.

echo 1 > /sys/.../remove

Is basically the same as a module unload without requiring module
unload. module locking cannot be relied upon for correctness like this
ever since hot remove was added to the kernel.

> > + * @chip: Chip to ref
> > + *
> > + * The caller must already have some kind of locking to ensure that chip is
> 
> What do you mean when you use the term "some kind of locking"?

Eg the IDR lookup code uses a idr specific mutex. The char device uses
a ref held by the cdev subsystem.

> > +void tpm_put_ops(struct tpm_chip *chip)
> > +{
> > +	module_put(chip->dev.parent->driver->owner);
> > +	up_read(&chip->ops_sem);
> > +	put_device(&chip->dev);
> > +}
> > +EXPORT_SYMBOL_GPL(tpm_put_ops);
> 
> I'm just thinking is the try_module_get() and module_put() even
> necessary after this change? You know that device is not unregistered
> from chip->ops field, which is protected by that RW-semaphore.

The module locking is not about correctness. Some subsystems will hold
the module lock on their driver specifically to prevent rmmod as a
hint to the user that the driver module is being used by an open
/dev/tpmX for instance. Eg rtc does that.

We need to decide if we want that for TPM or not. Orthogonal issue.

I'm OK with getting rid of the module lock, TPM has a long lived
user space daemon, rtc does not.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
