From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] add TPM2 version of
 create_tpm2_key and libtpm2.so engine
Date: Wed, 4 Jan 2017 14:25:15 +0200
Message-ID: <20170104122515.edspvhd464aluriz@intel.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170103234053.GA32185@obsidianresearch.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, ibmtpm20tss-users@lists.sourceforge.net, openssl-dev@openssl.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 04:40:53PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2017 at 03:22:56PM -0800, James Bottomley wrote:
> > > I think it is very important to natively support the sign-only key
> > > usage restriction. TPM1.2 goes so far as to declare keys that can be
> > > used for arbitary decrypt as 'legacy do not use'.
> > > 
> > > IMHO the best way to do this is to look at the sign operation openssl
> > > is trying to do and see if it can be sent down the sign path to the
> > > TPM. Only if that fails should the decrypt path be used.
> > 
> > The problem is the MD5-SHA1 signature of SSL and TLS < v1.2.   This
> > cannot be performed by the TPM because it's not listed as a supported
> > signature, so the choice is either to deprecate these protocols (not
> > really viable since they're in wide use in old websites) or use decrypt
> > to do the signatures.  Once we get to the point of having to use
> > decrypt, there's no reason to preserve the signing distinction since we
> > never know when a key will be used to decrypt or sign.
> 
> I'm not disputing your analysis, just remarking that it seem very
> undesirable to ban *all* sign-only keys just to support a single
> legacy SSL configuration.

Could this configuration just marked as unsupported, or not?

> This is why I suggest looking at the sign being requested and using
> the sign path if it is *possible*, otherwise requiring a key with the
> broader key usage.
> 
> Not everything is SSL - openssh uses these routines too and it should
> be able to use the sign only key type without a limitation?
> 
> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
