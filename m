From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Is vTPM the right name for the new functionality?
Date: Fri, 11 Mar 2016 19:06:17 +0200
Message-ID: <20160311170617.GA18840@intel.com>
References: <20160311104304.GA14787@intel.com>
	<201603111526.u2BFQd1g012339@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603111526.u2BFQd1g012339-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Fri, Mar 11, 2016 at 10:26:26AM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/11/2016
>    05:43:04 AM:
> 
>    >
>    > Hi Stefan,
>    >
>    > This is something I would like discuss and get other points of views.
>    >
>    > The thing that I would like to rise is the name of this new subsystem.
>    > The keyword 'vTPM' is already heavily referenced in contexts for more
>    > "full stack" solution of virtualization [1].
>    >
>    > If I look at this new functionality it is essentially a proxy and not
>    > much else, isn't it? You can apply for Linux containers but alone it is
>    > proxy tool. With the current name it is too easy to confuse it with
>    > existing solutions.
> 
>    Fine by me. I can rename it to tpm_proxy.c and reference to it as the
>    virtual TPM proxy driver or TPM emulator proxy driver, which I think
>    describes it well. It's not a 'Proxy TPM'.
>    The title of the cover letter for the patches would then be
> 
>    Multi-instance vTPM proxy driver

Sounds fair. And I enjoyed reading that research paper :)

>      Stefan

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
