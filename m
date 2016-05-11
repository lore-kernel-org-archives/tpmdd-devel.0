From: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG,
 bisect] tpm: Remove all uses of drvdata from the TPM Core
Date: Wed, 11 May 2016 07:29:48 -0700
Message-ID: <20160511142948.GA1715@hudson.localdomain>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1461000376-2888-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160510135523.GA1943@hudson.localdomain>
	<201605101505.u4AF5nHd032349@d03av04.boulder.ibm.com>
	<20160511012617.GA4657@hudson.localdomain>
	<201605111027.u4BARtQ4021061@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201605111027.u4BARtQ4021061-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Wed, May 11, 2016 at 06:27:52AM -0400, Stefan Berger wrote:
> Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 05/10/2016 09:26:17 PM:
> 
[...]
> 
> I forgot to cc you on the patch and obviously you weren't cc'ed through 
> the Reported-by: line.
> 
> Here's a pointer to the patch.
> 
> http://thread.gmane.org/gmane.comp.encryption.tpmdd.devel/974
> 
> 
> Thanks for testing and bisecting.
> 
> Regards,
>     Stefan
> 
[...]

I tested out the patch and it fixed the problem.  Thanks Stefan.

I would add my Tested-by but I couldn't find the patch on the main
Linux mailing list.  Perhaps I am not subscribed to the right list?

-- 
- Jeremiah Mahler

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
