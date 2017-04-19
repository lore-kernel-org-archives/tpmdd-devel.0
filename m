From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [backport v4.9] tpm_tis: use default timeout
 value if chip reports it as zero
Date: Wed, 19 Apr 2017 18:29:08 +0300
Message-ID: <20170419152908.vq55so4mtqyp6sc7@intel.com>
References: <20170415152622.14451-1-user@jsakkine-mobl1>
	<20170415205032.GA17774@kroah.com>
	<79399e000218504619c21ce6729c8334@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <79399e000218504619c21ce6729c8334-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Paul Menzel <pmenzel-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Cc: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Apr 16, 2017 at 09:14:29PM +0200, Paul Menzel wrote:
> Dear Greg,
> 
> 
> On 2017-04-15 22:50, Greg KH wrote:
> > On Sat, Apr 15, 2017 at 06:26:22PM +0300, Jarkko Sakkinen wrote:
> > > From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
> > > 
> > > Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for
> > > TPM access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version
> > > 13.9)
> > > no longer works.  The initialization proceeds fine until we get and
> > > start using chip-reported timeouts - and the chip reports C and D
> > > timeouts of zero.
> > > 
> > > It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
> > > means to override the chip returned timeouts") we had actually let
> > > default timeout values remain in this case, so let's bring back this
> > > behavior to make chips like Atmel 3203 work again.
> > > 
> > > Use a common code that was introduced by that commit so a warning is
> > > printed in this case and /sys/class/tpm/tpm*/timeouts correctly says
> > > the
> > > timeouts aren't chip-original.
> > > 
> > > Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM
> > > access")
> > > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > What is the git commit id for this patch in Linus's tree?
> 
> The git commit hash is 1d70fe9d9c3a4c627f9757cbba5d628687b121c1.
> 
> 
> Kind regards,
> 
> Paul

Do you want me to revise the backport? Thanks.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
