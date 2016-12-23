From: Richard Levitte <levitte@openssl.org>
Subject: Re: Proposal for the ASN.1 form of TPM1.2 and TPM2
 keys
Date: Fri, 23 Dec 2016 21:12:18 +0100 (CET)
Message-ID: <20161223.211218.817856866219152234.levitte@openssl.org>
References: <1482516363.2501.34.camel@HansenPartnership.com>
Reply-To: openssl-dev@openssl.org
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <openssl-dev-bounces@openssl.org>
In-Reply-To: <1482516363.2501.34.camel@HansenPartnership.com>
List-Unsubscribe: <https://mta.openssl.org/mailman/options/openssl-dev>,
 <mailto:openssl-dev-request@openssl.org?subject=unsubscribe>
List-Archive: <http://mta.openssl.org/pipermail/openssl-dev/>
List-Post: <mailto:openssl-dev@openssl.org>
List-Help: <mailto:openssl-dev-request@openssl.org?subject=help>
List-Subscribe: <https://mta.openssl.org/mailman/listinfo/openssl-dev>,
 <mailto:openssl-dev-request@openssl.org?subject=subscribe>
Errors-To: openssl-dev-bounces@openssl.org
Sender: "openssl-dev" <openssl-dev-bounces@openssl.org>
To: openssl-dev@openssl.org, James.Bottomley@HansenPartnership.com
Cc: trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, dwmw2@infradead.org, gnutls-devel@lists.gnutls.org
List-Id: tpmdd-devel@lists.sourceforge.net

In message <1482516363.2501.34.camel@HansenPartnership.com> on Fri, 23 Dec =
2016 10:06:03 -0800, James Bottomley <James.Bottomley@HansenPartnership.com=
> said:

James.Bottomley> The reason this comes about is because we already have a s=
tandard form
James.Bottomley> for TPM 1.2 keys here:
James.Bottomley> =

James.Bottomley> http://david.woodhou.se/draft-woodhouse-cert-best-practice=
.html#ident-tpm
James.Bottomley> =

James.Bottomley> However, since I'm working on TPM2 enabling for openssl an=
d gnutls, I
James.Bottomley> need to come up with a new key format because TPM2 require=
s some extra
James.Bottomley> parameters and the original TSS KEY BLOB, being a single
James.Bottomley> ASN1_OCTET_STRING isn't expandable.
James.Bottomley> =

James.Bottomley> As a digression, the extra parameters that TPM2 needs are:
James.Bottomley> =

James.Bottomley>    1. A public key blob. =A0In TPM12 the key complex was a=
 joint
James.Bottomley>       public/private part. =A0In TPM2, the public and priv=
ate key structures
James.Bottomley>       have variable length and are supplied separately.
James.Bottomley>    2. a boolean for emptyAuth. =A0In TPM12 there's a way t=
o tell if a
James.Bottomley>       structure has no authorization. =A0In TPM2 there's n=
o such thing as no
James.Bottomley>       authorization, but there's a conventional empty auth=
orization to
James.Bottomley>       replace it but no way of querying whether any given =
key is using it,
James.Bottomley>       so we need to know explicitly whether to prompt for =
a password or
James.Bottomley>       not.
James.Bottomley>    3. There are different forms a TPM private key could be=
 in. =A0One is
James.Bottomley>       symmetrically encrypted with a TPM private key, whic=
h makes it
James.Bottomley>       loadable, meaning it must be produced on the TPM its=
elf and the
James.Bottomley>       other is asymmetrically encrypted meaning it can be =
produced away
James.Bottomley>       from the TPM but must be imported before being loade=
d.
James.Bottomley> =

James.Bottomley> I think there's value in having a universal structure for =
the key
James.Bottomley> representations, so I'm proposing an ASN1 representation t=
hat will work
James.Bottomley> for both TPM1.2 and TPM2 keys.  I'd also like it to be sel=
f describing,
James.Bottomley> so I think we should use an OID as the initial parameter o=
f the
James.Bottomley> sequence.  With that, I think the format that works is
James.Bottomley> =

James.Bottomley> TPMKey ::=3D SEQUENCE {
James.Bottomley> 	type		OBJECT IDENTIFIER
James.Bottomley> 	version		[0] IMPLICIT INTEGER OPTIONAL
James.Bottomley> 	emptyAuth	[1] IMPLICIT BOOLEAN OPTIONAL
James.Bottomley> 	parent		[2] IMPLICIT INTEGER OPTIONAL
James.Bottomley> 	publicKey	[3] IMPLICIT OCTET STRING OPTIONAL
James.Bottomley> 	privateKey	OCTET STRING
James.Bottomley> }
James.Bottomley> =

James.Bottomley> Where TPM12 keys would have a TPM12Key type and use no opt=
ional fields
James.Bottomley> (meaning only privateKey) and TPM2 keys would have type TP=
M2LoadableKey
James.Bottomley> or TPM2ImportableKey type and then make use of all the opt=
ional fields
James.Bottomley> (except version).
James.Bottomley> =

James.Bottomley> Version is there for future expansion, but is unused in th=
e initial
James.Bottomley> incarnation.
James.Bottomley> =

James.Bottomley> I'm torn on where to get the OIDs from.  Since this is a T=
PM key, it
James.Bottomley> might make sense to use the TCG OID (2.23.133) and just ad=
d something
James.Bottomley> they haven't already used, like 10 for key formats, or we =
could go with
James.Bottomley> a pkcs OID (1.2.840.113549.1)
James.Bottomley> =

James.Bottomley> If we can agree on this, we can update David's document an=
d make it a
James.Bottomley> formal RFC.
James.Bottomley> =

James.Bottomley> Thoughts?

First reaction is +1, at least for actually making a universally
parsable description.

One detail that escapes me, though, is why you don't use version for,
well, TPM versions?  So, something like this?

TCG OBJECT IDENTIFIER ::=3D
	{ joint-iso-itu-t(2) international-organizations(23) TCG(133)  }

TPMKey ::=3D SEQUENCE {
       type        OBJECT IDENTIFIER	-- always TCG
       version     [0] INTEGER { v1_2(0), v2(1) } DEFAULT v1_2
       emptyAuth   [1] IMPLICIT BOOLEAN OPTIONAL	-- v2 only
       parent      [2] IMPLICIT INTEGER OPTIONAL	-- v2 only
       publicKey   [3] IMPLICIT OCTET STRING OPTIONAL	-- v2 only
       privateKey  OCTET STRING
}

Cheers,
Richard

-- =

Richard Levitte         levitte@openssl.org
OpenSSL Project         http://www.openssl.org/~levitte/
-- =

openssl-dev mailing list
To unsubscribe: https://mta.openssl.org/mailman/listinfo/openssl-dev
