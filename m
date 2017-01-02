From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/4] tpm: migrate struct tpm_buf to
	struct tpm_chip
Date: Mon, 2 Jan 2017 14:01:01 -0700
Message-ID: <20170102210101.GA5544@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-2-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170102132213.22880-2-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 02, 2017 at 03:22:07PM +0200, Jarkko Sakkinen wrote:
> Since there is only one thread using TPM chip at a time to transmit data
> we can migrate struct tpm_buf to struct tpm_chip. This makes the use of
> it more fail safe as the buffer is allocated from heap when the device
> is created and not for every transaction.

Eh? What? I don't think that is the case..

We don't serialize until we hit tramsit_cmd at which point the buffer
is already being used and cannot be shared between threads.

Only /dev/tpmX has any sort of locking, but even that is
designed to be optional (eg I patch it out of my kernels), and only
covers userspace, not contention with in-kernel threads.

Why would the resource manager need a single global tpm buffer? That
seems like a big regression from where we have been going. I don't
think this is a good idea to go down this road.

> -	tpm_buf_append(buf, (u8 *) &value2, 4);
> +	tpm_buf_append(buf, (u8 *)&value2, 4);

Please try and avoid this sort of churn in patches that change things..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
