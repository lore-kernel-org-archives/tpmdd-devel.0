From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 13 Jan 2017 09:40:08 -0800
Message-ID: <1484329208.2527.18.camel@HansenPartnership.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
	<20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
	<20170112205628.qh3yf2jcargtw6qv@intel.com>
	<20170113172537.GA31125@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170113172537.GA31125-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-13 at 10:25 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 12, 2017 at 10:56:28PM +0200, Jarkko Sakkinen wrote:
> 
> > >  dev_t tpm_devt;
> > 
> > But they should have different major device numbers.
> 
> major/minors don't really matter these days since they are dynamic

Right, although we have this weird piece of code:


	if (chip->dev_num == 0)
		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
	else
		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);

So the first TPM device gets the MISC_MAJOR with TPM_MINOR and the rest
get the dynamic major/minor.  It means when you do an ls on a complex
system you get something like:

crw------- 1 root root  10,   224 Jan 13 06:21 /dev/tpm0
crw------- 1 root root 246,     1 Jan 13 09:38 /dev/tpm1
crw-rw-rw- 1 root root 246, 65536 Jan 13 06:21 /dev/tpms0
crw-rw-rw- 1 root root 246, 65537 Jan 13 09:38 /dev/tpms1

Perhaps it's time just to junk the reserved misc minor?

James


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
