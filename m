From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM 2.0 RM flushcontext returning bad address
Date: Sat, 14 Jan 2017 13:19:25 -0500
Message-ID: <o5dq32$b3s$1@blaine.gmane.org>
References: <o53ei5$sc5$1@blaine.gmane.org>
	<20170110200803.GB5102@obsidianresearch.com>
	<o53ncb$e8q$1@blaine.gmane.org>
	<20170110224225.GA5451@obsidianresearch.com>
	<o561te$39p$1@blaine.gmane.org>
	<1484164614.2509.31.camel@HansenPartnership.com>
	<1484412351.2424.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484412351.2424.7.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/14/2017 11:45 AM, James Bottomley wrote:
>
> Should fix all of this.  The code has to partially emulate
> TPM2_FlushContext.  The emulation is
>
>    1. If the handle type is not one we manage (transient, hmac or policy)
>       send the command on to the TPM
>    2. next, if the handle isn't currently in the RM table, manufacture a
>       TPM_RC_HANDLE error and return it
>    3. remove the handle from the RM table
>    4. if the handle is transient, manufacture TPM_RC_SUCCESS and return it
>    5. otherwise it's a session handle: flush it and return success.

This sounds right, assuming:

1 - The RM immediately context saves and then flushes any transient 
object that's created or loaded onto the TPM.

If you want a list of commands that load transient objects, let me know.

2 - Step 3 also implies deleting the saved context.



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
