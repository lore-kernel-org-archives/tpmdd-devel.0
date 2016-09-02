From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Documentation: tpm: Adds the TPM device
 tree node documentation
Date: Fri, 2 Sep 2016 11:06:13 -0600
Message-ID: <20160902170613.GA5024@obsidianresearch.com>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160902145121.GA9636@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160902145121.GA9636@rob-hp-laptop>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 02, 2016 at 09:51:21AM -0500, Rob Herring wrote:
> > +- linux,sml-base : base address of the Event Log. It is a physical address.
> > +		   sml stands for shared memory log.
> 
> How is it a physical address on an i2c device? Why 2 cells (which needs 
> to be documented also)?

To be clear, as I understand it, this mechanism is a hand off from the
boot firmware to Linux.

The boot firmware talks i2c to the device, does some stuff, writes it
to memory and then linux reads that stuff. I agree it seems crazy to
include a random physical address like that.

The linux,sml-* names appear to have been used by IBM for a long time
on their enterprise PPC platforms (see drivers/char/tpm/tpm_of.c), so
I've expected we have to keep them?

I asked Nayna to document this stuff IBM is doing so the rest of us
in TPM land can have a hope of maintaining it...

Jason

------------------------------------------------------------------------------
