From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/4] tpm: introduce tpm_pcr_algorithms()
Date: Wed, 5 Apr 2017 16:57:36 +0300
Message-ID: <20170405135736.q6puqquevsnxmwzb@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-4-roberto.sassu@huawei.com>
	<20170405121331.w5njxsf3nrztvlzb@intel.com>
	<f422a7e4-e214-b426-3be0-49d1a5560575@huawei.com>
	<20170405135418.nagoj6s2oi2m67qb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170405135418.nagoj6s2oi2m67qb-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 05, 2017 at 04:54:18PM +0300, Jarkko Sakkinen wrote:
> On Wed, Apr 05, 2017 at 03:33:55PM +0200, Roberto Sassu wrote:
> > On 4/5/2017 2:13 PM, Jarkko Sakkinen wrote:
> > > On Wed, Mar 29, 2017 at 12:24:51PM +0200, Roberto Sassu wrote:
> > > > Return the algorithms supported by the TPM. The limit
> > > > (TPM_ACTIVE_BANKS_MAX) has been exported to include/linux/tpm.h.
> > > > 
> > > > Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > 
> > > Why is this needed?
> > 
> > The reason of exporting the limit is that this simplifies the
> > code dealing with information returned by the TPM driver interface.
> > 
> > The new function tpm_pcr_algorithms() can accept as input a static
> > array, instead of returning a dynamic array that must be freed
> > by the caller.
> > 
> > Since the size of the dynamic array would have been the same of
> > that of the active_banks array, member of the tpm_chip structure,
> > and since the limit is small, the choice of using static arrays
> > seems reasonable.
> > 
> > Roberto
> 
> Still sounds confusing. Or to be honest (and I don't mean to be
> mean): I still don't get this at all.
> 
> You are adding bunch of functions that somehow "add flexibility".
> I still don't have any context how IMA is using these. Maybe in
> the next version of the patch set you coud write some kind of
> simple usage example to the cover letter that would cover how
> these are supposed to be used.
> 
> You hardly even metion IMA anywhere. It's fine to explain same
> things in both IMA and TPM patches in this case where both
> maintainers have to understand the context rather than kind of
> delegate that work to the maintainers :-)
> 
> /Jarko

And you should have linux-kernel in your CC list since this is not an
RFC patch set but something that you think is ready enough to a kernel
release. For bigger patch sets like this I would recommend also
linux-security-module.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
