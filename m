From: Andreas Fuchs <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Fri, 6 Jan 2017 09:59:57 +0100
Message-ID: <f5c8f4a2-d4ad-a2a0-9443-26589c58f9a7@sit.fraunhofer.de>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483641223.2515.62.camel@linux.vnet.ibm.com>
	<20170105192025.GB12587@obsidianresearch.com>
	<1483646149.2515.83.camel@linux.vnet.ibm.com>
	<20170105222118.GC31047@obsidianresearch.com>
	<1483657126.2515.107.camel@linux.vnet.ibm.com>
	<20170105235046.GA4670@obsidianresearch.com>
	<1483663002.2515.134.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483663002.2515.134.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Am 06.01.2017 um 01:36 schrieb James Bottomley:
> On Thu, 2017-01-05 at 16:50 -0700, Jason Gunthorpe wrote:
>> On Thu, Jan 05, 2017 at 02:58:46PM -0800, James Bottomley wrote:
>>> On Thu, 2017-01-05 at 15:21 -0700, Jason Gunthorpe wrote:
>>>> On Thu, Jan 05, 2017 at 11:55:49AM -0800, James Bottomley wrote:
>>>>
>>>>> We don't really have that choice: Keys require authorization,
>>>>> so you have to have an auth session.
>>>> I know, this is why I suggested a combo op (kernel level
>>>> atomicity is clearly DOS safe)..
>>> Transactions are a hard thing to guarantee to be DoS safe and the
>>> more complex they get, the more difficult they are to police within
>>> the kernel.  Plus we have to keep the R/W interface for backwards
>>> compatibility now that we have it and I just don't see how we could
>>> layer transactions into it without having some sort of in-kernel
>>> emulator.
>> Again, this was only to make the unpriv FD usable and safe against
>> session DOS and that FD wouldn't use the legacy r/w interface. I
>> don't care if root can DOS the TPM via /dev/tpm0. combo ops would
>> need to be simple enough to reason about. (in my TPM libaries API
>> calls are combo'd with session anyhow, and that works quite well for
>> my use models)
> In Ken's TSS2 they are for simple authorisation.  However, policy auth
> is where it gets tricky and right at the moment I believe I need policy
> based authorisation for keys.

I don't think this is TSS-specific. It also holds true for the TCG-TSS.

The thing is that you will need both, HMAC and Policy Sessions in
standard userspace applications (not only the exotic ones)...
... and they must not be time-based leases, because other IO or
user-UI might happen.

Reasons:
1. PolicyPCR is an essential feature of TPM used all over the place,
so we need support for policy sessions.
2. PolicySigned allows authentication of the user via SmartCard.
So the application will have to challenge back using the challenge
from the TPM. So no timeouts please.
3. HMAC-sessions could also be handled via authentication tokens
that take the cpHash and session as challenge and provide an
HMAC. Again we'd have IO and user interaction.

In summary, in TCG we came to the conclusion that kicking out
sessions is the best approach. IMHO session quotas per process,
user, cgroup is even better, but was not possible in the TCG spec
for a user-space cross-OS RM (no notion of such capabilities).

We spent several f2f-meetings, confcalls and emails on this topic
inside the TCG. I'd advice everyone to look into the RM-spec and
coming updates, and especially TCG members to look into potential
unrelease documents on these issues. Feel free to contact me as
well for any TCG-insights.

>>>> Lets stick with the user space broker process and just introduce
>>>> enough kernel RM to enable co-existance with kernel users and
>>>> clean -up on crash. This should be enough to make a user space
>>>> broker much simpler.
>>> I wouldn't go that far.  I'm still planning a userspace tss2
>>> without any access broker daemon, but let's see how far I get on
>>> top of the RM.  I think building in stages is a good way to get
>>> actual use experience to guide the next stage.
>> I'm sure you can implement what you are doing on top of the RM -
>> that isn't a question in my mind.
>>
>> My question has always been how does your plugin deliver messages to
>> the kernel RM in a way that does not compromise the security of the
>> TPM system.
> So currently, it doesn't: I have to either run as root or run a udev
> script to give me access to the device, neither of which will work out
> of the box for distributions because of the security risks you
> identified.  I think this is OK for now because the security issue only
> has to be sorted out before we make this ready for general release
> (i.e. advise the distros how to expose the TPM) and we need to gather
> use case data before we do that.

The all-defeating reason for having in-kernel-RM is trusted keyrings
or IMA/EVM appraise/protect or similar. They will want to use sealing
to PCRs which in turn requires policy sessions from inside the kernel
and thus RM inside the kernel to play nicely with the TSS. TCG's TSS
had to add an ugly quirk into its spec in order to work with current
trusted keyrings uapi that I really want to deprecate.
And IMHO nobody wants the kernel security modules to call back
to a userspace RM-daemon.

If everyone agrees with this presumption the only question becomes
how to do this, such that we don't need a second RM in userspace
for the 99% of use cases.

P.S. This fact should also be given some thought when discussing the
priviledged 0600 node, i.e. /dev/tpm0 without the s in the middle.

Cheers,
Andreas




------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
