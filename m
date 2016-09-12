From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4 v2] tpm/tpm_crb: cache cmd_size
	register value.
Date: Mon, 12 Sep 2016 11:06:17 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CDBDD@hasmsx108.ger.corp.intel.com>
References: <1473635035-14443-1-git-send-email-tomas.winkler@intel.com>
	<1473635035-14443-3-git-send-email-tomas.winkler@intel.com>
	<20160912104916.GB15636@intel.com> <20160912105446.GC15636@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160912105446.GC15636-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> 
> On Mon, Sep 12, 2016 at 01:49:16PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Sep 12, 2016 at 02:03:53AM +0300, Tomas Winkler wrote:
> > > Instead of expensive register access on retrieving cmd_size on each
> > > send, save the value during initialization in the private context.
> > > The value doesn't change.
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > $ git am -3
> > ~/Downloads/2-4-v2-tpm-tpm_crb-cache-cmd_size-register-value..patch
> > Applying: tpm/tpm_crb: cache cmd_size register value.
> > fatal: sha1 information is lacking or useless (drivers/char/tpm/tpm_crb.c).
> > error: could not build fake ancestor
> > Patch failed at 0001 tpm/tpm_crb: cache cmd_size register value.
> > The copy of the patch that failed is found in: .git/rebase-apply/patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> > VCS_INFO_get_data_git:225: no such file or directory: .git/rebase-
> apply/msg-clean
> 
> I did this:
> 
> patch -p1 < ~/Downloads/2-4-v2-tpm-tpm_crb-cache-cmd_size-register-
> value..patch
> git commit -a -s --author="Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>"
> 
> It's now pushed. Could you check that it looks OK for you so that I can include
> this to the next pull request?

Looks great. 

Thanks
Tomas

------------------------------------------------------------------------------
