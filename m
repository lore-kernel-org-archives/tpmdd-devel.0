From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before
 ExitBootServices
Date: Wed, 11 Oct 2017 14:53:18 +0300
Message-ID: <20171011115318.i342rzq3akqbrovv@linux.intel.com>
References: <20170920081340.7413-1-tweek@google.com>
 <20170920081340.7413-5-tweek@google.com>
 <20170926114538.r5hsyc5osodpaals@linux.intel.com>
 <CA+zpnLcYWcO8Gf6b8rAHgcLkAndC0uyPH+Kxa01giVsochP3Ug@mail.gmail.com>
 <20170929171617.yq4dvn66czvnebns@linux.intel.com>
 <20171004105113.mcho3rlytaxfruyf@linux.intel.com>
 <CA+zpnLdg4km1vMUUZaYfRg6M68+nSdC+vASULmH-aKu4vYyy4Q@mail.gmail.com>
 <20171010141419.e4uv4fkmcmpc7sdc@linux.intel.com>
 <alpine.LRH.2.21.1710111250260.22885@namei.org>
 <20171011115254.2n4zs77ixyl2mdgm@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171011115254.2n4zs77ixyl2mdgm-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 11, 2017 at 02:52:54PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 11, 2017 at 12:54:26PM +1100, James Morris wrote:
> > On Tue, 10 Oct 2017, Jarkko Sakkinen wrote:
> > 
> > > The way I've agreed with James Morris to have my tree is to be rooted to
> > > security trees next branch.
> > > 
> > > James, what actions should we take?
> > 
> > This process has changed recently -- I posted to lsm but forgot to post to 
> > linux-integrity.
> > 
> > http://kernsec.org/pipermail/linux-security-module-archive/2017-September/003356.html
> > 
> > Summary: please track the next-general branch in my tree for your 
> > development, it replaces 'next'.
> > 
> > 
> > - James
> > -- 
> > James Morris
> > <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
> 
> Ah I'm subscribed to that list but lately been busy getting a huge patch
> set to platform-driver-x86 [1] for review, which has prioritized out
> reading much else than linux-integrity.
> 
> Thank you. I'll retry the patches tomorrow.
> 
> /Jarkko

[1] http://www.spinics.net/lists/platform-driver-x86/msg13260.html

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
