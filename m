From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Mon, 16 Oct 2017 14:34:00 +0300
Message-ID: <20171016113400.y3lbutd5dtbp76ld@linux.intel.com>
References: <20170929171617.yq4dvn66czvnebns@linux.intel.com>
 <20171004105113.mcho3rlytaxfruyf@linux.intel.com>
 <CA+zpnLdg4km1vMUUZaYfRg6M68+nSdC+vASULmH-aKu4vYyy4Q@mail.gmail.com>
 <20171010141419.e4uv4fkmcmpc7sdc@linux.intel.com>
 <alpine.LRH.2.21.1710111250260.22885@namei.org>
 <20171011115254.2n4zs77ixyl2mdgm@linux.intel.com>
 <20171011115318.i342rzq3akqbrovv@linux.intel.com>
 <20171012113844.ptfynppgx3tkwe7g@linux.intel.com>
 <CABxcv=neJZjA407pbmNesNbGY9k3VRbhawut6ewofw_UB5U1_w@mail.gmail.com>
 <20171013194746.ulomwhd6czoeks5m@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171013194746.ulomwhd6czoeks5m@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: James Morris <jmorris@namei.org>, Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>, peterhuewe@gmx.de, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd@selhorst.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 13, 2017 at 10:47:46PM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 12, 2017 at 05:03:38PM +0200, Javier Martinez Canillas wrote:
> > On Thu, Oct 12, 2017 at 1:38 PM, Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > 
> > [snip]
> > 
> > >
> > > Now all Thiebaud's patches have been applied to the master of
> > >
> > >   git://git.infradead.org/users/jjs/linux-tpmdd.git
> > >
> > > Testing is still pending.
> > >
> > 
> > I provided my reviewed and tested by tags for the patches but I
> > noticed that weren't picked. Probably my fault though since I answered
> > to the cover letter instead of the individual patches.
> > 
> > > /Jarkko
> > 
> > Best regards,
> > Javier
> 
> I will add it. The master branch is bleeding edge where tags might be
> sometimes (*not* usually) missing. The next branch is the one that goes
> to linux-next.
> 
> I'll check all tags from patchwork before moving any of these to next.
> 
> /Jarkko

Updated.

/Jarkko
