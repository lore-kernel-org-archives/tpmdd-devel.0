From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm/tpm_crb: implement tpm crb idle
 state
Date: Wed, 7 Sep 2016 23:16:46 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CBBB0@hasmsx108.ger.corp.intel.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-2-git-send-email-tomas.winkler@intel.com>
	<20160907161548.GA4791@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBABC@hasmsx108.ger.corp.intel.com>
	<20160907215502.GB29666@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBB41@hasmsx108.ger.corp.intel.com>
	<20160907221908.GA30192@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBB6A@hasmsx108.ger.corp.intel.com>
	<20160907223934.GA32261@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160907223934.GA32261-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> On Wed, Sep 07, 2016 at 10:28:45PM +0000, Winkler, Tomas wrote:
> > >
> > > On Wed, Sep 07, 2016 at 10:17:22PM +0000, Winkler, Tomas wrote:
> > >
> > > > I think there is a memory leak in tpm_tis on the error path; maybe
> > > > a missing call to dev_put, not sure I had just quick look.
> > >
> > > tpmm_alloc uses devm, so the put happens in a devm cleanup.
> > >
> > > Assuming everything still works the way it was intended :/
> >
> > How this is triggered on the error path, if this didn't call yet to
> > the device_add()
> 
> In the chip code 'pdev' is the device passed in to the driver's probe function.
> devm_add_action is applied to the pdev, which is undone by devm error
> unwind when the driver's probe fails.

Okay,  I see now.
Tomas 

------------------------------------------------------------------------------
