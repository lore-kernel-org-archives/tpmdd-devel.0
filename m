From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 8/8] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Fri, 30 Sep 2016 22:24:31 +0300
Message-ID: <20160930192431.GE9595@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-9-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475051682-23060-9-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 28, 2016 at 04:34:42AM -0400, Nayna Jain wrote:
> Unlike the device driver support for TPM 1.2, the TPM 2.0 support
> does not create the securityfs pseudo files for displaying the
> firmware event log.
> 
> This patch enables support for providing the TPM 2.0 event log in
> binary form. TPM 2.0 event log supports a crypto agile format that
> records multiple digests, which is different from TPM 1.2. This
> patch adds the TPM 2.0 event log parser to understand the crypto
> agile format.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/Makefile            |   2 +-
>  drivers/char/tpm/tpm-chip.c          |  26 ++---
>  drivers/char/tpm/tpm2.h              |  79 +++++++++++++
>  drivers/char/tpm/tpm2_eventlog.c     | 216 +++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_eventlog_init.c |  30 +++--
>  drivers/char/tpm/tpm_of.c            |  26 ++++-
>  6 files changed, 348 insertions(+), 31 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm2.h
>  create mode 100644 drivers/char/tpm/tpm2_eventlog.c

This commit is too large. It would have to be split into 'of' part
and generic part at minimum.

The bigger problem with this patch set is that it is for majority of
people untestable at this point. There is zero Tested-by's so far.

I think the clean up work would deserve its own patch set. That we
can digest to mainline with quicker schedule than TPM 2.0 part.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
