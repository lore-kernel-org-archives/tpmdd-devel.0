From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 8/8] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Sun, 9 Oct 2016 12:14:10 +0300
Message-ID: <20161009091409.GD31891@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-9-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001115154.GB8664@intel.com>
	<57F9A52C.7050405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57F9A52C.7050405-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

HI

On Sun, Oct 09, 2016 at 07:32:20AM +0530, Nayna wrote:
> 
> 
> On 10/01/2016 05:21 PM, Jarkko Sakkinen wrote:
> >On Wed, Sep 28, 2016 at 04:34:42AM -0400, Nayna Jain wrote:
> >>Unlike the device driver support for TPM 1.2, the TPM 2.0 support
> >>does not create the securityfs pseudo files for displaying the
> >>firmware event log.
> >>
> >>This patch enables support for providing the TPM 2.0 event log in
> >>binary form. TPM 2.0 event log supports a crypto agile format that
> >>records multiple digests, which is different from TPM 1.2. This
> >>patch adds the TPM 2.0 event log parser to understand the crypto
> >>agile format.
> >
> >I'll got through the patch (the split comment is valid)
> 
> Sure, will do it.

Please go through this series and see if they look good to you:

  https://lkml.org/lkml/2016/10/1/121

You should have them in your email archive (posted a week ago).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
