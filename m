From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: use get_unaligned_be32 unaligned
	buffer access.
Date: Wed, 23 Nov 2016 14:01:39 -0700
Message-ID: <20161123210138.GB15803@obsidianresearch.com>
References: <1479899094-9486-1-git-send-email-tomas.winkler@intel.com>
	<20161123165734.GA2763@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B543308CB@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B543308CB-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 23, 2016 at 08:56:25PM +0000, Winkler, Tomas wrote:
> > On Wed, Nov 23, 2016 at 01:04:54PM +0200, Tomas Winkler wrote:
> > > Use get_unaligned_be32 as b32_to_cpu doesn't work correctly on all
> > > platforms for unaligned access.
> > >
> > > The fix doesn't cover all the cases as also some cast structures have
> > > members on unaligned addresses.
> > 
> > I think this is a good idea..
> > 
> > > @@ -353,8 +353,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8
> > *buf, size_t bufsiz,
> > >  	if (bufsiz > TPM_BUFSIZE)
> > >  		bufsiz = TPM_BUFSIZE;
> > >
> > > -	count = be32_to_cpu(*((__be32 *) (buf + 2)));
> > > -	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > > +	count = get_unaligned_be32(buf + 2);
> > > +	ordinal = get_unaligned_be32(buf + 6);
> >
> > But lets fix this better and get rid of the constants too...
> 
> >  const tpm_input_header *hdr = buf;
> >  count = be32_to_cpu(hdr->length);
> >  ordinal = be32_to_cpu(hdr->ordinal);
> > 
> > Compiler will take care of unaligned for __packed.
> 
> Yes, compiler takes care at performance penalty but probably we
> don't care about that much,

Hmm? get_unaligned_be32 boils down to the same __packed construct.

As is today we must be hitting the in-kernel unaligned access trap (eg
on ARM) which is *very* expensive so this is a very worthwhile fix ...

Jason

------------------------------------------------------------------------------
