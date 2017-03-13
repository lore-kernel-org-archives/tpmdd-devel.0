From: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM
 family version
Date: Mon, 13 Mar 2017 15:31:57 +0100
Message-ID: <20170313143157.GE748@lunn.ch>
References: <1489396817-24855-1-git-send-email-Meng.Li@windriver.com>
	<20170313115415.2czyr4woaq4h3ncr@intel.com>
	<529F9A9100AE8045A7A5B5A00A39FBB83DE9325F@ALA-MBC.corp.ad.wrs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <529F9A9100AE8045A7A5B5A00A39FBB83DE9325F-/c0cZIGrDsgyzarUywkIaosyD1qQU09I@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Li, Meng" <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 13, 2017 at 12:54:24PM +0000, Li, Meng wrote:
> 
> 
> > -----Original Message-----
> > From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> > Sent: Monday, March 13, 2017 7:54 PM
> > To: Li, Meng
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; peterhuewe-Mmb7MZpHnFY@public.gmane.org;
> > tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; tpmdd-
> > devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM family version
> > 
> > On Mon, Mar 13, 2017 at 05:20:17PM +0800, Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> > > From: Limeng <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > >
> > > So far, there is not a sysfs interface for user space code to check
> > > the TPM family version(TPM1.x or TPM2). So, add a file named
> > > description in /sys/class/tpm/tpmX/ to show it.
> > >
> > > Signed-off-by: Meng Li <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > > ---
> > 
> > Is this the first or which version of the patch is this? Version number and
> > changelog are missing :/
> 
> Hi Jarkko,
> 
> This is the second version of this patch. The first one is reviewed by Peter who give out some good advices.
> 
> It is my first time to submit patch to upstream(main line),

A tip for you then. Wait at least one day between patch versions. That
gives people time to comment on your patches, and you can fix many
different issues at once.

> and I am not very clear with the submitting rule.

A good start is:

Documentation/process/submitting-patches.rst

> So, could you please give me a template to record the version and changing log?

After the --- write one line per change you made from the previous
version. Also, v3 should also contain the v2 change history etc...

Picking a random example from the web:

http://patchwork.ozlabs.org/patch/710615/

	Andrew

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
