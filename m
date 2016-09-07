From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] tmp/tpm_crb: fix Intel PTT hw bug
 during idle state
Date: Wed, 7 Sep 2016 15:55:53 -0600
Message-ID: <20160907215553.GC29666@obsidianresearch.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-3-git-send-email-tomas.winkler@intel.com>
	<20160907161744.GB4791@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBAD4@hasmsx108.ger.corp.intel.com>
	<20160907214448.GA29666@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBB13@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542CBB13-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 07, 2016 at 09:52:38PM +0000, Winkler, Tomas wrote:
> > I don't get it, what is the difference? read ordering?
> 
> No, read order is not relevant   here, just wanted to have each register printed
> 
> dev_dbg(dev, "cmd_hi = 0x%X cmd_low = 0x%X cmd_size %d\n",
>                 pa_high, pa_low, cmd_size);

Oh, well if you've dropped the dev_dbg then drop the needless change
too.

Jason

------------------------------------------------------------------------------
