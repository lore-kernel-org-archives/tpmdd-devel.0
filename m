From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: crb state transition question
Date: Sat, 25 Mar 2017 21:30:09 +0200
Message-ID: <20170325193009.ewd2ta2u2q2mwmtk@intel.com>
References: <87inmy6zm3.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87inmy6zm3.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 24, 2017 at 04:09:40PM -0700, Jerry Snitselaar wrote:
> 
> How closely should the driver adhere to the state transitions documented
> in the ptp spec? I think in an earlier patch Tomas mentioned that PTT
> (at least some versions) was handling idle state management itself. With
> something other than PTT coming along to use crb, I'm wondering if we
> should be doing something like crb_cmd_ready at the beginning of
> crb_send, and crb_go_idle at the end of crb_recv.

There are pm_runtime calls in tpm_transmit and callbacks to tpm_crb. The
transition to powered state and back happens once per trasmission. This
works for all Intel platforms. I would consider fixing it if there was
a regression related to power gating in ARM64 for example.

Can't really even recall what was exactly said in the specification
about this. I took the timeouts from the spec basically (the power
gating patch was originally done by me and further refined by Tomas).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
