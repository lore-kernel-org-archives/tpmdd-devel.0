From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] remaining tpmdd fixes for Linux 4.5
Date: Thu, 25 Feb 2016 10:30:44 -0700
Message-ID: <20160225173044.gcr2j65ihv6cevzm@cantor.redhat.com>
References: <20160220081705.GA12981@intel.com>
	<alpine.LRH.2.20.1602221255210.4918@namei.org>
	<20160222145023.GA28365@intel.com>
Reply-To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160222145023.GA28365-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Wilck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon Feb 22 16, Jarkko Sakkinen wrote:
>On Mon, Feb 22, 2016 at 12:56:53PM +1100, James Morris wrote:
>> On Sat, 20 Feb 2016, Jarkko Sakkinen wrote:
>>
>> > Hi James,
>> >
>> > I'm sorry for the late pull request for 4.5. The reason for this was
>> > the latency in my previous one. I picked with care the absolutely
>> > critical fixes so that we can make a sound tpmdd release.
>> >
>> > I really hope you can still pick these as one of them is absolutely
>> > critical to get authorization policy sealing API right (kernel keeps
>> > it finger out of user space created objects).
>>
>> Pushed to next for more testing and review.
>>
>> This really is getting too late in the development cycle for so many
>> fixes.  It means the code was not ready to be merged in the first place.
>
>I fully agree what you're saying. I'll learn the lesson here and take
>factors more conservative attitude from now on. No excuses. I'm sorry
>about this.
>
>Partly the reason for recent increase in regressions has been
>increased real-world use of TPM2 and thus issues have started to pop
>up that's a lame excuse anyway.
>

Would it be worthwhile to have a tpm branch that gets pulled by -next
directly so changes will have already been going through the paces in
-next prior to the pull reuqest to James?

snits

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
