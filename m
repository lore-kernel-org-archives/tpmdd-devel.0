From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 1/4] tpm: migrate struct tpm_buf to struct tpm_chip
Date: Tue, 3 Jan 2017 02:57:37 +0200
Message-ID: <20170103005737.t2qrc32xzdnvqy4b@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <20170102132213.22880-2-jarkko.sakkinen@linux.intel.com>
 <20170102210101.GA5544@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170102210101.GA5544@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 02, 2017 at 02:01:01PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 02, 2017 at 03:22:07PM +0200, Jarkko Sakkinen wrote:
> > Since there is only one thread using TPM chip at a time to transmit data
> > we can migrate struct tpm_buf to struct tpm_chip. This makes the use of
> > it more fail safe as the buffer is allocated from heap when the device
> > is created and not for every transaction.
> 
> Eh? What? I don't think that is the case..
> 
> We don't serialize until we hit tramsit_cmd at which point the buffer
> is already being used and cannot be shared between threads.

There is a regression in the patch. All functions that use 'tr_buf'
should take tpm_mutex first and use TPM_TRANSMIT_UNLOCKED. There's
also a similar regression in TPM space patch that I have to correct.

> Why would the resource manager need a single global tpm buffer? That
> seems like a big regression from where we have been going. I don't
> think this is a good idea to go down this road.

What? 'tr_buf' is not specifically for resource manager. This commit
makes creating TPM commands more fail-safe because there is no need
to allocate page for every transmit.

For RM decorations this is really important because I rather would have
them fail as rarely as possible. If this would become a scalability
issue then the granularity could be reconsidered.

> > -	tpm_buf_append(buf, (u8 *) &value2, 4);
> > +	tpm_buf_append(buf, (u8 *)&value2, 4);
> 
> Please try and avoid this sort of churn in patches that change things..

It wasn't there on purpose. I do not know how these slipped. I can
clean these up.

> Jason

/Jarkko
