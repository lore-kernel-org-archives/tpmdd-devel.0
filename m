From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/3] tpm/tpm_crb: Enable TPM CRB interface
	for ARM64
Date: Mon, 13 Mar 2017 13:42:16 +0200
Message-ID: <20170313114216.6op3jn4qhnpecrr2@intel.com>
References: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>
	<1489139889-14376-4-git-send-email-anjiandi@codeaurora.org>
	<20170311084244.shypuhzdtvppscye@intel.com>
	<58C460BE.2090109@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58C460BE.2090109-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 11, 2017 at 02:40:30PM -0600, Jiandi An wrote:
> On 03/11/17 02:42, Jarkko Sakkinen wrote:
> > On Fri, Mar 10, 2017 at 03:58:09AM -0600, Jiandi An wrote:
> > > This enables TPM Command Response Buffer interface driver for
> > > ARM64 and implements an ARM specific TPM CRB start method that
> > > invokes a Secure Monitor Call to request the Firmware to execute
> > > or cancel a TPM 2.0 command.
> > > 
> > > Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > 
> > Does look good to me. I might consider to squash this with the
> > two inline functions.
> > 
> > /Jarkko
> 
> I'll squash the SMC inline function patch with this in next version
> to address this.
> 
> Thanks.
> - Jiandi

Thanks!

/Jarkko

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
