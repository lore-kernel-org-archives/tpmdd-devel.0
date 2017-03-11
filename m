From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Add start method for ARM Secure
 Monitor Call
Date: Fri, 10 Mar 2017 18:44:53 -0600
Message-ID: <58C34885.9060900@codeaurora.org>
References: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>	<1489139889-14376-3-git-send-email-anjiandi@codeaurora.org>
	<20170310170017.GB22960@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170310170017.GB22960-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 03/10/17 11:00, Jason Gunthorpe wrote:
> On Fri, Mar 10, 2017 at 03:58:08AM -0600, Jiandi An wrote:
>
>> +/*
>> + * This is a TPM Command Response Buffer start method that invokes a
>> + * Secure Monitor Call to requrest the firmware to execute or cancel
>> + * a TPM 2.0 command.
>> + */
>> +static inline int tpm_crb_smc_start(unsigned long func_id)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_smc(func_id, 0, 0, 0, 0, 0, 0, 0, &res);
>> +	if (res.a0 != 0) {
>> +		WARN(1, "tpm_crb_smc_start() returns res.a0 = 0x%lx\n",
> res.a0);
>> +		return -EIO;
>
> I don't think either of these WARN's are appropriate.
>
> 'dev_err(FIRMWARE_BUG'  would be better.
>
> Jason

I will fix this in next version.  Waiting to see if there are
more comments from others.
Thanks
- Jiandi

>
> --------------------------------------------------------------------------
> ----
> Announcing the Oxford Dictionaries API! The API offers world-renowned
> dictionary content that is easy and intuitive to access. Sign up for an
> account today to start using our lexical data to power your apps and
> projects. Get started today and enter our developer competition.
> http://sdm.link/oxford
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>


-- 
Qualcomm Datacenter Technologies, Inc.
as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
