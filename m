From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] tpm_tis: Increase ST19NP18 TPM command
 timeout to avoid chip lockup
Date: Mon, 6 Jun 2016 18:48:10 -0700
Message-ID: <CAO_EM_=ZgHV+3YRAuwiSUsqDOtreRhgEON_kPyJxb=1vQfm0eg@mail.gmail.com>
References: <1465252079-126836-1-git-send-email-eswierk@skyportsystems.com>
	<OFFA057E80.C169C00E-ON00257FCB.000588B0-85257FCB.0006225D@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <OFFA057E80.C169C00E-ON00257FCB.000588B0-85257FCB.0006225D-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
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

On Mon, Jun 6, 2016 at 6:07 PM, Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:
> Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org> wrote on 06/06/2016 06:27:59 PM:
> > The occurrence of this excessive command duration depends on the
> > sequence of commands preceding it. One sequence is creating at least 2
> > new keys via TPM_CreateWrapKey, then letting the TPM idle for at least
>
> How long does it take to create those keys? Maybe it will create new keys in the 'background' after that.

The first few TPM_CreateWrapKey commands take roughly 300 msec. I've
seen it go as high as 80 seconds after several of those in a row.

It makes sense that a key generation process starts up after the chip
thinks it's idle. Slowing down unrelated operations stretches the
meaning of "background", of course. And locking up the chip is
downright impolite.

> > 30 seconds, then loading a key via TPM_LoadKey2. The next
> > TPM_FlushSpecific occasionally takes tens of seconds to
> > complete. Another sequence is creating many keys in a row without
> > pause. The TPM_CreateWrapKey operation gets much slower after the
> > first few iterations, as one would expect when the pool of precomputed
> > keys is exhausted. Then after a 35-second pause, the same TPM_LoadKey2
> > followed by TPM_FlushSpecific sequence triggers the behavior.
> >
> > Our working theory is that this older TPM sometimes pauses to perform
> > internal garbage collection, which modern chips implement as a
> > background process. Without access to the chip's implementation
> > details it's impossible to know whether any commands are immune to
> > this behavior.  So it seems safest to ignore the chip's reported
> > command durations, and use a value much higher than any observed
> > duration, like 2 minutes (which happens to be the value used for
> > TPM_UNDEFINED commands in tpm_calc_ordinal_duration()).

On further testing of my patch, I realize that I have totally confused
timeouts and durations. I need to override the command durations
(short, medium, long) reported by the chip. The reported protocol
timeouts (a, b, c, d) are fine.

Please consider this patch withdrawn. I'll send an updated patch shortly.

--Ed

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
