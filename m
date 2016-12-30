From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: TPM 2.0 device driver blocking open
Date: Fri, 30 Dec 2016 08:22:08 -0800
Message-ID: <1483114928.2442.28.camel@linux.vnet.ibm.com>
References: <o45vtc$ur$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o45vtc$ur$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2016-12-30 at 10:53 -0500, Ken Goldman wrote:
> It appears that an open() to the TPM doesn't block if another process
> has /dev/tpm0 open.  It returns -1, an error.
> 
> Questions:
> 
> Is this expected behavior?

It's enforced in drivers/char/tpm/tpm-dev.c by this check


	/* It's assured that the chip will be opened just once,
	 * by the check of is_open variable, which is protected
	 * by driver_lock. */
	if (test_and_set_bit(0, &chip->is_open)) {
		dev_dbg(&chip->dev, "Another process owns this TPM\n");
		return -EBUSY;
	}

so yes, it looks to be expected.

> Was this also true for 1.2?

In tpm 1.2 there was a single access broker daemon (tcsd) which opened
the device, so you could have multiple applications using the TPM but
only one device open.

> Is there any way to change it.  I didn't set O_NOBLOCK.  Is there 
> perhaps an ioctl()?
> Is this something that should be added?

I think for the 2.0 model of every application getting direct access,
we should make it so that every open gets a separate read/write stream
to the tpm which we send in via the locked version of tpm_transmit()
and just let the chip->tpm_mutex sort out the accesses.

I can code up a patch if no-one's already done it.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
