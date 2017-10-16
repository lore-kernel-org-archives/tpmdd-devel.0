From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Mon, 16 Oct 2017 14:49:46 +0300
Message-ID: <20171016114946.phj3n6vyjdbpj2sj@linux.intel.com>
References: <20170920081340.7413-5-tweek@google.com>
 <20170926114538.r5hsyc5osodpaals@linux.intel.com>
 <CA+zpnLcYWcO8Gf6b8rAHgcLkAndC0uyPH+Kxa01giVsochP3Ug@mail.gmail.com>
 <20170929171617.yq4dvn66czvnebns@linux.intel.com>
 <20171004105113.mcho3rlytaxfruyf@linux.intel.com>
 <CA+zpnLdg4km1vMUUZaYfRg6M68+nSdC+vASULmH-aKu4vYyy4Q@mail.gmail.com>
 <20171010141419.e4uv4fkmcmpc7sdc@linux.intel.com>
 <alpine.LRH.2.21.1710111250260.22885@namei.org>
 <20171011115254.2n4zs77ixyl2mdgm@linux.intel.com>
 <20171016112833.txbg2sm5tjocp6qh@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171016112833.txbg2sm5tjocp6qh@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>
Cc: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, peterhuewe@gmx.de, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd@selhorst.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 16, 2017 at 02:28:33PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 11, 2017 at 02:52:54PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 11, 2017 at 12:54:26PM +1100, James Morris wrote:
> > > On Tue, 10 Oct 2017, Jarkko Sakkinen wrote:
> > > 
> > > > The way I've agreed with James Morris to have my tree is to be rooted to
> > > > security trees next branch.
> > > > 
> > > > James, what actions should we take?
> > > 
> > > This process has changed recently -- I posted to lsm but forgot to post to 
> > > linux-integrity.
> > > 
> > > http://kernsec.org/pipermail/linux-security-module-archive/2017-September/003356.html
> > > 
> > > Summary: please track the next-general branch in my tree for your 
> > > development, it replaces 'next'.
> > > 
> > > 
> > > - James
> > > -- 
> > > James Morris
> > > <jmorris@namei.org>
> > 
> > Ah I'm subscribed to that list but lately been busy getting a huge patch
> > set to platform-driver-x86 [1] for review, which has prioritized out
> > reading much else than linux-integrity.
> > 
> > Thank you. I'll retry the patches tomorrow.
> > 
> > /Jarkko
> 
> Cannot observer binary_bios_measuremens file.
> 
> What kind of hardware was used to develop/test this?
> 
> I tried it with Kabylake and PTT (firmware TPM).
> 
> /Jarkko

My guess would be wrong event log format.

At minimum this patch set should add a klog (info level) message to tell
that unsupported event log format is being used.

/Jarkko
