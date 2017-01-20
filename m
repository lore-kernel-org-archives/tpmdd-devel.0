From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v3 5/5] tpm2: expose resource manager
 via	a device link /dev/tpms<n>
Date: Fri, 20 Jan 2017 23:05:22 +0200
Message-ID: <20170120210522.glx4y4oui36oimld@intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
	<20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
	<1484751663.2717.10.camel@HansenPartnership.com>
	<20170119104922.vhgz4rxw6yzdrxqt@intel.com>
	<1484828380.3140.11.camel@HansenPartnership.com>
	<20170120133914.2wk43nteh2hh7n3c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170120133914.2wk43nteh2hh7n3c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 20, 2017 at 03:39:14PM +0200, Jarkko Sakkinen wrote:
> On Thu, Jan 19, 2017 at 07:19:40AM -0500, James Bottomley wrote:
> > On Thu, 2017-01-19 at 12:49 +0200, Jarkko Sakkinen wrote:
> > > On Wed, Jan 18, 2017 at 10:01:03AM -0500, James Bottomley wrote:
> > > > On Mon, 2017-01-16 at 15:12 +0200, Jarkko Sakkinen wrote:
> > > > > From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > > > > 
> > > > > Currently the Resource Manager (RM) is not exposed to userspace. 
> > > > >  Make this exposure via a separate device, which can now be 
> > > > > opened multiple times because each read/write transaction goes 
> > > > > separately via the RM.
> > > > > 
> > > > > Concurrency is protected by the chip->tpm_mutex for each 
> > > > > read/write transaction separately.  The TPM is cleared of all 
> > > > > transient objects by the time the mutex is dropped, so there 
> > > > > should be no interference between the kernel and userspace.
> > > > 
> > > > There's actually a missing kfree of context_buf on the tpms_release
> > > > path as well.  This patch fixes it up.
> > > 
> > > Can you send me a fresh version of the whole patch so that I can 
> > > include to v4 that includes also changes that I requested in my 
> > > recent comments + all the fixes?
> > 
> > Sure, I think the attached is basically it
> > 
> > James
> 
> Thank you!

'tabrm4' branch has been now rebased. It's now on top of master branch
that contains Stefan's latest patch (min body length check) that I've
reviewed and tested. It also contains your updated /dev/tpms patch.

I guess the 5 commits that are there now are such that we have fairly
good consensus, don't we? If so, can I add your reviewed-by and
tested-by to my commits and vice versa?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
