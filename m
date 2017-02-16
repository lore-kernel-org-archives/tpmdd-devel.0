From: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Thu, 16 Feb 2017 21:01:17 +0000
Message-ID: <CB2C93A3-6F29-4511-8FDD-B29D98FA235C@gmail.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<20170216202754.zokzcn6l4pd7hvbm@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170216202754.zokzcn6l4pd7hvbm-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


> On 16 Feb 2017, at 8:27 pm, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> On Thu, Feb 16, 2017 at 06:26:29PM +0000, Davide Guerri wrote:
>>   No lines including the requested range:
>> 
>>   fed10000-fed17fff : pnp 00:06
>> 
>>   fed18000-fed18fff : pnp 00:06
>> 
>>   fed19000-fed19fff : pnp 00:06
>> 
>>   fed20000-fed3ffff : pnp 00:06
>> 
>>   fed40000-fed4087f : MSFT0101:00
> 
> It really looks like that the BIOS is reporting wrong value.
> Have you tried to update it?
> 
> /Jarkko

Hi Jarkko,
I apologise for having used an HTML user agent, I hadn't one configured for this account and I just used the google UI.

So, I can try upgrading it. But I wonder whether acpi_enforce_resources=lax would work around the issue.
I am trying that later and I will let you know.

Thanks,
 Davide.
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
