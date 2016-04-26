From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v11 0/4] Multi-instance vTPM proxy driver
Date: Tue, 26 Apr 2016 07:30:26 -0400
Message-ID: <571F5152.7000901@linux.vnet.ibm.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160422165427.GA24090@intel.com> <20160426092807.GA32066@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160426092807.GA32066-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 04/26/2016 05:28 AM, Jarkko Sakkinen wrote:
> On Fri, Apr 22, 2016 at 07:54:27PM +0300, Jarkko Sakkinen wrote:
>> On Mon, Apr 18, 2016 at 01:26:12PM -0400, Stefan Berger wrote:
>>> The following series of patches implements a multi-instance vTPM
>>> proxy driver that can dynamically create TPM 'server' and client device
>>> pairs.
>>>
>>> Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
>>> and a server side file descriptor is created. The file descriptor must
>>> be passed to a TPM emulator. The device driver will initialize the
>>> emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
>>> the command durations from the device in case of a TPM 1.2. The choice
>>> of emulated TPM device (1.2 or 2) must be provided with a flag in
>>> the ioctl.
>>>
>>> The patches are based on the tip of a recent checkout of Jarkko's tree
>>> (master branch).
>> I've applied this series to my master branch. These patches have been
>> baking long enough in my opinion that they could be merged to next and
>> therefore find their way into Linux 4.7
>>
>> Stefan, I would still require your Tested-by for the first patch before
>> merging because it is not as mature as other patches are.
> Now I have augmented Tested-by's to relevant patches and added my
> Signed-off-by's. I plan to merge this to the next branch tomorrow.

Please don't forget Jason's patch for tpm_tis.c that fixes the device 
used in the devm_request_irq/devm_free_irq calls. The rmmod of tpm_tis 
only work correctly in interrupt mode when that patch is applied.

    Stefan


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
