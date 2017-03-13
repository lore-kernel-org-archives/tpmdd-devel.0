From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] tpm_crb: request and relinquish
	locality 0
Date: Mon, 13 Mar 2017 22:12:35 +0200
Message-ID: <20170313201235.tvcyugdh7awqfrfq@intel.com>
References: <20170311130216.21419-1-jarkko.sakkinen@linux.intel.com>
	<20170313163452.GD22997@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170313163452.GD22997-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 13, 2017 at 10:34:52AM -0600, Jason Gunthorpe wrote:
> On Sat, Mar 11, 2017 at 03:02:14PM +0200, Jarkko Sakkinen wrote:
> > Added two new callbacks to struct tpm_class_ops:
> > 
> > - request_locality
> > - relinquish_locality
> > 
> > These are called before sending and receiving data from the TPM.  We
> > update also tpm_tis_core to use these callbacks. Small modification to
> > request_locality() is done so that it returns -EBUSY instead of locality
> > number when check_locality() fails.
> 
> Make sense
> 
> I think you may as well do the other two drivers, even though you
> can't run them the transformation looks safe enough to me.
> 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >  drivers/char/tpm/tpm-interface.c |  9 +++++++++
> >  drivers/char/tpm/tpm_crb.c       | 41 +++++++++++++++++++++++++++++++++++++++-
> >  drivers/char/tpm/tpm_tis_core.c  | 12 ++++--------
> >  include/linux/tpm.h              |  3 ++-
> >  4 files changed, 55 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > index e38c792..9c56581 100644
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -407,6 +407,12 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> >  	if (chip->dev.parent)
> >  		pm_runtime_get_sync(chip->dev.parent);
> >  
> > +	if (chip->ops->request_locality)  {
> > +		rc = chip->ops->request_locality(chip, 0);
> > +		if (rc)
> > +			goto out;
> 
> If request_locality fails we probably shouldn't call
> relinquish_locality on the unwind path..
> 
> I think you should also put a relinquish_locality inside tpm_remove ?

Right. I was wondering why release_locality is called inside
tpm_tis_remove().

So is the idea of checking pendingRequest such that the release
part is "lazy" and not like what I'm doing in tpm_crb (always
relinquish).

Is that done for performance reasons? Should I do the same (pr
similar in tpm_crb?

> > +	int (*request_locality)(struct tpm_chip *chip, int loc);
> > +	void (*relinquish_locality)(struct tpm_chip *chip, int loc,
> > bool force);
> 
> Let us document what force is supposed to do...
> 
> I'm not sure why we have it?
> 
> Jason

I guess since it is lazy in tpm_tis_core the force is done in
tpm_tis_remove so that you always relinquish the locality even
if someone is not requesting it, right?

Where should this be documented, to the header?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
