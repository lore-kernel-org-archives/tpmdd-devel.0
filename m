From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] vTPM: Fix missing NULL check
Date: Wed, 8 Mar 2017 10:17:29 -0700
Message-ID: <20170308171729.GC16709@obsidianresearch.com>
References: <1488839535-11822-1-git-send-email-honclo@linux.vnet.ibm.com>
	<20170306231946.GA23953@obsidianresearch.com>
	<1488946363.15595.17.camel@vtpm2014.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488946363.15595.17.camel-0wQ8x0XRVuT1ENwx4SLHqw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 07, 2017 at 11:12:43PM -0500, Hon Ching(Vicky) Lo wrote:
> On Mon, 2017-03-06 at 16:19 -0700, Jason Gunthorpe wrote:

> > Also, how does locking work here? Does the vio core prevent
> > tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove from running
> > concurrently?
> 
> No, vio core doesn't prevent tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove
> from running concurrently.
> 
> vio_bus_probe calls vio_cmo_bus_probe which calls tpm_ibmvtpm_get_desired_dma.
> tpm_ibmvtpm_get_desired_dma is called before the code enters critical section.
> 
> There is no locking mechanism around tpm_ibmvtpm_remove in vio_bus_remove.
> 
> What's the concern here?

tpm_ibmvtpm_remove makes the pointer that tpm_ibmvtpm_get_desired_dma
is accessing invalid, so some kind of locking is technically required
so that the two things do not create a use after free race:

> > +	/* For tpm_ibmvtpm_get_desired_dma */
> > +	dev_set_drvdata(&vdev->dev, NULL);
> >  	kfree(ibmvtpm);

Eg with the kfree above.

It may be that the driver core prevents probe/remove from running
concurrently and things are fine, but this is something to confirm..

Jason

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
