From: Dave Heller <hellerda-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Regarding recently Added TPM2.0 support to the
 Nuvoton i2c driver
Date: Wed, 27 Jul 2016 13:27:23 -0400
Message-ID: <5798EEFB.1000004@linux.vnet.ibm.com>
References: <5797A893.9020205@linux.vnet.ibm.com>
	<20160726201711.GA17742@obsidianresearch.com>
	<5798C571.1000309@linux.vnet.ibm.com>
	<20160727162415.GA18843@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160727162415.GA18843-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


On 07/27/2016 12:24 PM, Jason Gunthorpe wrote:
> On Wed, Jul 27, 2016 at 10:30:09AM -0400, Dave Heller wrote:
>>> So you might do
>>>
>>>    compatible = "nuvoton,npct650", "nuvoton,npct601"
>>>
>>> Andrew, is 601 even the right name?
>>
>> Hi Jason, I'm not sure I'm understanding your answer here.  Looks like
>> we will have to add a couple of lines to specifically list the npct650,
>> why not just using the existing syntax, one device id per line?  Or you
>> are saying, since the npct601 and npct650 are similar models, it's
>> better to list them on the same line?
>
> The above example would go in your device tree, are you using device tree?
>
> Jason

Thanks, I get in now: you are saying we should add that to our device 
tree and leave the driver code alone.

Here is were my understanding of the device tree entry is a bit lacking" 
maybe this is the convention that is normally followed.  And yes, the 
device tree property is named "compatible".  But this seems intuitively 
backward to me:

Should not the device tree tell you what is actually *there* and let the 
driver code decide what is compatible?  Rather than the firmware trying 
to make a guess as to which Nuvoton device id to try to match in the 
Nuvoton driver code?

Put another way, should the "smarts" as to which Nuvoton part numbers 
are considered compatible to the driver, be done by FW?  Or left to the 
driver?


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
