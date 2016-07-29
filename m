From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Regarding recently Added TPM2.0 support to the
 Nuvoton i2c driver
Date: Fri, 29 Jul 2016 12:10:08 +0530
Message-ID: <579AFA48.2040304@linux.vnet.ibm.com>
References: <5797A893.9020205@linux.vnet.ibm.com>
	<20160726201711.GA17742@obsidianresearch.com>
	<5798C571.1000309@linux.vnet.ibm.com>
	<20160727162415.GA18843@obsidianresearch.com>
	<5798EEFB.1000004@linux.vnet.ibm.com>
	<20160727174229.GA28681@obsidianresearch.com>
	<20160727223419.GA6132@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160727223419.GA6132-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
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

Thanks everyone for discussion and clarifying the design points. This 
helps and we can now test by changing our device-tree entries.

Also, we are assuming that just updating .compatible device tree entry 
should do the fix. We don't have to add any additional .data property. 
And driver will match .data value even for nuvoton,npct650 from device 
driver npct601 entry, where .data is explicitly specified.

Thanks & Regards,
    - Nayna

On 07/28/2016 04:04 AM, George Wilson wrote:
> On Wed, Jul 27, 2016 at 11:42:29AM -0600, Jason Gunthorpe wrote:
>>> Should not the device tree tell you what is actually *there* and let the
>>> driver code decide what is compatible?  Rather than the firmware trying to
>>> make a guess as to which Nuvoton device id to try to match in the Nuvoton
>>> driver code?
>>
>> Yes, that is what I suggested:
>>
>>>>>>    compatible = "nuvoton,npct650", "nuvoton,npct601"
>>
>> Today's kernel has no idea what 650 is, but since the DT says it is
>> compatible with the 601 then today's kernel will bind to it. 601 is
>> the kernel documented compatible tag for that specific I2C
>> API.
>
> So in this case, early firmware would simply pass the additional
> compatible string.
>
>> Perhaps we should add 6xx as the generic flavor? I'm not as clear on
>> what DT maintainers think about that, but there is precedent.
>
> We thought about suggesting that too.  However,
> http://elinux.org/Device_Tree_Usage advises:
>
>    Warning: Don't use wildcard compatible values, like
>    "fsl,mpc83xx-uart" or similar. Silicon vendors will invariably
>    make a change that breaks your wildcard assumptions the moment
>    it is too late to change it. Instead, choose a specific silicon
>    implementations and make all subsequent silicon compatible with
>    it.
>
> It looks like the driver's compatible table is on the right track and
> we need to make our platform's device tree conform to its expectations.
>


------------------------------------------------------------------------------
