From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: fix iTPM probe via probe_itpm()
	function
Date: Thu, 12 Jan 2017 11:50:05 -0700
Message-ID: <20170112185005.GC12836@obsidianresearch.com>
References: <6bd0d2fe-f979-a4dc-7c4d-54036f4d37f8@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6bd0d2fe-f979-a4dc-7c4d-54036f4d37f8-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
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

On Thu, Jan 12, 2017 at 07:12:06PM +0100, Maciej S. Szmigiero wrote:
> probe_itpm() function is supposed to send command without an itpm flag set
> and if this fails to repeat it, this time with the itpm flag set.
> 
> However, commit 41a5e1cf1fe15 ("tpm/tpm_tis: Split tpm_tis driver into a
> core and TCG TIS compliant phy") moved the itpm flag from an "itpm"
> variable to a TPM_TIS_ITPM_POSSIBLE chip flag, so setting the
> (now function-local) itpm variable no longer had any effect.
> 
> Finally, this function-local itpm variable was removed by
> commit 56af322156dbe9 ("tpm/tpm_tis: remove unused itpm variable")
> 
> Tested only on non-iTPM TIS TPM.
> 
> Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>

could you also change the name of TPM_TIS_ITPM_POSSIBLE
to TPM_TIS_ITPM_WORKAROUND ?

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
