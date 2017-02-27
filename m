From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device
 link /dev/tpms<n>
Date: Mon, 27 Feb 2017 10:28:34 -0700
Message-ID: <20170227172834.GH5891@obsidianresearch.com>
References: <1487941328.2249.23.camel@HansenPartnership.com>
	<20170224173922.qwuhfxeitbyct52o@intel.com>
	<20170224181126.GC22491@obsidianresearch.com>
	<1487968155.2190.14.camel@HansenPartnership.com>
	<20170224205200.GA26547@obsidianresearch.com>
	<1487977260.2190.17.camel@HansenPartnership.com>
	<20170224232327.GA9126@obsidianresearch.com>
	<1487979807.2190.24.camel@HansenPartnership.com>
	<20170225002514.GA10605@obsidianresearch.com>
	<1488042289.2250.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488042289.2250.22.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Feb 25, 2017 at 12:04:49PM -0500, James Bottomley wrote:

> >  device cgroup blocks access to the cdevs of tpm0 but not to the
> > sysfs files.
> 
> What the device cgroup currently does for us and what it could do are
> two different things.  It seems if it exported
> __devcgroup_check_permission, we could use that as a check to gate the
> sysfs file access.

Make sense, maybe we should be doing that..

Stefan, are you still interested in this? This seems like a fairly
simple solution to your problem???

> > I am talking about using a situation like kernel IMA or keyring in 
> > the container with a tpm that is not tpm0, eg a vtpm.
> 
> a vtpm appears as a tpm device so it can be controlled by the device
> cgroup ... I think I'm not seeing the issue.

When an in-kernel call opens the TPM it does not go through the cdev,
it does something like this:

extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);

And hardwires 'chip_num' to TPM_ANY_NUM. Keyring does the same (see
trusted_instantiate)

Practically speaking this means in-kernel callers pretty much always
operate on tpm0.

I think we need to change TPM_ANY_NUM to something more container
friendly, but I'm not sure what that should be.

> be done at all) it's usually better to start with use cases.  So
> instead of saying we need to virtualize the PCRs we should start with X
> container has this requirement for attestation of its Y state.  Often
> the best way simply is an extension of the multi user model for the
> resource ... in this case no-one's really come up with one for PCRs, so
> that might be the place to begin.

Broadly makes sense to me.

Maybe kernel keyring is a better example, it already has a multi-user
model.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
