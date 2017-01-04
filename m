From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [TrouSerS-tech] [PATCH 1/1] add TPM2 version of
 create_tpm2_key and libtpm2.so engine
Date: Tue, 03 Jan 2017 16:17:06 -0800
Message-ID: <1483489026.2464.76.camel@HansenPartnership.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170103234053.GA32185-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ibmtpm20tss-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, openssl-dev-MCmKBN63+BlAfugRpC6u6w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-03 at 16:40 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2017 at 03:22:56PM -0800, James Bottomley wrote:
> > > I think it is very important to natively support the sign-only 
> > > key usage restriction. TPM1.2 goes so far as to declare keys that 
> > > can be used for arbitary decrypt as 'legacy do not use'.
> > > 
> > > IMHO the best way to do this is to look at the sign operation 
> > > openssl is trying to do and see if it can be sent down the sign 
> > > path to the TPM. Only if that fails should the decrypt path be
> > > used.
> > 
> > The problem is the MD5-SHA1 signature of SSL and TLS < v1.2.   This
> > cannot be performed by the TPM because it's not listed as a 
> > supported signature, so the choice is either to deprecate these 
> > protocols (not really viable since they're in wide use in old 
> > websites) or use decrypt to do the signatures.  Once we get to the 
> > point of having to use decrypt, there's no reason to preserve the 
> > signing distinction since we never know when a key will be used to
> > decrypt or sign.
> 
> I'm not disputing your analysis, just remarking that it seem very
> undesirable to ban *all* sign-only keys just to support a single
> legacy SSL configuration.

It's not just a single situation.  MD5-SHA1 is where it will fall apart
on backwards compatibility but my current TPM doesn't understand
anything other than sha1 or sha256, so it wouldn't allow more state of
the art algorithms like sha224, sha384 or sha512 either.

> This is why I suggest looking at the sign being requested and using
> the sign path if it is *possible*, otherwise requiring a key with the
> broader key usage.

It's a trade off: the user configuration nightmare: how does an
ordinary user know what type of TPM key they need ... they'll need to
know what their TPM is capable of and what signatures they're likely to
need.  VS the benefits of having single use keys.

I'm just not sure I see enough benefits to trying to preserve the
decrypt vs sign distinction, whereas I do see the floods of complaints
from users who got it wrong or think it should work as advertised.

> Not everything is SSL - openssh uses these routines too and it should
> be able to use the sign only key type without a limitation?

Agreed that openssh only has forward compatibility problems, but it
still has them thanks to the newer algorithm problem.

Actually, the next problem would be gnome-keyring.  It does openssl
signatures and fishing the algorithm type out by the time 

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
