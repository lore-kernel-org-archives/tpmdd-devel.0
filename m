From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v3 5/5] tpm2: expose resource manager
 via	a device link /dev/tpms<n>
Date: Sun, 22 Jan 2017 22:24:53 +0200
Message-ID: <20170122202453.6oibbehxtxxokf7y@intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
	<20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
	<1484751663.2717.10.camel@HansenPartnership.com>
	<20170119104922.vhgz4rxw6yzdrxqt@intel.com>
	<1484828380.3140.11.camel@HansenPartnership.com>
	<20170120133914.2wk43nteh2hh7n3c@intel.com>
	<20170120210522.glx4y4oui36oimld@intel.com>
	<1485107342.2504.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485107342.2504.7.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

On Sun, Jan 22, 2017 at 09:49:02AM -0800, James Bottomley wrote:
> On Fri, 2017-01-20 at 23:05 +0200, Jarkko Sakkinen wrote:
> > 'tabrm4' branch has been now rebased. It's now on top of master
> > branch
> > that contains Stefan's latest patch (min body length check) that I've
> > reviewed and tested. It also contains your updated /dev/tpms patch.
> > 
> > I guess the 5 commits that are there now are such that we have fairly
> > good consensus, don't we? If so, can I add your reviewed-by and
> > tested-by to my commits and vice versa?
> 
> We're still failing my test_transients.  This is the full python of the
> test case:
> 
> 
>     def test_transients(self):
>         k = self.open_transients()
>         self.c.flush_context(k[0])
>         self.c.change_auth(self.c.SRK, k[1], None, pwd1)
>         ...
> 
> It's failing at self.c.flush_context(k[0]) with TPM_RC_VALUE.  It's the
> same problem Ken complained about: TPM2_FlushContext doesn't have a
> declared handle area so we don't translate the handle being sent down. 
>  We have to fix this either by intercepting the flush and manually
> translating the context, or by being dangerously clever and marking
> flush as a command which takes one handle.

I'll add interception of flush to the next patch set version.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
