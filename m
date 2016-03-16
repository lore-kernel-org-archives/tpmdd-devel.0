From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: fix tpm_bios_log_setup stub prototype
Date: Wed, 16 Mar 2016 15:18:16 -0400
Message-ID: <56E9B178.9020300@linux.vnet.ibm.com>
References: <1458116410-3208536-1-git-send-email-arnd@arndb.de>
	<20160316101341.GA4051@intel.com>
	<20160316175726.GB6127@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160316175726.GB6127-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hon Ching (Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 03/16/2016 01:57 PM, Jason Gunthorpe wrote:
> On Wed, Mar 16, 2016 at 12:13:41PM +0200, Jarkko Sakkinen wrote:
>> On Wed, Mar 16, 2016 at 09:19:48AM +0100, Arnd Bergmann wrote:
>>> A cleanup patch changed the prototype of the regular tpm_bios_log_setup
>>> function, but not that of the stub that is used when the TPM is disabled,
>>> causing a harmless build warning:
>>>
>>> drivers/char/tpm/tpm-chip.c: In function 'tpm1_chip_register':
>>> drivers/char/tpm/tpm-chip.c:287:38: error: passing argument 1 of 'tpm_bios_log_setup' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>>>    chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
>>> In file included from ../drivers/char/tpm/tpm-chip.c:30:0:
>>> ../drivers/char/tpm/tpm_eventlog.h:83:31: note: expected 'char *' but argument is of type 'const char *'
>>>   static inline struct dentry **tpm_bios_log_setup(char *name)
>>>
>>> This changes the stub function to match the normal prototype,
>>> avoiding that warning.
>> Good catch. Thank you.
> The weird thing is I already applied this hunk to the patch, an
> autobuilder found it, it is right in my personal tree..
>
> Unclear where it got dropped? Are we missing anything else in that
> series? Stephen?

If I lost it, I certainly did not drop it intentionately.

    Stefan


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
