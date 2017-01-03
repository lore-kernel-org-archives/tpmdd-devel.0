From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 3 Jan 2017 17:21:28 -0500
Message-ID: <o4h852$760$2@blaine.gmane.org>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<20170103135121.4kh3jld5gaq3ptj4@intel.com>
	<1483461370.2464.19.camel@HansenPartnership.com>
	<20170103214702.GC29656@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170103214702.GC29656-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/3/2017 4:47 PM, Jason Gunthorpe wrote:
>
> I think we should also consider TPM 1.2 support in all of this, it is
> still a very popular piece of hardware and it is equally able to
> support a RM.

I suspect that TPM 2.0 and TPM 1.2 are so different that there may be 
little or no code in common.

My immediate need is for a 2.0 resource manager, since it's a gap in the 
technology, while 1.2 does have tcsd.




------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
