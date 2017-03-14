From: "Hon Ching(Vicky) Lo" <honclo@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] vTPM: Fix missing NULL check
Date: Tue, 14 Mar 2017 18:42:20 -0400
Message-ID: <1489531340.7013.13.camel@vtpm2014.ibm.com>
References: <1488839535-11822-1-git-send-email-honclo@linux.vnet.ibm.com>
         <20170306231946.GA23953@obsidianresearch.com>
         <1488946363.15595.17.camel@vtpm2014.ibm.com>
         <20170308171729.GC16709@obsidianresearch.com>
         <1489004891.15595.37.camel@vtpm2014.ibm.com>
         <20170308205236.GA28643@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170308205236.GA28643@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-03-08 at 13:52 -0700, Jason Gunthorpe wrote:
> On Wed, Mar 08, 2017 at 03:28:11PM -0500, Hon Ching(Vicky) Lo wrote:
> > On Wed, 2017-03-08 at 10:17 -0700, Jason Gunthorpe wrote:
> > > On Tue, Mar 07, 2017 at 11:12:43PM -0500, Hon Ching(Vicky) Lo wrote:
> > > > On Mon, 2017-03-06 at 16:19 -0700, Jason Gunthorpe wrote:
> > > 
> > > > > Also, how does locking work here? Does the vio core prevent
> > > > > tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove from running
> > > > > concurrently?
> > > > 
> > > > No, vio core doesn't prevent tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove
> > > > from running concurrently.
> > > > 
> > > > vio_bus_probe calls vio_cmo_bus_probe which calls tpm_ibmvtpm_get_desired_dma.
> > > > tpm_ibmvtpm_get_desired_dma is called before the code enters critical section.
> > > > 
> > > > There is no locking mechanism around tpm_ibmvtpm_remove in vio_bus_remove.
> > > > 
> > > > What's the concern here?
> > > 
> > > tpm_ibmvtpm_remove makes the pointer that tpm_ibmvtpm_get_desired_dma
> > > is accessing invalid, so some kind of locking is technically required
> > > so that the two things do not create a use after free race:
> > 
> > I don't think we need to worry about locking in this specific case. 
> > tpm_ibmvtpm_get_desired_dma was designed to return a default value
> > in the case when the chip is not available.
> 
> You have to worry about it to prevent a use after free race:
> 
>           CPU0                                CPU1
> tpm_ibmvtpm_remove()                 tpm_ibmvtpm_get_desired_dma()
> 
> 				     chip = dev_get_drvdata(dev);
> dev_set_drvdata(&vdev->dev, NULL);  
>                                      if (chip)
>                  		        ibmvtpm = dev_get_drvdata(&chip->dev);
> kfree(ibmvtpm);
>                                         // *ibmvtpm is now a use-after-free
> 
> Jason
> 
I have dug further up along the call stack of
tpm_ibmvtpm_get_desired_dma() and found that there is a locking
mechanism in place at the bus probe level.  'probe' and 'remove'
callbacks are both surrounded by mutex_lock and mutex_unlock on the
device.  The code is in the really_probe() and
device_release_driver_internal() accordingly.  

Thanks for pointing this out!  

Vicky
