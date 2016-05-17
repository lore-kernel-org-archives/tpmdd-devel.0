From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2] tpm: Factor out common startup code
Date: Tue, 17 May 2016 10:53:04 -0600
Message-ID: <20160517165304.GA19976@obsidianresearch.com>
References: <1463423147-9874-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20160517041557.GA29299@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160517041557.GA29299@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: andrew.zamansky@nuvoton.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, May 17, 2016 at 07:15:57AM +0300, Jarkko Sakkinen wrote:
> On Mon, May 16, 2016 at 12:25:47PM -0600, Jason Gunthorpe wrote:
> > Provide some flags in tpm_class_ops to allow drivers to opt-in to the
> > common startup sequence. This is the sequence used by tpm_tis and
> > tpm_crb.
> > 
> > All drivers should set this flag.
> 
> The commit message should be a much much more verbose I cannot include
> this without a better explanation. Please update this for the next
> revision.

What more description do you want to see?

> > +	if (chip->ops->flags & TPM_OPS_PROBE_TPM2) {
> > +		rc = tpm2_probe(chip);
> > +		if (rc)
> > +			return rc;
> > +	}
> 
> Dead code.

Yes, this is used by the follow on driver updates. Andrew is going to
be sending a patch that uses it right away. I don't really care if it
gets shifted to that patch or not..

Jason
