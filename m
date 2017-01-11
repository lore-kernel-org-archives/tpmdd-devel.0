From: Andreas Fuchs <andreas.fuchs@sit.fraunhofer.de>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 11:03:24 +0100
Message-ID: <0c944a71-863a-c484-7e2d-43095c558f73@sit.fraunhofer.de>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
 <20170109223918.cthvhgx5w2assnry@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170109223918.cthvhgx5w2assnry@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Am 09.01.2017 um 23:39 schrieb Jarkko Sakkinen:
> On Thu, Jan 05, 2017 at 03:52:02PM +0000, Fuchs, Andreas wrote:
>> Great to see this coming along so well. Thanks a lot to Jarkko !
>> I just wanted to point out a few things I deem important at this point:
>>
>> - Number of virtual handles:
>>  From what I see there are currently 14 slots for virtual objects in the RFC (if I'm mistaking, please correct me).
>> I'd advice to ask the TPM2_GetCapabilities(TPM_CAP_TPM_PROPERTIES, TPM_PT_HR_TRANSIENT_MIN or TPM_PT_HR_TRANSIENT_AVAIL)
>> [Note: there is no actual max, i.e. the TPM will allow more transient objects that e.g. 3 if they are small]
>> and provide each TPM space with the same amount as the TPM will tell them is available.
>> If an application needs more objects, I'd see a per-fd mini-RM module inside the TSS-libraries handling that job quite well.
>> Same would apply for Session with TPM_PT_HR_LOADED_MIN and TPM_PT_HR_LOADED_AVAIL.
>> This will reduce the memory consumption inside the kernel and provide userspace with a consistent view on the GetCapabilities vs its actual Allocations.
> I rather have a fixed size object. It keeps the implementation simple
> compact and stupid and that is what we want at this point.
>
> Even if I did what you proposed there would not be 1:1 match with
> GetCapability provided data because we need to virtual handle values.
>
> Leaving the virtualization of message bodies in the user space is a
> design choice from my side. The kernel will provide only basic mechanism
> for implementing easily an RM, not a full fledged implementation.
>
>> - Enumeration of loaded (virtual) handles:
>> The TPM allows an application to get the list of currently loaded handles TPM2_GetCapabilities(TPM_CAP_HANDLES).
>> It would be great to have the RM be as transparent to userspace as possible. The RM spec of TCG therefore says that you need to intercept and override this command (unless it is run in an authentication session where you cannot override it, which is disadviced). It's a design choice, but I'd advice for it after long discussions.
> I don't buy this because it doesn't scale (new commands in the standard,
> vendor specific commands). It's just something that is factors easier
> to do in the user space.
>
> It's not an uncommon design in the Linux kernel to have basic mechanism
> in the kernel and do some of the  heavy lifting in the user space. For example,
> graphics drivers are like that.
>
>> - Session Limits (here it gets ugly):
>> Even thought the TPM supports the same swapping-scheme for sessions as it does for transient objects, it only allows for a limited number of session to be opened (64 in case of PC-Client), called active sessions.
>> This means that a single process can still DoS the TPM if it allocates 64 sessions, or 64 processes can DoS the TPM if they allocate 1 session each.
>> There are two principle solutions:
>> a) Limit the number of active sessions per fd, process, user and hope for the best. Of course this will not really protect you from DoS'ed TPMs.
>> b) Kick out old sessions whenever new sessions are requested and TPM is currently full (the TCG RM spec approach). Of course applications need to handle "randomly vanishing" hmac sessions in this case.
> I'll think about this. The next patch set version will include
> session isolation.
>
>> - Session ungaping (here it gets REALLY ugly):
>> The TPM has some scheme for handling sessions that are swapped (contextSaved) out. In this scheme, it can run into the case where it will deny actions on a session handle with a TPM2_RC_GAP error.
>> This error means that the time between last usage of the oldest session and the current session is too far apart.
>> The reaction needs to be that the RM loads this oldest sesssion (or in my implementation all swaped sessions) into the TPM and contextsave them back right away.
>> This becomes especially ugly, when enabling the ability of userspace to contextsave a session on one fd and contextload this session on another fd (or even from another process).
> This something we are not going to support in the first production
> version. I'm happy review patches that try to do this nicely after
> the first version of the feature has landed. I don't care about this
> feature all that much.

I guess all of the above is more or less debatable.

This point here however is not. It's a necessity, otherwise you
will get weird machines that (seemingly) randomly stop working
after a long time; i.e. months. So nobody will find this in tests
or be able to reproduce.

These are the kind of bugs nobody will ever track down.
So please, do not release session-RM-support without taking
care of ungaping...
This would be highly irresponsible !

Thanks,
Andreas

>
> /Jarkko
