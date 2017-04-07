From: Paul Menzel <pmenzel-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Subject: Re: Regression between Linux 3.16 and 4.8/4.9 on
 Lenovo X60 with coreboot
Date: Fri, 07 Apr 2017 22:58:12 +0200
Message-ID: <cd01f99b4297a5fc8f11e0998ab06d7e@molgen.mpg.de>
References: <c4bfd77e-3fb9-8a9b-28f5-48e6c13beb12@maciej.szmigiero.name>
	<bf4ca184f43cc7b6ee8069b63558087c@molgen.mpg.de>
	<20170406165557.GD7657@obsidianresearch.com>
	<3d62bd7d4addc020c2f8e3c2edf3280e@molgen.mpg.de>
	<20170406191013.GA25011@obsidianresearch.com>
	<20170407201347.2qcyrdzgg2yikoen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170407201347.2qcyrdzgg2yikoen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arthur Heymans <arthur-ohM3iTZxzbjrDilwLfPoKQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, GNUtoo-n+LsquliYkMdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Dear Jarkko,


On 2017-04-07 22:13, Jarkko Sakkinen wrote:
> On Thu, Apr 06, 2017 at 01:10:13PM -0600, Jason Gunthorpe wrote:
>> On Thu, Apr 06, 2017 at 08:26:22PM +0200, Paul Menzel wrote:
>> > >We added direct ACPI binding to the driver in addition to PNP, so if
>> > >you have an ACPI table it goes down that path and does some additional
>> > >validation of what is in the TPM. The BIOS must provide a
>> > >acpi_dev_resource_memory and a ACPI_SIG_TPM2 for the ACPI entry at a
>> > >minimum.
>> >
>> > Is it correct, that this is added in/for 4.11, so just recently? Testing
>> > with Linux 4.10.8, everything is detected just fine.
>> 
>> No, it is quite a bit older.. And it should only go for TPM2, which I
>> don't think you have??
>> 
>> Maybe Jarkko has a guess, but sure sounds like something is recently
>> broken in 4.11
>> 
>> Jason
> 
> I'll come back to this. I have to re-read the whole mail thread to
> get back into the context. Lots of multitasking because of release
> and so forth. Sorry for the latency!

I started bisecting this issue. This is the current state.

```
# git bisect log
# bad: [7a771ceac771d009f7203c40b256b0608d7ea2f8] Merge tag 
'dm-4.11-changes' of 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
# good: [c470abd4fde40ea6a0846a2beab642a578c0b8cd] Linux 4.10
git bisect start 'HEAD' 'v4.10'
# good: [b3de5ad688f0f52457e73767f95a640ab4158d0d] Merge tag 
'regmap-v4.11' of 
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect good b3de5ad688f0f52457e73767f95a640ab4158d0d
```


Kind regards,

Paul

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
