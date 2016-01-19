From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Tue, 19 Jan 2016 15:48:51 -0700
Message-ID: <20160119224851.GA31745@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
	<201601191753.u0JHrku2031608@d01av01.pok.ibm.com>
	<20160119180802.GA8038@obsidianresearch.com>
	<1453241668.2673.31.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453241668.2673.31.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 19, 2016 at 05:14:28PM -0500, Mimi Zohar wrote:
> On Tue, 2016-01-19 at 11:08 -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 19, 2016 at 12:53:40PM -0500, Stefan Berger wrote:
> > >    This series has absolutely nothing to do with resource
> > >    management.
> > 
> > Sure the patch doesn't, but the proposed application does.
> > 
> > Linux namespaces is all about resource management.
> 
> huh?  namespacing is about isolation.

isolation of what? Every namespace in linux has a defined set of
kernel managed resources it contains.

> > This is an interesting way to make a software TPM,
>
> That's the intention, not namespacing the TPM.

Did you read the patch?

 The primary goal of this series of patches is enabling vTPM for containers
 and hooking them up to a (future) namespaced IMA. However, the driver can
 also be used for simulating a hardware TPM on the host.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
