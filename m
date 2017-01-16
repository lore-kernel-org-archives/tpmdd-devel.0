From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: use default timeout value if
 chip reports it as zero
Date: Mon, 16 Jan 2017 15:55:39 +0200
Message-ID: <20170116135539.4qtrylwt3m2yfapx@intel.com>
References: <d5469294-34e6-2e5e-43e8-9ff82579fc2a@maciej.szmigiero.name>
	<20170116094202.bng7zfznepw7s5la@intel.com>
	<20170116134612.uuzbb6xi7pw7czyo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170116134612.uuzbb6xi7pw7czyo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 16, 2017 at 03:46:12PM +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 16, 2017 at 11:42:02AM +0200, Jarkko Sakkinen wrote:
> > On Fri, Jan 13, 2017 at 10:37:00PM +0100, Maciej S. Szmigiero wrote:
> > > Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM
> > > access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version 13.9) no
> > > longer works.
> > > The initialization proceeds fine until we get and start using chip-reported
> > > timeouts - and the chip reports C and D timeouts of zero.
> > > 
> > > It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
> > > means to override the chip returned timeouts") we had actually let default
> > > timeout values remain in this case, so let's bring back this behavior to
> > > make chips like Atmel 3203 work again.
> > > 
> > > Use a common code that was introduced by that commit so a warning is
> > > printed in this case and /sys/class/tpm/tpm*/timeouts correctly says the
> > > timeouts aren't chip-original.
> > > 
> > > Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
> > > 
> > > Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM access")
> > > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> It's now applied to my master branch so if someone wants to
> test it, it should be fairly easy.
> 
> /Jarkko

And I decided to squash the rename commit to it.

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
