From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: TPM emulator driver status
Date: Fri, 15 Jan 2016 14:17:28 +0200
Message-ID: <20160115121728.GA14573@intel.com>
References: <20160114132755.GB17547@intel.com>
	<11083.1452692382@warthog.procyon.org.uk>
	<25057.1452778946@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25057.1452778946-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 14, 2016 at 01:42:26PM +0000, David Howells wrote:
> Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> > > Is the TPM emulator likely to go upstream at any point?  Or is it waiting
> > > for some sort of update?
> > 
> > Saw Kens response
> 
> Ken?  Do you mean Stefan?  Or have I missed something?

Ken replied that he was maintaining TPM 1.x and TPM 2.0 emulators but I
guess he was talking about actual user space emulators.

> > and to make sure that we are talking about the same thing we are probably
> > speaking about your patches that currently reside over here:
> > 
> > https://github.com/PeterHuewe/linux-tpmdd/commits/tpm-emulator
> 
> Yes.
> 
> > and not about anything that actually emulates directly a TPM.
> 
> Sorry, you're right: it's an interface across to a userspace TPM.
> 
> > These are my concerns:
> > 
> > * Should be probably broken into two patches with include/linux/wait.h
> >   modifications residing in a separate commit.
> 
> That would be fine.
> 
> > * Should the module be renamed as something else than tpm_user_emul?
> >   It's not a TPM emulator but more like a proxy.
> 
> tpm_user_proxy maybe?

That's much better name (or maybe just tpm_proxy).

> > * I have to admit that I haven't deeply dived into functionality that
> >   vTPM provides. What does it provide exactly? Does this overlap?
> 
> That I can't answer at this point without looking into it.
> 
> David

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
