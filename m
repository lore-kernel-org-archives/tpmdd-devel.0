From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Fri, 12 Feb 2016 19:00:25 -0700
Message-ID: <20160213020025.GA23530@obsidianresearch.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
	<201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
	<20160213011130.GA2547@obsidianresearch.com>
	<201602130128.u1D1S2Xn006955@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602130128.u1D1S2Xn006955-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 12, 2016 at 08:31:21PM -0500, Stefan Berger wrote:

> The vtpm driver will introduce chip->priv, which will point to
> vtpm_dev. For

Why not just use chip->vendor.priv? Aka TPM_VPRIV

> this reason we need to hold a reference to the vtpm_dev->dev in the
> front end.

Yes, but all drivers are like this. Most will just kfree their priv immediately

All sane Linux core subsystems guarentee that after their unregister
returns the driver callbacks will be done and uncallable, it is a bug
that tpm does not do this.

> So we could optimize it:
> 
> if (chip->priv)
>         get_device(chip->dev.parent);

That doesn't address the race

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
