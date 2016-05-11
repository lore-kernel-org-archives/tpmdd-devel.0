From: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG,
 bisect] tpm: Remove all uses of drvdata from the TPM Core
Date: Tue, 10 May 2016 18:26:17 -0700
Message-ID: <20160511012617.GA4657@hudson.localdomain>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1461000376-2888-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160510135523.GA1943@hudson.localdomain>
	<201605101505.u4AF5nHd032349@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201605101505.u4AF5nHd032349-2xHzGjyANq4+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Stefan,

On Tue, May 10, 2016 at 11:05:43AM -0400, Stefan Berger wrote:
> Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 05/10/2016 09:55:23 AM:
> 
> > 
> > all,
> > 
> > My machine is locking up during suspend and I have bisected the
> > problem to this patch (e89f8b1ade9cc1a) in the latest linux-next
> > (20160506) kernel.
> > 
> > Let me know if I can test patches or do anything else to help.
> 
> The chip retrieval method in the pm functions is wrong. Sending patch.
> 
>    Stefan
> 
> 

Thanks for the quick reply Stefan.  Let me know when you have a
patch for me to test.

-- 
- Jeremiah Mahler

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
