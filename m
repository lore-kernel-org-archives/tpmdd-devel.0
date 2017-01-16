From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] tpm: enhance TPM 2.0 PCR extend to
 support multiple banks
Date: Mon, 16 Jan 2017 11:41:05 +0200
Message-ID: <20170116094105.k2vuf3cclippkbye@intel.com>
References: <1484240290-4306-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1484240290-4306-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20170112182044.hehe5d5fblecejwo@intel.com>
	<58787E47.3010908@linux.vnet.ibm.com>
	<20170113164315.kxbdhchoi64jy44p@intel.com>
	<o5bcp5$9tn$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <o5bcp5$9tn$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 03:19:59PM -0500, Ken Goldman wrote:
> On 1/13/2017 11:43 AM, Jarkko Sakkinen wrote:
> 
> >>>> +struct tpml_digest_values {
> >>>> +	u32 count;
> >>>> +	struct tpmt_ha digests[TPM2_ACTIVE_PCR_BANKS];
> >>>> +} __packed;
> >>>
> >>> Please remove this structure.
> >>
> >> Sorry Jarkko, I didn't understand this comment.
> >> Why do we want to remove this structure.
> >
> > Well it is only used to pass two parameters.
> 
> Might it be good in general to reuse TPM Part 2
> structures?  For someone familiar with the TPM
> spec, it could make reading the device driver code
> easier.

Having a structure to encapsulate two parameters is an overkill.

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
