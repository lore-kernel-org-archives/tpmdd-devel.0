From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 3/3] tpm/tpm_crb: Enable TPM CRB interface
	for ARM64
Date: Fri, 10 Mar 2017 13:50:04 -0600
Message-ID: <58C3036C.2050808@codeaurora.org>
References: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>
	<1489139889-14376-4-git-send-email-anjiandi@codeaurora.org>
	<20170310170216.GD22960@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170310170216.GD22960-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 03/10/17 11:02, Jason Gunthorpe wrote:
> On Fri, Mar 10, 2017 at 03:58:09AM -0600, Jiandi An wrote:
>
>>   	tristate "TPM 2.0 CRB Interface"
>> -	depends on X86 && ACPI
>> +	depends on (X86 || ARM64) && ACPI
>
> Oh, and why is the X86 even here?
>
> Surely it should just be 'depends on ACPI'? I don't remember anything
> x86 specific in CRB?
>
> Jason
>

During testing of my patches on ARM64, I hit crb_cmd_ready() and
crb_go_idle() that fails.  Looking at the comment and commit history,
it was added for fixing Intel PTT hw bug in Skylake and Broxton.
The functions themselves do nothing if flag is CRB_FL_ACPI_START.
I added CRB_FL_CRB_SMC_START which is the new ARM64 start method for
those two functions to also do nothing.  So crb_cmd_ready() and
crb_go_idle() are only for when CRB_FL_ACPI_START.

And in crb_acpi_add(), there is also comments on what drives
CRB_FL_CRB_START to be set.  ACPI_TPM2_COMMAND_BUFFER or
ACPI_TPM2_MEMORY_MAPPED

/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
  * report only ACPI start but in practice seems to require both
  * ACPI start and CRB start.
  */

I didn't have too much background on the CRB driver for X86.  I
thought to be safe just or in ARM64.  But if you see no issues,
I'll remove (X86 || ARM64) and just make it depend on ACPI.

Thanks.
- Jiandi

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
