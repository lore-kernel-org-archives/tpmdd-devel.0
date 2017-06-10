From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
Date: Sat, 10 Jun 2017 14:06:56 +0300
Message-ID: <20170610110656.hucthdwxfv3s6zz2@intel.com>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
 <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
 <20170607224444.5043f545@lxorguk.ukuu.org.uk>
 <5FFFAD06ADE1CA4381B3F0F7C6AF5828910C7B@ORSMSX109.amr.corp.intel.com>
 <20170608192259.43150ffa@lxorguk.ukuu.org.uk>
 <20170608183920.GA7984@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170608183920.GA7984@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Shaikh, Azhar" <azhar.shaikh@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 08, 2017 at 12:39:20PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 08, 2017 at 07:22:59PM +0100, Alan Cox wrote:
> > > > > +	outb(0x80, 0xCC);
> > > > > +
> > > > > +	/* Make sure the above write is completed */
> > > > > +	wmb();  
> > > > 
> > > > Why the wmb(). It doesn't do what the comment says! Also this code is x86
> > > > specific
> > > > 
> > > >   
> > > 
> > > Memory barrier to enforce the order so that the outb() is
> > > completed, which ensures that the LPC clocks are running before
> > > sending any TPM command.
> >
> > wmb() doesn't do that. It merely ensures that the write has been posted
> > to the fabric. If as I suspect your LPC bus implements outb() as a
> > non-posted write you don't need the wmb().
> 
> I think the point here is to bootstrap the sleeping LPC bus clock
> before a TPM command is issued, presumably because the auto-wakeup circuit
> is busted or something.
> 
> For that purpose all that should be required is strong ordering of the
> outb relative to the other TPM commands at the LPC interface FIFO. I
> also think the wmb is not needed because outb is already defined to be
> strongly in order with respect to writel/readl ?
> 
> Jason

writel AFAIK guarantees by itself strong RW ordering.

/Jarkko
