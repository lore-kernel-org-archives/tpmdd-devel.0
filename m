From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] char: tpm: fix potential null pointer dereference
Date: Tue, 30 May 2017 17:40:27 -0500
Message-ID: <20170530174027.Horde.AYiQnLwlE09KhkcqzdNaVTk@gator4166.hostgator.com>
References: <20170530220520.GA8713@embeddedgus>
 <20170530222119.GA8643@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170530222119.GA8643@obsidianresearch.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

Quoting Jason Gunthorpe <jgunthorpe@obsidianresearch.com>:

> On Tue, May 30, 2017 at 05:05:20PM -0500, Gustavo A. R. Silva wrote:
>> NULL check at line 376: if (!chip) {, implies chip might be NULL.
>> Function dev_get_drvdata() dereference pointer chip.
>> Move pointer tmp_dev assignment after the NULL check.
>
> chip cannot be null in st33zp24_send, please remove the bogus if
> instead.
>

I get it.

Thanks for clarifying.
--
Gustavo A. R. Silva
