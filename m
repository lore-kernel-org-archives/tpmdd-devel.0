From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Introduce flag to
	prevent sysfs entries
Date: Thu, 30 Jun 2016 12:17:02 -0400
Message-ID: <577545FE.5000206@linux.vnet.ibm.com>
References: <1466779015-26965-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160624174803.GA14506@obsidianresearch.com>
	<576D7F34.50201@linux.vnet.ibm.com> <20160627183220.GD7268@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160627183220.GD7268-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 06/27/2016 02:32 PM, Jarkko Sakkinen wrote:
> On Fri, Jun 24, 2016 at 02:43:00PM -0400, Stefan Berger wrote:
>> On 06/24/2016 01:48 PM, Jason Gunthorpe wrote:
>>> On Fri, Jun 24, 2016 at 10:36:55AM -0400, Stefan Berger wrote:
>>>> Introduce TPM_VTPM_PROXY_NO_SYSFS flag that prevents a vtpm_proxy driver
>>>> instance from having the typical sysfs entries that shows the state of the
>>>> TPM. The flag is to be set in the ioctl creating the vtpm_proxy device
>>>> pair and maps on a new chip flags TPM_CHIP_FLAG_NO_SYSFS.
>>> No other subsystem does something so goofy, this really needs to be
>>> part of namespace support for TPM.
>> And I am not sure how to go about this. TPM2 by the way doesn't have such
>> entries, so it's much better from that perspective.
>>
>>> Why can't you just make the sysfs files unreadable in user space?
>> There are actually ways to go about this. Likely bind-mounting over
>> /sys/device/virtual/tpm would be one solution to hide all virtual TPM
>> device. Another is applying an AppArmor policy to the container denying
>> access to tpm directories or entries. SELinux would not be so easy.
>>
>> The flag in this patch seemed like a 'cheap' way to eliminate that problem
>> as well.
> Does it have any other qualities that would make this better than bind
> mounting?

Not sure what to argue with. Maybe setting a bit on an ioctl that needs 
to be executed would be a good argument.

    stefan

>
> /Jarkko
>


------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
