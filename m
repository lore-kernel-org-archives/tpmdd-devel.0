From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] tpm, tpm_crb: runtime power management
Date: Thu, 16 Jun 2016 14:44:55 -0600
Message-ID: <20160616204455.GA2744@obsidianresearch.com>
References: <1465340522-1112-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1465340522-1112-4-git-send-email-jarkko.sakkinen@linux.intel.com>
	<CA+i0qc7S4DKWkBKxBygpGcgV0e9Mwc6R33j-rkrj984HZo1VSQ@mail.gmail.com>
	<20160616195735.GA30378@intel.com>
	<CA+i0qc4+xh0iehkMVp0Bat+z=ckogMH8ThniaAR_21MTZbqsWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+i0qc4+xh0iehkMVp0Bat+z=ckogMH8ThniaAR_21MTZbqsWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomasw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 16, 2016 at 11:26:48PM +0300, Tomas Winkler wrote:

> > It is compiled out if it is unused. Why would you want to trash the code
> > with #ifdef cages if they are not necessary? I can add /* CONFIG_PM */
> > before the function if that makes it cleaner.
> 
> I'm not sure about that, I believe it  just suppresses warnings.
> You will need something --gc-sessions int the linker, I'm not sure
> this is used by kernel.

No, it is fine. The compiler drops unused static functions, that is
what the attribute is for. It always does this, so supressing the
warning is the desire behavior. The kernel preference is to avoid
ifdefs and always compile all the code to avoid problems with config
option combinations.

--gc-sections isn't useful unless -ffunction-section is used, which the 
kernel doesn't do. Fortunately the dead code is removed by the
compiler, not the linker.

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
