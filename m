From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH -next] tpm_tis: fix the error handling of
	init_tis()
Date: Wed, 8 Feb 2017 13:38:58 +0200
Message-ID: <20170208113858.nlevaexee73xvkuy@intel.com>
References: <20170207155147.2581-1-weiyj.lk@gmail.com>
	<20170208113637.4tqtlumwqew3cyuz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208113637.4tqtlumwqew3cyuz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 08, 2017 at 01:36:37PM +0200, Jarkko Sakkinen wrote:
> On Tue, Feb 07, 2017 at 03:51:47PM +0000, Wei Yongjun wrote:
> > From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Add the missing platform_driver_unregister() and remove the duplicate
> > platform_device_unregister(force_pdev) in the error handling case.
> > 
> > Fixes: 00194826e6be ("tpm_tis: Clean up the force=1 module parameter")
> > Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I applied this and added cc to stable.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
