From: <Peter.Huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: TPM2 Driver Support in distros (part 1)
Date: Mon, 25 Jul 2016 16:47:55 +0000
Message-ID: <40c30de1f491455c93a79dd6f5420fc4@MUCSE612.infineon.com>
References: <nn1ajt$rpd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

[resend]
Hi Ken,
> Is there a web site or other document that lists which distros or kernels include a TPM 2.0 driver?
> I support a TPM 2.0 user space TSS.  Not seeing /dev/tpm0 is a typical error that prospective users see, and I'd like to give them some guidance.
> If there is no such page, and people are willing to post information, I'd be happy to include it on my TSS page.

Not aware, but I seriously doubt it.
Speaking of PCClient based platforms, everything with:
- Kernel >4.0 works with CRB out of the box, with FIFO if tpm_tis.force=1 as module parameter
- Kernel >4.4 works with FIFO out of the box


Thanks
Peter





------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
