From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: Handle 64-bit resource in crb_check_resource()
Date: Tue, 3 Jan 2017 19:11:49 +0200
Message-ID: <20170103171149.pwrbhy5uw4cqvwn4@intel.com>
References: <1482121253-924-1-git-send-email-anjiandi@codeaurora.org>
	<20161219135624.2e7okpswnbqbvic7@intel.com>
	<5858CD6F.5000909@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5858CD6F.5000909-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Dec 20, 2016 at 12:19:27AM -0600, Jiandi An wrote:
> The control area buffer is specified in the TPM2.0 static ACPI table.  TPM
> CRB driver maps the control area address and reads out cmd and rsp buffer
> addresses and maps them.  There is no requirement in the TCG TPM ACPI spec
> for specifying _CRS to describe the control area buffer.  When I rebased
> the early prototype for CRB driver ARM64 enablement to the latest kernel,
> I hit this issue where I have to specify _CRS method.  So in _CRS method
> I specify the same control area address that's in the TPM2.0 static ACPI table.
> 
> I see the _CRS requirement in the CRB driver is for resource synchronization
> between the TIS and CRB drivers to support force mode in TIS. Could I get some
> background on that so I could be more careful not breaking TIS while making
> changes to CRB driver for ARM64 enablement?

At least couple of reasons:

- _CRS is required to access locality registers (check my patch set
  that is waiting for review/testing).
- On x86 and PTT _CRS always exists and that's the only platform
  where this driver has been used so far.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
