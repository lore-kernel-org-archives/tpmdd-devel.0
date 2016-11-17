From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] tpm: refactor tpm2_get_tpm_pt to
 tpm2_getcap_cmd
Date: Thu, 17 Nov 2016 09:42:41 -0800
Message-ID: <20161117174241.wvyd7g5lj4ibfnry@intel.com>
References: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1476008057-2395-3-git-send-email-jarkko.sakkinen@linux.intel.com>
	<58254759.80406@linux.vnet.ibm.com>
	<20161112000242.63hgv5ujmkr7hy6a@intel.com>
	<582D998C.40605@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <582D998C.40605-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 17, 2016 at 05:20:36PM +0530, Nayna wrote:
 
> I tested this for capability TPM2_CAP_PCRS. It seems TPM2_CAP_PCRS
> capability always returns full PCR allocation, and more_data as 0, So, I
> think the idea of looping over based on more_data may not work for this
> capability.

You can always request one value at a time until there's no more.

If you request N values, depending on the hardware, the hardware returns
to you anything from 1 to N values. If you implement a function that
requests N values in the command, you *must* handle the case where
moreData is 1 even if the hardware you are testing that never happens.

That's the reason why I would start with a function that you request one
property of one capability and optimize it in future if it doesn't scale
for some workload.

Do you have a workload where it doesn't scale?

/Jarkko

------------------------------------------------------------------------------
