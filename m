From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: drop int_queue from
 tpm_vendor_specific
Date: Thu, 24 Mar 2016 15:25:32 +0200
Message-ID: <20160324132532.GE8452@intel.com>
References: <1458719734-13752-1-git-send-email-christophe-h.ricard@st.com>
	<20160323081755.GA6434@intel.com> <56F251F2.6050709@gmail.com>
	<56F31170.4020702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56F31170.4020702-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

On Wed, Mar 23, 2016 at 10:58:08PM +0100, Christophe Ricard wrote:
> On Tue, Mar 22, 2016 at 06:20:09AM +0200, Jarkko Sakkinen wrote:
> >Drop field int_queue from tpm_vendor_specific as it is used only by
> >tpm_tis. Probably all of the fields should be eventually dropped and
> >moved to the private structures of different drivers but it is better to
> >do this one step at a time in order not to break anything.
> >
> >Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@...>
> 
> Don't you think read_queue could be dropped instead and merge with int_queue.
> I think they are both used for the same purpose and don't really see a mean to keep 2 queue.
> 
> What do you think ?

Both should be dropped from tpm_vendor_specific.

> Best Regards
> Christophe

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
