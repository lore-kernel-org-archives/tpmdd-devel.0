From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Mon, 21 Nov 2016 22:29:15 +0200
Message-ID: <20161121202915.he2pgzoqza3rugnd@intel.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
 <20161119182228.GA22775@obsidianresearch.com>
 <5831ED24.6070102@linux.vnet.ibm.com>
 <20161121171530.GB22237@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121171530.GB22237@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Nayna <nayna@linux.vnet.ibm.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 10:15:30AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 21, 2016 at 12:06:20AM +0530, Nayna wrote:
> > >  	rc = tpm_bios_log_setup(chip);
> > >-	if (rc == -ENODEV)
> > >+	if (rc != 0 && rc != -ENODEV)
> > >  		return rc;
> > 
> > This will return in case of -EFAULT as well, where the check is that log is
> > already initialized. Do we want to fail the probe here as well ?
> > 
> > -EFAULT is returned from tpm_read_log() as below:
> 
> That is fine, we should never read the log twice.

I just went through tpm_bios_log_setup(), tpm_read_log_of() and
tpm_read_log_acpi(). The error handling is sound now but the condition
should be in tpm_bios_log_setup(). Not in tpm_chip_register().

It is applied but if you don't mind I would like make a small commit
that moves the condition to that function.

I think tpm_chip_register() should only care when something went wrong.

/Jarkko
