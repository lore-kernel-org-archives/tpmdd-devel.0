From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Tue, 22 Nov 2016 09:37:20 -0700
Message-ID: <20161122163720.GB3956@obsidianresearch.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
 <20161119182228.GA22775@obsidianresearch.com>
 <5831ED24.6070102@linux.vnet.ibm.com>
 <20161121171530.GB22237@obsidianresearch.com>
 <20161121202915.he2pgzoqza3rugnd@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121202915.he2pgzoqza3rugnd@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Nayna <nayna@linux.vnet.ibm.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 10:29:15PM +0200, Jarkko Sakkinen wrote:

> I just went through tpm_bios_log_setup(), tpm_read_log_of() and
> tpm_read_log_acpi(). The error handling is sound now but the condition
> should be in tpm_bios_log_setup(). Not in tpm_chip_register().
> 
> It is applied but if you don't mind I would like make a small commit
> that moves the condition to that function.

I'm not particularly concerned where the check lives..

Jason
