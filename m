From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not run tpm2_shutdown
Date: Thu, 25 May 2017 14:09:31 -0600
Message-ID: <20170525200931.GA12733@obsidianresearch.com>
References: <1495717956-14252-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170525155059.GA5151@obsidianresearch.com>
 <f6c024ae-fe93-251a-a176-1f27f25b1e21@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f6c024ae-fe93-251a-a176-1f27f25b1e21@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 04:04:24PM -0400, Stefan Berger wrote:
> On 05/25/2017 11:50 AM, Jason Gunthorpe wrote:
> >On Thu, May 25, 2017 at 09:12:36AM -0400, Stefan Berger wrote:
> >>The tpm2_shutdown does not work with the VTPM proxy driver since the
> >>function only gets called when the backend file descriptor is already
> >>closed and at this point no data can be sent anymore. A proper shutdown
> >>would have to be initated by a user space application, such as a container
> >>management stack, that sends the command via the character device before
> >>terminating the TPM emulator.
> >>
> >>To avoid the tpm2_shutdown we introduce a TPM_CHIP_FLAG_NO_SHUTDOWN flag
> >>that only the VTPM proxy driver sets. This also avoids misleading kernel
> >>log messages.
> >This seems strange to me..
> >
> >Why isn't ops null if the fd has gone away?
> >
> >What is the call flow that hits this?
> 
> In this function here.
> 
> static void tpm_del_char_device(struct tpm_chip *chip)
> {
>     cdev_device_del(&chip->cdev, &chip->dev);
> 
>     /* Make the chip unavailable. */
>     mutex_lock(&idr_lock);
>     idr_replace(&dev_nums_idr, NULL, chip->dev_num);
>     mutex_unlock(&idr_lock);
> 
>     /* Make the driver uncallable. */
>     down_write(&chip->ops_sem);
>     if (chip->flags & TPM_CHIP_FLAG_TPM2)
>         tpm2_shutdown(chip, TPM2_SU_CLEAR);
>     chip->ops = NULL;
>     up_write(&chip->ops_sem);
> }
> 
> The request cannot be deliver because the anonymous fd has been closed
> already.

The driver must always be able to process requests until
tpm_del_char_device completes, so this is triggering an existing bug
in vtpm. This change in core behvior is not going to fix the bug.

eg a request from sysfs/etc could come in between vtpm fd closure and
tpm_del_char_device, and it still must be handled properly.

I guess you need to have transmit command fail fast once the fd is
closed.

Jason
