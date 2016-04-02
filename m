From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: remove redundant code from self-test
	functions
Date: Fri, 1 Apr 2016 21:16:15 -0600
Message-ID: <20160402031615.GA28449@obsidianresearch.com>
References: <1459344045-21602-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160331054623.GB20504@obsidianresearch.com>
	<20160331063756.GA6393@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160331063756.GA6393-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 31, 2016 at 09:37:56AM +0300, Jarkko Sakkinen wrote:
> On Wed, Mar 30, 2016 at 11:46:23PM -0600, Jason Gunthorpe wrote:
> > On Wed, Mar 30, 2016 at 04:20:45PM +0300, Jarkko Sakkinen wrote:
> >   
> > > -		rc = be32_to_cpu(cmd.header.out.return_code);
> > >  		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
> > 
> > This line is the entire reason it is open coded, I see it being
> > removed, but I don't see how the functionality is maintained?
> 
> When tpm_trance_cmd() returns a positive number it is the TPM error code
> that it returns. tpm_pcr_read() does pass through whatever
> tpm_trace_cmd() returns so the above condition should still work as
> expected.

Okay, everything looks fine to me

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
