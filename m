From: "Hon Ching(Vicky) Lo" <honclo@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] vTPM: Fix missing NULL check
Date: Wed, 08 Mar 2017 15:28:11 -0500
Message-ID: <1489004891.15595.37.camel@vtpm2014.ibm.com>
References: <1488839535-11822-1-git-send-email-honclo@linux.vnet.ibm.com>
         <20170306231946.GA23953@obsidianresearch.com>
         <1488946363.15595.17.camel@vtpm2014.ibm.com>
         <20170308171729.GC16709@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170308171729.GC16709@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-03-08 at 10:17 -0700, Jason Gunthorpe wrote:
> On Tue, Mar 07, 2017 at 11:12:43PM -0500, Hon Ching(Vicky) Lo wrote:
> > On Mon, 2017-03-06 at 16:19 -0700, Jason Gunthorpe wrote:
> 
> > > Also, how does locking work here? Does the vio core prevent
> > > tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove from running
> > > concurrently?
> > 
> > No, vio core doesn't prevent tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove
> > from running concurrently.
> > 
> > vio_bus_probe calls vio_cmo_bus_probe which calls tpm_ibmvtpm_get_desired_dma.
> > tpm_ibmvtpm_get_desired_dma is called before the code enters critical section.
> > 
> > There is no locking mechanism around tpm_ibmvtpm_remove in vio_bus_remove.
> > 
> > What's the concern here?
> 
> tpm_ibmvtpm_remove makes the pointer that tpm_ibmvtpm_get_desired_dma
> is accessing invalid, so some kind of locking is technically required
> so that the two things do not create a use after free race:
> 

I don't think we need to worry about locking in this specific case. 
tpm_ibmvtpm_get_desired_dma was designed to return a default value
in the case when the chip is not available.

There is a locking mechanism between the probe and the remove at vio
level.  The 'get_desired_dma' is called before acquiring a lock 
within the probe code is rather a design than a bug.  



Vicky

> > > +	/* For tpm_ibmvtpm_get_desired_dma */
> > > +	dev_set_drvdata(&vdev->dev, NULL);
> > >  	kfree(ibmvtpm);
> 
> Eg with the kfree above.
> 
> It may be that the driver core prevents probe/remove from running
> concurrently and things are fine, but this is something to confirm..
> 
> Jason
> 
