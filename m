From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
Date: Thu, 8 Jun 2017 19:50:05 +0100
Message-ID: <20170608195005.6edc9242@lxorguk.ukuu.org.uk>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
        <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
        <20170607224444.5043f545@lxorguk.ukuu.org.uk>
        <5FFFAD06ADE1CA4381B3F0F7C6AF5828910C7B@ORSMSX109.amr.corp.intel.com>
        <20170608192259.43150ffa@lxorguk.ukuu.org.uk>
        <20170608183920.GA7984@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170608183920.GA7984@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Shaikh, Azhar" <azhar.shaikh@intel.com>, "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> For that purpose all that should be required is strong ordering of the
> outb relative to the other TPM commands at the LPC interface FIFO. I
> also think the wmb is not needed because outb is already defined to be
> strongly in order with respect to writel/readl ?

That's my assumption but given this is all some kind of 'it's broken'
fixup I thought best to ask. Assuming there is nothing else magical going
on then yes it should be deleted.

Alan
