From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: TPM 2.0 RM flushcontext returning bad address
Date: Sat, 14 Jan 2017 10:32:30 -0800
Message-ID: <1484418750.2424.13.camel@linux.vnet.ibm.com>
References: <o53ei5$sc5$1@blaine.gmane.org>
	<20170110200803.GB5102@obsidianresearch.com>
	<o53ncb$e8q$1@blaine.gmane.org>
	<20170110224225.GA5451@obsidianresearch.com>
	<o561te$39p$1@blaine.gmane.org>
	<1484164614.2509.31.camel@HansenPartnership.com>
	<1484412351.2424.7.camel@HansenPartnership.com>
	<o5dq32$b3s$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o5dq32$b3s$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, 2017-01-14 at 13:19 -0500, Ken Goldman wrote:
> On 1/14/2017 11:45 AM, James Bottomley wrote:
> > 
> > Should fix all of this.  The code has to partially emulate
> > TPM2_FlushContext.  The emulation is
> > 
> >    1. If the handle type is not one we manage (transient, hmac or
> > policy)
> >       send the command on to the TPM
> >    2. next, if the handle isn't currently in the RM table,
> > manufacture a
> >       TPM_RC_HANDLE error and return it
> >    3. remove the handle from the RM table
> >    4. if the handle is transient, manufacture TPM_RC_SUCCESS and
> > return it
> >    5. otherwise it's a session handle: flush it and return success.
> 
> This sounds right, assuming:
> 
> 1 - The RM immediately context saves and then flushes any transient 
> object that's created or loaded onto the TPM.

Yes, that's how the space code operates.  It saves every handle (well,
every policy, hmac or transient handle) after a command completes and
reloads them all before the next one.

> If you want a list of commands that load transient objects, let me
> know.

I think for simplicity, unless there's a severe performance impact, we
should stick with loading and saving everything for every command
rather than trying to be selective about  whether the command might
actually use any saved contexts.

> 2 - Step 3 also implies deleting the saved context.

Yes, that's what I meant by "remove" the function in the patch is tpm2
-space.c:tpm2_forget_session() It removes both the handle and the saved
context information for the now flushed session.

James


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
