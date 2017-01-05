From: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 5 Jan 2017 15:52:02 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102132213.22880-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Great to see this coming along so well. Thanks a lot to Jarkko !
I just wanted to point out a few things I deem important at this point:

- Number of virtual handles:
>From what I see there are currently 14 slots for virtual objects in the RFC (if I'm mistaking, please correct me).
I'd advice to ask the TPM2_GetCapabilities(TPM_CAP_TPM_PROPERTIES, TPM_PT_HR_TRANSIENT_MIN or TPM_PT_HR_TRANSIENT_AVAIL)
[Note: there is no actual max, i.e. the TPM will allow more transient objects that e.g. 3 if they are small] 
and provide each TPM space with the same amount as the TPM will tell them is available.
If an application needs more objects, I'd see a per-fd mini-RM module inside the TSS-libraries handling that job quite well.
Same would apply for Session with TPM_PT_HR_LOADED_MIN and TPM_PT_HR_LOADED_AVAIL.
This will reduce the memory consumption inside the kernel and provide userspace with a consistent view on the GetCapabilities vs its actual Allocations.

- Enumeration of loaded (virtual) handles:
The TPM allows an application to get the list of currently loaded handles TPM2_GetCapabilities(TPM_CAP_HANDLES).
It would be great to have the RM be as transparent to userspace as possible. The RM spec of TCG therefore says that you need to intercept and override this command (unless it is run in an authentication session where you cannot override it, which is disadviced). It's a design choice, but I'd advice for it after long discussions.

- Constant session handles (hurray):
Sessions do not change their handles on contextsave/contextload, so you do not need to virtualize session handles.
In fact you must not do so, because cpHash-calculation needs to know the TPM's handle number for sessions on at least 1 command.
So this simplifies session handling inside the kernel since you do not need to alter the handle area for session handles.

- Session Limits (here it gets ugly):
Even thought the TPM supports the same swapping-scheme for sessions as it does for transient objects, it only allows for a limited number of session to be opened (64 in case of PC-Client), called active sessions.
This means that a single process can still DoS the TPM if it allocates 64 sessions, or 64 processes can DoS the TPM if they allocate 1 session each.
There are two principle solutions:
a) Limit the number of active sessions per fd, process, user and hope for the best. Of course this will not really protect you from DoS'ed TPMs.
b) Kick out old sessions whenever new sessions are requested and TPM is currently full (the TCG RM spec approach). Of course applications need to handle "randomly vanishing" hmac sessions in this case.

- Session ungaping (here it gets REALLY ugly):
The TPM has some scheme for handling sessions that are swapped (contextSaved) out. In this scheme, it can run into the case where it will deny actions on a session handle with a TPM2_RC_GAP error.
This error means that the time between last usage of the oldest session and the current session is too far apart.
The reaction needs to be that the RM loads this oldest sesssion (or in my implementation all swaped sessions) into the TPM and contextsave them back right away.
This becomes especially ugly, when enabling the ability of userspace to contextsave a session on one fd and contextload this session on another fd (or even from another process).


I hope your can parse what I wrote, feel free to ask for more details on any point.
I'll be more than happy to help concepting around these problems but atm unfortunately I'm unable to help with actual code ... for reasons...

Best regards,
Andreas





________________________________________
From: Jarkko Sakkinen [jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
Sent: Monday, January 02, 2017 14:22
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; open list
Subject: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager

This patch set adds support for TPM spaces that provide a context
for isolating and swapping transient objects. This patch set does
not yet include support for isolating policy and HMAC sessions but
it is trivial to add once the basic approach is settled (and that's
why I created an RFC patch set).

There's a test script for trying out TPM spaces in

  git://git.infradead.org/users/jjs/tpm2-scripts.git

A simple smoke test can be run by

  sudo python -m unittest -v tpm2_smoke.SpaceTest

Jarkko Sakkinen (4):
  tpm: migrate struct tpm_buf to struct tpm_chip
  tpm: validate TPM 2.0 commands
  tpm: export tpm2_flush_context_cmd
  tpm: add the infrastructure for TPM space for TPM 2.0

 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      |  15 ++
 drivers/char/tpm/tpm-dev.c       |  80 ++++++++++-
 drivers/char/tpm/tpm-interface.c |  93 +++++++++----
 drivers/char/tpm/tpm-sysfs.c     |   2 +-
 drivers/char/tpm/tpm.h           | 106 ++++++++------
 drivers/char/tpm/tpm2-cmd.c      | 232 ++++++++++++++++---------------
 drivers/char/tpm/tpm2-space.c    | 288 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tpm.h         |  23 ++++
 9 files changed, 662 insertions(+), 179 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 include/uapi/linux/tpm.h

--
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
