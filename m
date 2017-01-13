From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH v4] tpm: Check size of response before
 accessing data
Date: Fri, 13 Jan 2017 10:19:50 -0700
Message-ID: <20170113171950.GB30551@obsidianresearch.com>
References: <1484270351-16878-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484270351-16878-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 08:19:11PM -0500, Stefan Berger wrote:
> Make sure that we have not received less bytes than what is indicated
> in the header of the TPM response. Also, check the number of bytes in
> the response before accessing its data.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
