From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/3] Few st33zp24 fixes
Date: Tue, 29 Mar 2016 19:20:09 +0300
Message-ID: <20160329162009.GA24833@intel.com>
References: <1458719734-13752-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458719734-13752-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 23, 2016 at 08:55:31AM +0100, Christophe Ricard wrote:
> Hi Jarkko,
> 
> After my first tentative and as discussed, please find a dedicated
> st33zp24 serie intends to provide few fixes on acpi probing and code
> style improvement.
> 
> Best Regards
> Christophe
> 
> Christophe Ricard (3):
>   tpm/st33zp24/i2c: Drop two useless checks in ACPI probe path
>   tpm/st33zp24/spi: Drop two useless checks in ACPI probe path
>   tpm/st33zp24: Remove unneeded tpm_reg in get_burstcount

I've applied these patches to my master branch and at some point
merge them to next.

/Jarkko

> 
>  drivers/char/tpm/st33zp24/i2c.c      | 13 +------------
>  drivers/char/tpm/st33zp24/spi.c      | 13 +------------
>  drivers/char/tpm/st33zp24/st33zp24.c | 10 +++++-----
>  3 files changed, 7 insertions(+), 29 deletions(-)
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
