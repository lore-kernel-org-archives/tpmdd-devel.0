From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not run tpm2_shutdown
Date: Thu, 25 May 2017 15:33:48 -0700
Message-ID: <20170525223348.uh66n37dnvz3eptl@intel.com>
References: <1495717956-14252-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170525155059.GA5151@obsidianresearch.com>
	<f6c024ae-fe93-251a-a176-1f27f25b1e21@linux.vnet.ibm.com>
	<20170525200931.GA12733@obsidianresearch.com>
	<9ff88c24-ca7a-1867-7284-17689fdac655@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9ff88c24-ca7a-1867-7284-17689fdac655-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 04:32:50PM -0400, Stefan Berger wrote:
> On 05/25/2017 04:09 PM, Jason Gunthorpe wrote:
> > On Thu, May 25, 2017 at 04:04:24PM -0400, Stefan Berger wrote:
> > > On 05/25/2017 11:50 AM, Jason Gunthorpe wrote:
> > > > On Thu, May 25, 2017 at 09:12:36AM -0400, Stefan Berger wrote:
> > > > > The tpm2_shutdown does not work with the VTPM proxy driver since the
> > > > > function only gets called when the backend file descriptor is already
> > > > > closed and at this point no data can be sent anymore. A proper shutdown
> > > > > would have to be initated by a user space application, such as a container
> > > > > management stack, that sends the command via the character device before
> > > > > terminating the TPM emulator.
> > > > > 
> > > > > To avoid the tpm2_shutdown we introduce a TPM_CHIP_FLAG_NO_SHUTDOWN flag
> > > > > that only the VTPM proxy driver sets. This also avoids misleading kernel
> > > > > log messages.
> > > > This seems strange to me..
> > > > 
> > > > Why isn't ops null if the fd has gone away?
> > > > 
> > > > What is the call flow that hits this?
> > > In this function here.
> > > 
> > > static void tpm_del_char_device(struct tpm_chip *chip)
> > > {
> > >      cdev_device_del(&chip->cdev, &chip->dev);
> > > 
> > >      /* Make the chip unavailable. */
> > >      mutex_lock(&idr_lock);
> > >      idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> > >      mutex_unlock(&idr_lock);
> > > 
> > >      /* Make the driver uncallable. */
> > >      down_write(&chip->ops_sem);
> > >      if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > >          tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > >      chip->ops = NULL;
> > >      up_write(&chip->ops_sem);
> > > }
> > > 
> > > The request cannot be deliver because the anonymous fd has been closed
> > > already.
> > The driver must always be able to process requests until
> > tpm_del_char_device completes, so this is triggering an existing bug
> > in vtpm. This change in core behvior is not going to fix the bug.
> > 
> > eg a request from sysfs/etc could come in between vtpm fd closure and
> > tpm_del_char_device, and it still must be handled properly.
> > 
> > I guess you need to have transmit command fail fast once the fd is
> > closed.
> 
> It doesn't hang. Everything is torn down immediately. What is primarily
> annoying are these two log messages:
> tpm tpm0: tpm_transmit: tpm_send: error -32
> tpm tpm0: transmit returned -32 while stopping the TPM
> 
> 
>     Stefan

It's been a while since I've looked into vtpm code. Why was fd closed
before the above? I can go this through myself once I'm back in Finland
next week. Just have forgotten this detail and do not have time to study
this right now.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
