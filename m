From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm: add session handles to the save and
 restore of the tpm2 space manager
Date: Tue, 17 Jan 2017 09:01:59 -0500
Message-ID: <o5l849$el9$1@blaine.gmane.org>
References: <1484335453.2527.31.camel@linux.vnet.ibm.com>
	<20170116100415.ieyweqjjcg5d3zzd@intel.com>
	<1484608725.2540.88.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484608725.2540.88.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/16/2017 6:18 PM, James Bottomley wrote:
>
> Basically this means that the advice to virtualize session handles
> in the TCG RM document is wrong and we have to use physical handles.
> I'll redo the implementation for this ... and now, since we'll have
> nothing to use as an index, it probably does make sense to have
> sessions in a separate array.  I can also separate isolation from
> context switching ... although I really think this is less optimal:
> my TPM only allows three active context handles, so if we don't
> context switch them identically to transient object (which it also
> only allows three of) I'm going to run out.  I actually redid my
> openssl_tpm_engine patches so they use session handles for parameter
> encryption and HMAC based authority, so this may end up biting me
> soon ...

I think you have to context save sessions, just as you do with transient 
objects.  Otherwise, only one process at a time can connect.

FWIW:

The TPM specs use the following jargon:

Loaded sessions:  The ~3 sessions that can be resident on the TPM.

Saved sessions:  Sessions that have been context saved off the TPM. 
These have a small bit of state on the TPM to prevent replays.

Active sessions:  The sum of loaded and saved, typically ~64.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
