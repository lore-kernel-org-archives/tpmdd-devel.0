From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_crb: mark PM functions as
	__maybe_unused
Date: Tue, 21 Mar 2017 08:37:13 +0100
Message-ID: <CAK8P3a1_0w7xOGXAczbYDE402GsnsbyRftsK3R0nuhCYiWT59g@mail.gmail.com>
References: <20170320091755.1043811-1-arnd@arndb.de>
	<5B8DA87D05A7694D9FA63FD143655C1B543B032E@hasmsx108.ger.corp.intel.com>
	<CAK8P3a25sh0U=N9E1pWACL_9h7VBseUBX50WZe5rXMpNHY=GbA@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B543B0620@hasmsx108.ger.corp.intel.com>
	<20170320230430.GA25163@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B543B0650@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B543B0650-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 21, 2017 at 12:35 AM, Winkler, Tomas
<tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>>
>> On Mon, Mar 20, 2017 at 11:01:36PM +0000, Winkler, Tomas wrote:
>>
>> > I believe that in this case the #ifdefs can be done correctly quite
>> > easily, but now I'm not against your solution as well, just maybe put
>> > some of this info to the commit message.
>>
>> I perfer fewer ifdefs, it makes it more maintainable..
>
> Sure,
>>
>> The compiler will remove unused static functions.
>
> I'm not sure if this goes away w/o --gc-sections, but it might.
> Will check, didn't looked at that for a while.

gcc-4.1 had a bug where code it failed to eliminate a dead function
if it was referenced through a function pointer in another unused
static function, but it would work correctly in this case (obviously
unused code) and compiler that people actually use don't have
this problem. Note that the kernel depends on dead code elimination
to work correctly in a lot of places, it wouldn't build at all if that
was broken.

      Arnd

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
