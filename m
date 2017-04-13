From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: RE: [Regression Linux 4.11] TPM module not loaded anymore
Date: Thu, 13 Apr 2017 09:19:28 +0200
Message-ID: <f8d59c32452604d642146bbeb20cb5b2@molgen.mpg.de>
References: <c4bfd77e-3fb9-8a9b-28f5-48e6c13beb12@maciej.szmigiero.name>
 <bf4ca184f43cc7b6ee8069b63558087c@molgen.mpg.de>
 <20170406165557.GD7657@obsidianresearch.com>
 <3d62bd7d4addc020c2f8e3c2edf3280e@molgen.mpg.de>
 <20170406191013.GA25011@obsidianresearch.com>
 <20170407201347.2qcyrdzgg2yikoen@intel.com>
 <cd01f99b4297a5fc8f11e0998ab06d7e@molgen.mpg.de>
 <1491759283.1152.12.camel@molgen.mpg.de>
 <20170411225757.yoi2puygipigucjh@intel.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E59259A@ORSMSX110.amr.corp.intel.com>
 <e6c10b975e6be81e259357fe220cc26e@molgen.mpg.de>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E592804@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37E592804@ORSMSX110.amr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Robert Moore <robert.moore@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, linux-kernel@vger.kernel.org, Arthur Heymans <arthur@aheymans.xyz>, tpmdd-devel@lists.sourceforge.net, GNUtoo@no-log.org, "Zheng, Lv" <lv.zheng@intel.com>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Dear Robert,


Thank you for your reply.


On 2017-04-12 23:49, Moore, Robert wrote:

>> On 2017-04-12 17:54, Moore, Robert wrote:
>> > And probably the dmesg if error messages appear in there.
>> 
>> Linux doesn’t log any messages, as the `tpm` module doesn’t load. 
>> Please
>> find the output of `sudo acpidump` attached.
>> 
>> […]
> 
> Do you have any idea what control method(s) are executing? The DSDT
> and SSDT in the acpidump load fine here, and all predefined control
> methods in these tables execute OK.

Sorry, I don’t know what’s done.

> We need to root-cause this problem, as a simple revert will break the
> customers that the fix was intended for in the first place.

I know, but I have no idea how to root-cause this. If nothing can be 
found, a revert is required by Linux’ no-regression-policy.


Kind regards,

Paul
