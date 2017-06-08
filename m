From: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Subject: RE: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
Date: Thu, 8 Jun 2017 19:02:54 +0000
Message-ID: <5FFFAD06ADE1CA4381B3F0F7C6AF5828910FA4@ORSMSX109.amr.corp.intel.com>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
        <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
        <20170607224444.5043f545@lxorguk.ukuu.org.uk>
        <5FFFAD06ADE1CA4381B3F0F7C6AF5828910C7B@ORSMSX109.amr.corp.intel.com>
 <20170608192259.43150ffa@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170608192259.43150ffa@lxorguk.ukuu.org.uk>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Alan Cox [mailto:gnomes@lxorguk.ukuu.org.uk]
> Sent: Thursday, June 8, 2017 11:23 AM
> To: Shaikh, Azhar <azhar.shaikh@intel.com>
> Cc: jarkko.sakkinen@linux.intel.com; jgunthorpe@obsidianresearch.com;
> tpmdd-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; linux-
> security-module@vger.kernel.org
> Subject: Re: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
> 
> > > > +	outb(0x80, 0xCC);
> > > > +
> > > > +	/* Make sure the above write is completed */
> > > > +	wmb();
> > >
> > > Why the wmb(). It doesn't do what the comment says! Also this code
> > > is x86 specific
> > >
> > >
> >
> > Memory barrier to enforce the order so that the outb() is completed,
> which ensures that the LPC clocks are running before sending any TPM
> command.
> 
> wmb() doesn't do that. It merely ensures that the write has been posted to
> the fabric. If as I suspect your LPC bus implements outb() as a non-posted
> write you don't need the wmb(). If it doesn't then you need to issue
> whatever access is needed to the fabric to ensure the post completed (eg for
> PCI if you do an MMIO write you must do an MMIO read from the same
> devfn).
> 
> Secondly outb(0x80, 0xCC) doesn't write 0xCC to port 0x80. It writes 0x80 to
> port 0xCC !
> 

Oops my bad! I got that reversed. Will change it.

> Alan
