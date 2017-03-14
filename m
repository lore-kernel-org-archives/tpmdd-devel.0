From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM
 hardware version
Date: Tue, 14 Mar 2017 15:24:25 -0600
Message-ID: <20170314212425.GA29359@obsidianresearch.com>
References: <1489382517-9078-1-git-send-email-Meng.Li@windriver.com>
	<29B2C361-A0C0-410E-ACCA-07AFA382A251@gmx.de>
	<9f67321b-50bd-9e6f-61f8-c29ae14f261f@linux.vnet.ibm.com>
	<074515F2-51E7-485B-B1AB-11B913CC4B46@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <074515F2-51E7-485B-B1AB-11B913CC4B46-Mmb7MZpHnFY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 14, 2017 at 07:58:37PM +0100, Peter Huewe wrote:

> >In practice, I suspect that a single user space application won't
> >support both TPMs. 
> Think of init scripts.
> Which daemon should it start?

Right, ideally we'd have a udev rule that triggers systemd to start
the userspace daemons when a TPM is detected, as other hardware does.

So whatever format we use has to be compatible with udev's matcher..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
