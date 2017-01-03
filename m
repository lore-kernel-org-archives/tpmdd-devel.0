From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 1/1] add TPM2 version of create_tpm2_key
 and libtpm2.so engine
Date: Tue, 3 Jan 2017 15:19:11 -0800
Message-ID: <20170103231911.GA85198@apronin>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170103231126.GE29656-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ibmtpm20tss-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, openssl-dev-MCmKBN63+BlAfugRpC6u6w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 04:11:26PM -0700, Jason Gunthorpe wrote:
> On Sat, Dec 31, 2016 at 02:52:43PM -0800, James Bottomley wrote:
> > This patch adds RSA signing for TPM2 keys.  There's a limitation to the
> > way TPM2 does signing: it must recognise the OID for the signature. 
> >  That fails for the MD5-SHA1 signatures of the TLS/SSL certificate
> > verification protocol, so I'm using RSA_Decrypt for both signing
> > (encryption) and decryption ... meaning that this only works with TPM
> > decryption keys.  It is possible to use the prior code, which preserved
> > the distinction of signing and decryption keys, but only at the expense
> > of not being able to support SSL or TLS lower than 1.2
> 
> [Note, I haven't looked closely at TPM2, but TPM1.2 has a concept of
>  key usage, and I assume that is carried over in the below comments]
> 
> I think it is very important to natively support the sign-only key
> usage restriction. TPM1.2 goes so far as to declare keys that can be
> used for arbitary decrypt as 'legacy do not use'.
> 
> IMHO the best way to do this is to look at the sign operation openssl
> is trying to do and see if it can be sent down the sign path to the
> TPM. Only if that fails should the decrypt path be used.
> 
> For TPM1.2 you could create a sign-only key with the
> TPM_SS_RSASSAPKCS1v15_DER mode and feed it arbitary NIDs - the TPM did
> not check the data to sign, AFAIK.

Unfortunately, it does check the data and even more than that. First,
it checks that the size of the passed data matches the size of the
digest of the specified hashing algorithm. And then it constructs the
DigestInfo with that algorithm ID on its side. So, yes, you have to use
a raw Decrypt to support cases like SHA1+MD5.

> 
> Ideally the user should be able to setup a sign-only key and the
> correct SSL negotiation parameters and have a working system, eg a
> sign-only key used with TLS 1.3 and ephemeral keyx should work.
> 
> > +	/* this is slightly paradoxical that we're doing a Decrypt
> > +	 * operation: the only material difference between decrypt and
> > +	 * encrypt is where the padding is applied or checked, so if
> > +	 * you apply your own padding up to the RSA block size and use
> > +	 * TPM_ALG_NULL, which means no padding check, a decrypt
> > +	 * operation effectively becomes an encrypt */
> 
> IIRC this duality is exactly why key usage exists, and why good crypto
> practice has been to forbid decrypt/encrypt on the same key.
> 
> Jason
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most 
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
