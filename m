From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 4/9] tpm: drop
	tpm1_chip_register(/unregister)
Date: Thu, 24 Nov 2016 00:03:39 +0530
Message-ID: <5835E103.90600@linux.vnet.ibm.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479117656-12403-5-git-send-email-nayna@linux.vnet.ibm.com>
	<20161122112200.55khdxtctt5rel4j@intel.com>
	<20161122164240.GC3956@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161122164240.GC3956-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/22/2016 10:12 PM, Jason Gunthorpe wrote:
> On Tue, Nov 22, 2016 at 01:22:00PM +0200, Jarkko Sakkinen wrote:
>> On Mon, Nov 14, 2016 at 05:00:51AM -0500, Nayna Jain wrote:
>>> Check for TPM2 chip in tpm_sysfs_add_device, tpm_bios_log_setup and
>>> tpm_bios_log_teardown in order to make code flow cleaner and to enable
>>> to implement TPM 2.0 support later on. This is partially derived from
>>> the commit by Nayna Jain with the extension that also tpm1_chip_register
>>> is dropped.
>>>
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>
>> This commit remains unreviewed and tested. I'm in the author role here
>> so I cannot help with this. If that does not happen soon I cannot put
>> this into the pull request.
>
> I tested it on my ARM system when I tested your branch.
>
> I think it looks better this way..
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> Jason
>

 From my side also, as part of testing the whole patchset, I have tested 
this patch.

Tested-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Thanks & Regards,
   - Nayna


------------------------------------------------------------------------------
