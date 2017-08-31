From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: Bug in TPM Spi bit protocol implementation?
Date: Thu, 31 Aug 2017 09:28:23 +0000
Message-ID: <417427822bed4508914ac9a510c25de0@MUCSE603.infineon.com>
References: <4f59b268-6897-702c-f440-bbf35f2cf0c9@gmail.com>
 <d00fdebd2ac24743b208dec177ae1b45@MUCSE612.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <d00fdebd2ac24743b208dec177ae1b45-FoTRpVxct+aJSz+rYg/bSJowlv4uC7bZ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: raghu.ncstate-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Peter.Huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> -----Original Message-----
> From: Raghu Krishnamurthy [mailto:raghu.ncstate-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, August 29, 2017 11:42 PM
> To: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Huewe Peter (IFAG CCS ESS D SW A)
> Subject: Bug in TPM Spi bit protocol implementation?
>
> Hello,
>
> I was using the TPM driver(for TPM2.0) from the 4.9 kernel sources and
> saw a potential issue in tpm_tis_spi.c, from commit id 0edbfea5.
>
> In the tpm_spi_read/write_bytes method, we have the following loop,
> which looks like it is attempting to handle the wait byte in the spi
> bit protocol(although the comments do not refer to it):
>
>          /* According to TCG PTP specification, if there is no TPM
> present at
>           * all, then the design has a weak pull-up on MISO. If a TPM is not
>           * present, a pull-up on MISO means that the SB controller
> sees a 1,
>           * and will latch in 0xFF on the read.
>           */
>          for (i = 0; (phy->rx_buf[0] & 0x01) == 0 && i < TPM_RETRY; i++) {
>                  spi_xfer.len = 1;
>                  spi_message_init(&m);
>                  spi_message_add_tail(&spi_xfer, &m);
>                  ret = spi_sync_locked(phy->spi_device, &m);
>                  if (ret < 0)
>                          goto exit;
>          }
>
> When the first 4 bytes(command and address) are clocked out of a SPI
> controller to the TPM, 4 bytes are clocked into the SPI controller as well.
> Per the PC Client PTP for TPM2.0, the least significant bit of the 4th
> byte, of the 4 bytes clocked in will tell us if the TPM requires a
> wait state or not.
> phy-
> >rx_buf[0], will correspond to the first byte clocked in(since most
> >SPI
> controllers have FIFO for data read in), which means, the wait state
> is represented in phy->rx_buf[3].

Yep, that was a bug, that I've fixed already, also for 4.9:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?h=v4.9.45&id=d513cf24e240f8c7a9127b566b915ce9730fd23e

> So the loop should really first check for (phy->rx_buf[3] & 0x1 == 0),
> and then enter the loop to check for wait states. Also it must exit
> the loop with an error if the maximum number of tries are up and the
> TPM did not change stop inserting wait states.

Another bug, fixed as well:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?h=v4.9.45&id=daa432c1a65a541b413111328f8aea61161ad372

> If the loop was not intended to handle the SPI bit protocol wait
> bytes, then this is a missing piece in the driver and causes issues
> when being used on systems with a SPI controller where the TPM inserts wait states.

This loop is intended to handle wait states, though as far as I know all TPMs, that I have access to, do not normally generate wait states, so my tests cannot cover that behavior. Do you have a TPM that generates wait states during normal operation? Where can I get one?

> If a TPM does not insert a wait state, and the first byte of data
> happens to be 0, this loop simply reads a bunch of bytes until there
> is byte that has bit
> 0 set to 1 is read. This may be legitimate data, which will then be lost.
>
> If the TPM does insert a wait state, it will be missed because it is
> present in
> phy->rx_buf[3] and not phy->rx_buf[0].
>
> Please let me know if this makes sense.

Your analysis is correct. Please send such questions also to the tpmdd mailing list (see CC), so that other people are aware of it and can perhaps help you.

> Thanks
>
> Raghu

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
