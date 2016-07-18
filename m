From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: support driver-specific sysfs
 attrs in tpm_tis_core
Date: Mon, 18 Jul 2016 12:17:31 -0700
Message-ID: <20160718191731.GA1706@apronin>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
	<1468547496-16215-3-git-send-email-apronin@chromium.org>
	<20160718191141.GO31463@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160718191141.GO31463-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jul 18, 2016 at 10:11:41PM +0300, Jarkko Sakkinen wrote:
> On Thu, Jul 14, 2016 at 06:51:36PM -0700, Andrey Pronin wrote:
> > Add attr_group to phy_ops that a driver relying on tpm_tis_core_init
> > can set to have its specific attributes registered in sysfs.
> > 
> > Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm-sysfs.c    | 1 -
> >  drivers/char/tpm/tpm.h          | 8 +++++++-
> >  drivers/char/tpm/tpm_tis_core.c | 3 +++
> >  drivers/char/tpm/tpm_tis_core.h | 1 +
> >  4 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> > index 95ce90d..22c9874 100644
> > --- a/drivers/char/tpm/tpm-sysfs.c
> > +++ b/drivers/char/tpm/tpm-sysfs.c
> > @@ -304,7 +304,6 @@ void tpm_sysfs_add_device(struct tpm_chip *chip)
> >  	 * is called before ops is null'd and the sysfs core synchronizes this
> >  	 * removal so that no callbacks are running or can run again
> >  	 */
> > -	WARN_ON(chip->groups_cnt != 0);
> 
> You should explain this in a commit message if you want to remove it.
> 
> In general, this make user space API vendor specific, which is
> unacceptable.
> 
> /Jarkko
>

I will drop the vendor-specific part of the patchset and just submit
tpm2-specific sysfs attributes in the next rev. WARN_ON will not be
removed.


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
