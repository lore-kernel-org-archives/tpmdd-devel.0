From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [Linux-ima-devel] [PATCH 0/4] Extend TPM 2.0 PCR
 banks each with corresponding digest
Date: Wed, 5 Apr 2017 16:39:34 +0300
Message-ID: <20170405133934.uv4bqxql525yjq3m@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170405121617.kpdrtuhb5ipj33ea@intel.com>
	<1491395052.2898.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491395052.2898.4.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 05, 2017 at 08:24:12AM -0400, Mimi Zohar wrote:
> Hi Jarkko,
> 
> On Wed, 2017-04-05 at 15:16 +0300, Jarkko Sakkinen wrote:
> > On Wed, Mar 29, 2017 at 12:24:48PM +0200, Roberto Sassu wrote:
> > > tpm_pcr_extend() was originally designed to extend a TPM 1.2 PCR with
> > > a SHA1 digest. With TPM 2.0, multiple hash algorithms can be supported,
> > > but, at the moment, only one digest can be passed to the function.
> > > 
> > > Since TCG mandates that all PCR banks must be extended, commit c1f92b4
> > > (tpm: enhance TPM 2.0 PCR extend to support multiple banks) filled
> > > the gap by padding the SHA1 digest passed to tpm_pcr_extend(), to extend
> > > remaining PCR banks.
> > > 
> > > This patch set adds support for providing a digest for each PCR bank.
> > > 
> > > The first patch adds an additional check to tpm2_pcr_extend() to ensure
> > > that all digests have been provided (to meet TCG specs).
> > > 
> > > The second patch provides a mechanism for TPM users to convert a TPM
> > > algorithm ID to a crypto ID and vice-versa, so that they can calculate
> > > the digest of an event data by using the crypto subsystem.
> > > 
> > > The third patch allows TPM users to know which hash algorithms the TPM
> > > supports. Since the limit of active banks is fixed (the size of the
> > > active_banks array in the tpm_chip structure), the new function
> > > tpm_pcr_algorithms() accepts as input a sized array.
> > > 
> > > The fourth patch introduces tpm_pcr_extend_digests(), which accepts
> > > as input a sized array of tpm2_digest structures. Each array element
> > > contains the algorithm and the digest for a PCR bank.
> > 
> > I don't understand why you are making these changes and why put the
> > commit messages in the cover letter and not in the commits where you
> > merely have the short summary.
> 
> These patches are prereqs for IMA to extend multiple TPM banks
> directly and include multiple hashes in the IMA measurement list.
> 
> Mimi

Thanks Mimi.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
