From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/4] tpm: introduce
	tpm_extend_pcr_digests()
Date: Fri, 7 Apr 2017 22:31:56 +0300
Message-ID: <20170407193156.thwubykqqleaszrt@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-5-roberto.sassu@huawei.com>
	<20170405121416.2rly5pizs2hll56k@intel.com>
	<259b67e8-216b-ad91-52c3-c4b39a8f3d1c@huawei.com>
	<88284005-3a53-1b37-e1f2-bfa88987c989@huawei.com>
	<e6444fe7-5726-c763-0fd5-93b1c3ec47f6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e6444fe7-5726-c763-0fd5-93b1c3ec47f6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

On Fri, Apr 07, 2017 at 11:50:49AM +0200, Roberto Sassu wrote:
> On 4/5/2017 4:36 PM, Roberto Sassu wrote:
> > I have a question. As you can see in the IMA patch, I'm calling
> > tpm_is_tpm2() to determine if I should invoke tpm_pcr_extend(),
> > for TPM 1.2, or tpm_pcr_extend_digests(), for TPM 2.0.
> > 
> > Should the new function work with TPM 1.2? If a tpm2_digest
> > structure with a SHA1 digest is provided, I could call
> > tpm_pcr_extend() instead of returning an error.
> 
> Hi Jarkko
> 
> would you have any objection if the new functions work
> regardless of the TPM version?
> 
> Thanks
> 
> Roberto

Yes, you should not add multiple functions that do the same thing
essentially. Please rework tpm_pcr_extend instead.

And while you are doing it, please also rework it to use tpm_buf
for everything.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
