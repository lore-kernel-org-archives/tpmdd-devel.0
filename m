From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH 01/10] tpm: Check received number of bytes
 against length indicator in header
Date: Tue, 10 Jan 2017 09:15:19 -0700
Message-ID: <20170110161519.GC15493@obsidianresearch.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 10, 2017 at 09:18:11AM -0500, Stefan Berger wrote:
> Make sure that we have not received less bytes than what is indicated
> in the header of the TPM response.

IMHO this entire series should be tagged for stable, can you please
add a Cc: and Fixes:

Thanks,
Jason
