From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 1/3] tpm: move event log init functions
 to tpm_eventlog_init.c
Date: Thu, 24 Nov 2016 13:31:03 +0530
Message-ID: <58369E3F.40509@linux.vnet.ibm.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479922057-8752-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20161123193830.GB13927@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161123193830.GB13927-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/24/2016 01:08 AM, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 12:27:35PM -0500, Nayna Jain wrote:
>> The device driver code for the event log has the init functions and
>> TPM 1.2 parsing logic both defined in same file(tpm_eventlog.c).
>>
>> Since the initialization functions are common with the TPM 2.0 event
>> log support, this patch splits tpm_eventlog.c to have only TPM 1.2
>> event log parsing logic and moves the init functions into
>> tpm_eventlog_init.c.
>
> I think I'd rather see a tpm_eventlog1.c/tpm_eventlog2.c than this
> _init thing..

Do you mean tpm_eventlog1.c for TPM 1.2 and tpm_eventlog2.c for TPM 2.0 
  event log specific parsing ?

And if so, then which one should have the common functions for TPM 1.2 
and TPM 2.0 ?

Thanks & Regards,
    - Nayna

>
> Jason
>


------------------------------------------------------------------------------
