From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v5 1/3] tpm: move event log init functions to
 tpm_eventlog_init.c
Date: Thu, 24 Nov 2016 23:01:05 +0200
Message-ID: <20161124210105.ykmbednlmae52tla@intel.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479922057-8752-2-git-send-email-nayna@linux.vnet.ibm.com>
 <20161123193830.GB13927@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161123193830.GB13927@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 23, 2016 at 12:38:30PM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 12:27:35PM -0500, Nayna Jain wrote:
> > The device driver code for the event log has the init functions and
> > TPM 1.2 parsing logic both defined in same file(tpm_eventlog.c).
> > 
> > Since the initialization functions are common with the TPM 2.0 event
> > log support, this patch splits tpm_eventlog.c to have only TPM 1.2
> > event log parsing logic and moves the init functions into
> > tpm_eventlog_init.c.
> 
> I think I'd rather see a tpm_eventlog1.c/tpm_eventlog2.c than this
> _init thing..
> 
> Jason

I would rather see tpm1-eventlog.c and tpm2-eventlog.c as we already
have tpm2-cmd.c for the sake of consistency.

/Jarkko
