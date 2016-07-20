From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix a race condition
	tpm2_unseal_trusted()
Date: Wed, 20 Jul 2016 23:53:14 +0300
Message-ID: <20160720205314.GA6525@intel.com>
References: <1468973792-17598-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160720164818.GA21460@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160720164818.GA21460-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 20, 2016 at 10:48:18AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 20, 2016 at 03:16:32AM +0300, Jarkko Sakkinen wrote:
> > Unseal and load operations should be done as an atomic unit. This
> > commit fixes the issue by moving TPM mutex handling to tpm_try_get_ops()
> > and tpm_put_ops(), which is probably more logical place for it anyway.
> 
> No..
> 
> 'get_ops' is to be used to hold a persisent kref to a single tpm. It
> cannot block other tpm access.
> 
> Eg a upper protocol might get_ops to for a long period to ensure it
> consistently talks to the same TPM in a multi-tpm system.
> 
> We need something else to solve whatever you are concerned with
> here..

The only use cases I see at the moment for it work this way:

1. Call tpm_try_get_ops.
2. Send a TPM command.
3. Call tpm_put_ops.

I did not find any other form of use. The only use is to make sure that
there are no transactions running before the ops are cleared. Or did I
overlook something perhaps?

Trusted key unseal operation with TPM2 is broken into two operations:

1. Load the given key blob.
2. Unseal the data.

Without locking and unlocking mutex only once there is a race condition.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
