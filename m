From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Few st33zp24 fixes
Date: Wed, 23 Mar 2016 09:21:06 +0100
Message-ID: <56F251F2.6050709@gmail.com>
References: <1458719734-13752-1-git-send-email-christophe-h.ricard@st.com>
	<20160323081755.GA6434@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160323081755.GA6434-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

No problem, i will adapt to your feedback.
I have seen you are working on cleaning up tpm_chip and 
tpm_vendor_specific structures which i am doing as well
since then.

May i ask you to try to keep me in copy of this topic so that i don't 
scratch my head looking at what's on going on the mailing list ?

Thanks a lot.
Best Regards
Christophe

On 23/03/2016 09:17, Jarkko Sakkinen wrote:
> On Wed, Mar 23, 2016 at 08:55:31AM +0100, Christophe Ricard wrote:
>> Hi Jarkko,
>>
>> After my first tentative and as discussed, please find a dedicated
>> st33zp24 serie intends to provide few fixes on acpi probing and code
>> style improvement.
> Thanks. This is also your benefit because these patches probably get
> reviewed and merged much faster whereas other patches might go for a few
> cycles before taken be accepted.
>
>> Best Regards
>> Christophe
> /Jarkko
>
>> Christophe Ricard (3):
>>    tpm/st33zp24/i2c: Drop two useless checks in ACPI probe path
>>    tpm/st33zp24/spi: Drop two useless checks in ACPI probe path
>>    tpm/st33zp24: Remove unneeded tpm_reg in get_burstcount
>>
>>   drivers/char/tpm/st33zp24/i2c.c      | 13 +------------
>>   drivers/char/tpm/st33zp24/spi.c      | 13 +------------
>>   drivers/char/tpm/st33zp24/st33zp24.c | 10 +++++-----
>>   3 files changed, 7 insertions(+), 29 deletions(-)
>>
>> -- 
>> 2.5.0
>>


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
