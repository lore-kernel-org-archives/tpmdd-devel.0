From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix the cleanup of struct tpm_chip
Date: Tue, 9 Feb 2016 08:27:35 +0200
Message-ID: <20160209062735.GA25621@intel.com>
References: <1454988630-27942-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160209052655.GA12657@obsidianresearch.com>
	<20160209061951.GA29607@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160209061951.GA29607-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 09, 2016 at 08:19:51AM +0200, Jarkko Sakkinen wrote:
> On Mon, Feb 08, 2016 at 10:26:55PM -0700, Jason Gunthorpe wrote:
> > On Tue, Feb 09, 2016 at 05:30:30AM +0200, Jarkko Sakkinen wrote:
> > > If the initialization fails before tpm_chip_register(), put_device()
> > > will be not called, which causes release callback not to be called.
> > > This patch fixes the issue by adding put_device() to devres list of
> > > the parent device.
> > 
> > Erm, if you do this, then shouldn't the device_unregister change to
> > device_del to keep the kref balanced?
> 
> Yes, it should. Weird, I added pr_info() (temporarily) to
> tpm_dev_release() and did occur only once and no crashes whatsoever.
> 
> Anyway, you're right.

Update:

https://github.com/jsakkine/linux-tpmdd/commit/a1aa547bbd2178628df798c27abaad073acb2441

I tested that the release gets called (as a sanity check).

Ack?

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
