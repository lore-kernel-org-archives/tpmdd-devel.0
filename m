From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 7/7] tpm: Adds securityfs support for
 TPM2.0 eventlog
Date: Tue, 30 Aug 2016 11:59:32 -0600
Message-ID: <20160830175932.GF6373@obsidianresearch.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-8-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472532619-22170-8-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Tue, Aug 30, 2016 at 12:50:19AM -0400, Nayna Jain wrote:
>  	if (chip->dev.of_node)
>  		np = chip->dev.of_node;
>  	if (!np) {
> -		dev_dbg(&chip->dev, "%s: ERROR - IBMVTPM not supported\n",
> +		dev_dbg(&chip->dev, "%s: ERROR - TPM not supported\n",
>  			__func__);

ERm, this is a mistake in the earlier patch that adds OF and ACPI
together.

Do not print anything if OF is present but no event log is
defined. Ditto for ACPI.

Do not print anything if there is no OF node either.

> +	if (!strcasecmp(compat, "IBM,vtpm"))

No, this is the wrong way to work with compatible lists. I'm pretty
sure there is an OF helper to do this.

> +		log_size = *sizep;

???

All DT values should be big endian. Please include a comment
explaining why this is would not be the case.

Are you certain this isn't just a pre-existing bug - the code assumed
host endian because it was always running on big endian PPC?

Jason

------------------------------------------------------------------------------
