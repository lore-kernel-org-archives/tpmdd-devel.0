From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/4] tpm: introduce
 tpm2_pcr_algo_to_crypto() and tpm2_pcr_algo_from_crypto()
Date: Wed, 5 Apr 2017 16:43:16 +0300
Message-ID: <20170405134316.bnlaqqo2uz5lncau@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-3-roberto.sassu@huawei.com>
	<20170405121256.jyyj474dux5cb62m@intel.com>
	<96aeb2ef-5b0b-7c10-cbf1-7f51aeb902ae@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <96aeb2ef-5b0b-7c10-cbf1-7f51aeb902ae-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

On Wed, Apr 05, 2017 at 03:03:16PM +0200, Roberto Sassu wrote:
> On 4/5/2017 2:12 PM, Jarkko Sakkinen wrote:
> > On Wed, Mar 29, 2017 at 12:24:50PM +0200, Roberto Sassu wrote:
> > > Introduce these functions to convert between TPM and crypto algorithm IDs.
> > 
> > Why is this needed?
> 
> I'm sorry for the short explanation. I will provide a detailed
> description in the reply of your emails and add the text in
> the next version of the patch set.
> 
> Currently, tpm_pcr_extend(), for extending a PCR, accepts as input
> the SHA1 of an event data. Extending PCRs is needed in order to protect
> the integrity of an event log (e.g. the IMA measurements list).
> 
> With TPM 2.0, it is necessary to expose new functions because
> the event data digest can be calculated with multiple algorithms.
> 
> TPM 2.0 introduced new challenges that were not present before.
> How users of the TPM:
> 
> - know which algorithms the TPM supports?
> 
> - can provide multiple digests to the TPM driver interface?
> 
> - can calculate the digest of event data, since the TPM driver
>   stores TPM algorithm IDs, which are different from IDs defined
>   by the crypto subsystem?
> 
> The patch set I published tries to address these challenges.
> 
> Regarding the type of data that should be returned to TPM users,
> the choice I made was to return to TPM users the TPM algorithms IDs
> (instead of IDs defined by the crypto subsystem).
> 
> This way, I give to TPM users the flexibility to decide what
> information they provide to consumers of the event log (TPM or
> crypto IDs) and the possibility to calculate the event data
> digest with the crypto subsystem.
> 
> Roberto

Which one is needed for IMA? I mean for in-kernel API you should not add
any extra flexibility. Please implement the patch set with the minimal
flexibility in mind. Just enough to get IMA uses cases done and explain
in the commit messages your rationale based on requirements of the IMA.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
