From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: override reported C and D
 timeouts for Atmel 3203
Date: Thu, 12 Jan 2017 22:37:31 +0100
Message-ID: <20f8645d-f3fd-550b-b830-d1e55b8f2d17@maciej.szmigiero.name>
References: <08953fb6-c332-ef29-2614-6335570023be@maciej.szmigiero.name>
	<20170112184229.GB12836@obsidianresearch.com>
	<259e1606-255b-5bf4-54bb-1bed967c228a@maciej.szmigiero.name>
	<20170112202055.uxabnu553qwqql72@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170112202055.uxabnu553qwqql72-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 12.01.2017 21:20, Jarkko Sakkinen wrote:
> On Thu, Jan 12, 2017 at 09:09:33PM +0100, Maciej S. Szmigiero wrote:
>> Hi Jason,
>>
>> On 12.01.2017 19:42, Jason Gunthorpe wrote:
(..)
>>> Can you also add a check for 0 timeouts in the core code and print a
>>> FW_BUG :\
>>
>> Hmm, I dug in history of tpm-interface.c and the code had actually rejected
>> zero timeouts until commit 8e54caf407b98e (this is the commit that
>> introduced the Atmel 3204 workaround) and let default timeout values remain
>> instead (it looks like they were exactly like these in above override at
>> that time).
>>
>> Did Atmel 3204 report wrong but non-zero timeouts?
> 
> Wouldn't it make more sense to fix this by re-adding this fallback?

I think it would be a cleaner fix and also catch other problematic
devices (if there are any) without needing to add individual overrides.

> /Jarkko

Maciej


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
