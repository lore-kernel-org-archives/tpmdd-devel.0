From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [TrouSerS-tech] [PATCH 1/1] add TPM2 version of
 create_tpm2_key and libtpm2.so engine
Date: Tue, 3 Jan 2017 17:42:17 -0700
Message-ID: <20170104004217.GA390@obsidianresearch.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
	<1483489026.2464.76.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483489026.2464.76.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ibmtpm20tss-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, openssl-dev-MCmKBN63+BlAfugRpC6u6w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 04:17:06PM -0800, James Bottomley wrote:
> On Tue, 2017-01-03 at 16:40 -0700, Jason Gunthorpe wrote:

> > I'm not disputing your analysis, just remarking that it seem very
> > undesirable to ban *all* sign-only keys just to support a single
> > legacy SSL configuration.
> 
> It's not just a single situation.  MD5-SHA1 is where it will fall apart
> on backwards compatibility but my current TPM doesn't understand
> anything other than sha1 or sha256, so it wouldn't allow more state of
> the art algorithms like sha224, sha384 or sha512 either.

Okay, yes, that is horrible :( If it is that bad it might not be worth
the effort..

> I'm just not sure I see enough benefits to trying to preserve the
> decrypt vs sign distinction, whereas I do see the floods of complaints
> from users who got it wrong or think it should work as advertised.

I probably wouldn't change the process for key generation - make the
tools default to decrypt keys and have an advanced option for
sign-only.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
