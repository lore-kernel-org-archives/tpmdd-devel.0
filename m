From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Thu, 25 Feb 2016 13:31:17 -0700
Message-ID: <20160225203117.GA22984@obsidianresearch.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
	<201602230142.u1N1gSuF029481@d01av05.pok.ibm.com>
	<20160223021730.GD26177@obsidianresearch.com>
	<201602242306.u1ON6qGP030251@d01av05.pok.ibm.com>
	<20160225131732.GA20860@intel.com>
	<201602251409.u1PE98LH012367@d01av05.pok.ibm.com>
	<20160225173956.GA1407@obsidianresearch.com>
	<201602251842.u1PIgEuL014249@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602251842.u1PIgEuL014249-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 25, 2016 at 01:42:10PM -0500, Stefan Berger wrote:

>    It looks like they some are being used on the kobject level.

Yes, struct devices are kobjects.

>    > Once you figure out how to define what TPMs are in a namespace it
>    > should be doable to use the syfs_ns APIs to have sysfs follow that
>    > restriction just like net does.

>    Networking has its own namespace and it looks like all devices get
>    created while in that namespace.

No, it is like tpm, a cannonical example is something like:

 ip netns add blue
 ip link add veth0 type veth peer name veth1
 ip link set veth1 netns blue

To move an interface, which presumably moves the sysfs stuff as
well. Seems exactly like a mode that could work for TPM.

>    clone(), a long time after current registration with sysfs. Another
>    difference is that we don't have a device namespace, so all our device
>    names and major / minor numbers need to be unique and that's also
>    reflected in sysfs.

major/minor numbers do not need to be unique, the mapping of TPM ID to
physical TPM is something a namespace should control, eg TPM ID 0 is
always major/minor 10:224, and can be routed to which ever tpm is
correct for the namespace of the accessing process.

Same for sysfs, within the namespace the vtpm should appear as tpm0.

>    I have been experimenting with an ioctl that passes along a file
>    descriptor to a user namespace (/proc/pid/ns/user) for the purpose of
>    associating the vtpm with that user namespace.

I would have thought you'd use the IMA namespace for this, seems more
natural?

Functionally it doesn't matter, which ever name space is used, migrate
the sysfs stuff similar to net and virtualize all the ID.

>    time option). Here we need to ensure that the child gets the chip
>    hooked to the IMA namespace before the execve() triggers measurements
>    by IMA. Here I pass the process Id of that child to then determine IMA
>    namespace to hook the chip to and user namespace for vTPM sysfs
>    association. I prefer the child's process id over passing two file
>    descriptors in this case...

I'm sure people familiar with namespaces/etc will have suggestions on
how to build the uapi side.

I still intensely dislike the use of an ioctl on vtpm because
namespaces will have to be a core tpm feature, an ioctl on the
/dev/tpmX fd would be more approriate.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
