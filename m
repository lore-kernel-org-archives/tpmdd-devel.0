From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] char: tpm: remove unnecessary NULL check
Date: Mon, 19 Jun 2017 02:35:42 +0200
Message-ID: <1497832542.14670.1.camel@linux.intel.com>
References: <20170613195542.GA5677@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170613195542.GA5677@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-06-13 at 14:55 -0500, Gustavo A. R. Silva wrote:
> Remove unnecessary NULL check.
> Pointer _chip_ cannot be NULL in this instance.
> 
> Addresses-Coverity-ID: 1397646
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
(compilation)

/Jarkko
