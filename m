From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM 2.0 RM flushcontext returning bad address
Date: Wed, 11 Jan 2017 15:29:06 -0500
Message-ID: <o564ig$9iv$1@blaine.gmane.org>
References: <o53ei5$sc5$1@blaine.gmane.org>
	<20170110200803.GB5102@obsidianresearch.com>
	<o53ncb$e8q$1@blaine.gmane.org>
	<20170110224225.GA5451@obsidianresearch.com>
	<o561te$39p$1@blaine.gmane.org>
	<1484164614.2509.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484164614.2509.31.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

On 1/11/2017 2:56 PM, James Bottomley wrote:

> I'm playing with adding session based handles to the RM now.  What I
> find is that there's no escape from interpreting TPM2_FlushContext
> because we need to know if we can release a session resource and we
> can't rely on the continuation parameter alone.  Given this problem, it
> looks like we have no choice but to intercept TPM2_FlushContext and
> emulate its execution, so we're going to have to manufacture at least
> some TPM return codes within the kernel.  Once we start down this path,
> it's probably fairly easy to add for the other RM returns.

If this helps:

FlushContext can have any handle (except permanent handles)

In addition:

Session - continue attribute false
Sequence - SequenceComplete, EventSequenceComplete

Manufacturing error codes in the kernel is one possibility. Another is 
to just map the unknown handle to TPM_RH_NULL and let the TPM do the rest.




------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
