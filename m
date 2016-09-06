From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v3 4/7] tpm: Redefine the read_log method
	to check for ACPI/OF properties sequentially
Date: Tue, 06 Sep 2016 13:08:06 -0700
Message-ID: <2EF900B9-0A4D-44DB-B153-A71A194C16AC@gmx.de>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-5-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830175409.GD6373@obsidianresearch.com>
	<57C72B7A.8040108@linux.vnet.ibm.com>
	<20160906194737.GD28416@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160906194737.GD28416-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Am 6. September 2016 12:47:37 GMT-07:00, schrieb Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:
>On Thu, Sep 01, 2016 at 12:39:46AM +0530, Nayna wrote:
>> >>+int read_log_of(struct tpm_chip *chip);
>> >>+#else
>> >>+static inline int read_log_of(struct tpm_chip *chip)
>> >>+{
>> >>+	return -1;
>> >>+}
>> >>+#endif
>> >
>> >Though shouldn't these two be ERRNOs of some kind? -ENODEV?
>> 
>> Sure..
>> Was just trying to see possible errno. And here are some thoughts.
>> 
>> 
>> #define EPERM            1      /* Operation not permitted */
>> #define ENODEV          19      /* No such device */
>
>> Was thinking that since tpm device will still be present and its
>either ACPI
>> or OF way of accessing its properties, and one of them will return
>this
>> errno. So, assuming it is ACPI, that means no OF functions permitted.
>So,
>> how about using EPERM ?
>
>I'd choose ENODEV over EPERM, that is the usual way in the kernel to
>signal 'probe failed'

Me too, EPERM sounds more like the caller is lacking priviledge to do so.

>
>Remember, which ever it is, it should not cause any messages to be
>printed.
>
>Jason
>
>------------------------------------------------------------------------------
>_______________________________________________
>tpmdd-devel mailing list
>tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

-- 
Sent from my mobile

------------------------------------------------------------------------------
