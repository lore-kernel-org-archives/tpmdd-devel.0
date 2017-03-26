From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4] tpm_crb: request and relinquish
	locality 0
Date: Sun, 26 Mar 2017 13:52:39 +0300
Message-ID: <20170326105239.dgohwest2wmwynrd@intel.com>
References: <20170324101032.13496-1-jarkko.sakkinen@iki.fi>
	<87lgru7cqy.fsf@redhat.com>
	<20170325195211.w2gfmodozgwrfxy6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170325195211.w2gfmodozgwrfxy6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Jarkko Sakkinen <jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 25, 2017 at 09:52:11PM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 24, 2017 at 11:25:57AM -0700, Jerry Snitselaar wrote:
> > 
> > Jarkko Sakkinen @ 2017-03-24 10:10 GMT:
> > 
> > > This commit adds support for requesting and relinquishing locality 0 in
> > > tpm_crb for the course of command transmission.
> > >
> > > In order to achieve this, two new callbacks are added to struct
> > > tpm_class_ops:
> > >
> > > - request_locality
> > > - relinquish_locality
> > >
> > > With CRB interface you first set either requestAccess or relinquish bit
> > > from TPM_LOC_CTRL_x register and then wait for locAssigned and
> > > tpmRegValidSts bits to be set in the TPM_LOC_STATE_x register.
> > >
> > > The reason why were are doing this is to make sure that the driver
> > > will work properly with Intel TXT that uses locality 2. There's no
> > > explicit guarantee that it would relinquish this locality. In more
> > > general sense this commit enables tpm_crb to be a well behaving
> > > citizen in a multi locality environment.
> > >
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > Reviewed-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Tested-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Tested on kabylake system that was hitting issues with earlier
> > iteration. Still don't have platform to test it dealing with
> > multi-locality enviroment.
> 
> I believe Jimmy (Gang Wei) has done such testing. Jimmy can you confirm
> and possibly do re-test (there's a locality branch in my tree to ease
> the testing) so that we could land this one?
> 
> /Jarkko

I applied this to my master and next branches.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
