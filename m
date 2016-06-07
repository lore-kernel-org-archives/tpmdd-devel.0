From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] tpm_tis: Increase ST19NP18 TPM command
 timeout to avoid chip lockup
Date: Tue, 7 Jun 2016 16:49:56 +0300
Message-ID: <20160607134956.GC3855@intel.com>
References: <1465252079-126836-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465252079-126836-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 06, 2016 at 03:27:59PM -0700, Ed Swierk wrote:
> The STMicro ST19NP18-TPM sometimes takes much longer to execute
> commands than it reports in its capabilities. For example, command 186
> (TPM_FlushSpecific) has been observed to take 14560 msec to complete,
> far longer than the 750 msec limit for "short" commands reported by
> the chip. The behavior has also been seen with command 101
> (TPM_GetCapability).
> 
> Worse, when the tpm_tis driver attempts to cancel the current command
> (by writing commandReady = 1 to TPM_STS_x), the chip locks up
> completely, returning all-1s from all memory-mapped register
> reads. The lockup can be cleared only by resetting the system.

Does this also happen when command doesn't take enormously long? I'm
just trying to understand does this contain one or two issues. I don't
know how hard this would be to test in practice with commands that last
750 ms (maybe with a quirk to kernel code).

> The occurrence of this excessive command duration depends on the
> sequence of commands preceding it. One sequence is creating at least 2
> new keys via TPM_CreateWrapKey, then letting the TPM idle for at least
> 30 seconds, then loading a key via TPM_LoadKey2. The next
> TPM_FlushSpecific occasionally takes tens of seconds to
> complete. Another sequence is creating many keys in a row without
> pause. The TPM_CreateWrapKey operation gets much slower after the
> first few iterations, as one would expect when the pool of precomputed
> keys is exhausted. Then after a 35-second pause, the same TPM_LoadKey2
> followed by TPM_FlushSpecific sequence triggers the behavior.
> 
> Our working theory is that this older TPM sometimes pauses to perform
> internal garbage collection, which modern chips implement as a
> background process. Without access to the chip's implementation
> details it's impossible to know whether any commands are immune to
> this behavior.  So it seems safest to ignore the chip's reported
> command durations, and use a value much higher than any observed
> duration, like 2 minutes (which happens to be the value used for
> TPM_UNDEFINED commands in tpm_calc_ordinal_duration()).
> 
> v2: Minor correction of patch description.
> 
> Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>

Acked-by: Jarkko Sakkinne <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
