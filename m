From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 3/3] tpm: add longer timeouts for creation commands.
Date: Tue, 23 Jan 2018 15:12:03 +0200
Message-ID: <20180123131203.bdhlqdqabhtwnipi@linux.intel.com>
References: <20180123112731.3687-1-tomas.winkler@intel.com>
 <20180123112731.3687-3-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180123112731.3687-3-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Alexander Usyskin <alexander.usyskin@intel.com>, tpmdd-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 23, 2018 at 01:27:31PM +0200, Tomas Winkler wrote:
> TPM2_CC_Create(0x153) and TPM2_CC_CreatePrimary (0x131) involve generation
> of crypto keys which can be a computationally intensive task.
> The timeout is set to 3min.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

>From where are these numbers are derived from?

Can you send 1/3 and 2/3 as a separate patch set with a cover
letter (with explanation) and this as a separate patch? This
is unrelated to first two changes albeit might make sense.

/Jarkko
