From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM
	family version
Date: Mon, 13 Mar 2017 10:55:47 -0600
Message-ID: <20170313165547.GB25664@obsidianresearch.com>
References: <1489396817-24855-1-git-send-email-Meng.Li@windriver.com>
	<20170313115415.2czyr4woaq4h3ncr@intel.com>
	<529F9A9100AE8045A7A5B5A00A39FBB83DE9325F@ALA-MBC.corp.ad.wrs.com>
	<20170313145958.zoh2fdxnh3ytyr2z@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170313145958.zoh2fdxnh3ytyr2z-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Li, Meng" <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 13, 2017 at 04:59:58PM +0200, Jarkko Sakkinen wrote:
> if (chip->flags & TPM_CHIP_FLAG_TPM2)
> 	ret = sprintf(buf, "TPM 2.0");
> else
> 	ret = sprintf(buf, "TPM 1.x");

And 1.x should be 1.2 or 1.1

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
