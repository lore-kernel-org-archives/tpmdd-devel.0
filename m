From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [openssl-dev] Proposal for the ASN.1 form of
 TPM1.2 and TPM2 keys
Date: Fri, 23 Dec 2016 12:22:35 -0800
Message-ID: <1482524555.2501.59.camel@HansenPartnership.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
	<20161223.211218.817856866219152234.levitte@openssl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161223.211218.817856866219152234.levitte-MCmKBN63+BlAfugRpC6u6w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Richard Levitte <levitte-MCmKBN63+BlAfugRpC6u6w@public.gmane.org>, openssl-dev-MCmKBN63+BlAfugRpC6u6w@public.gmane.org
Cc: trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gnutls-devel-f8S/fY/i+OXSWulAQ3bEYg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2016-12-23 at 21:12 +0100, Richard Levitte wrote:
> In message <1482516363.2501.34.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> on Fri,
> 23 Dec 2016 10:06:03 -0800, James Bottomley <
> James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> said:
> 
> James.Bottomley> The reason this comes about is because we already
> have a standard form
> James.Bottomley> for TPM 1.2 keys here:
> James.Bottomley> 
> James.Bottomley> http://david.woodhou.se/draft-woodhouse-cert-best-pr
> actice.html#ident-tpm
> James.Bottomley> 
> James.Bottomley> However, since I'm working on TPM2 enabling for
> openssl and gnutls, I
> James.Bottomley> need to come up with a new key format because TPM2
> requires some extra
> James.Bottomley> parameters and the original TSS KEY BLOB, being a
> single
> James.Bottomley> ASN1_OCTET_STRING isn't expandable.
> James.Bottomley> 
> James.Bottomley> As a digression, the extra parameters that TPM2
> needs are:
> James.Bottomley> 
> James.Bottomley>    1. A public key blob.  In TPM12 the key complex
> was a joint
> James.Bottomley>       public/private part.  In TPM2, the public and
> private key structures
> James.Bottomley>       have variable length and are supplied
> separately.
> James.Bottomley>    2. a boolean for emptyAuth.  In TPM12 there's a
> way to tell if a
> James.Bottomley>       structure has no authorization.  In TPM2
> there's no such thing as no
> James.Bottomley>       authorization, but there's a conventional
> empty authorization to
> James.Bottomley>       replace it but no way of querying whether any
> given key is using it,
> James.Bottomley>       so we need to know explicitly whether to
> prompt for a password or
> James.Bottomley>       not.
> James.Bottomley>    3. There are different forms a TPM private key
> could be in.  One is
> James.Bottomley>       symmetrically encrypted with a TPM private
> key, which makes it
> James.Bottomley>       loadable, meaning it must be produced on the
> TPM itself and the
> James.Bottomley>       other is asymmetrically encrypted meaning it
> can be produced away
> James.Bottomley>       from the TPM but must be imported before being
> loaded.
> James.Bottomley> 
> James.Bottomley> I think there's value in having a universal
> structure for the key
> James.Bottomley> representations, so I'm proposing an ASN1
> representation that will work
> James.Bottomley> for both TPM1.2 and TPM2 keys.  I'd also like it to
> be self describing,
> James.Bottomley> so I think we should use an OID as the initial
> parameter of the
> James.Bottomley> sequence.  With that, I think the format that works
> is
> James.Bottomley> 
> James.Bottomley> TPMKey ::= SEQUENCE {
> James.Bottomley>        type            OBJECT IDENTIFIER
> James.Bottomley>        version         [0] IMPLICIT INTEGER OPTIONAL
> James.Bottomley>        emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
> James.Bottomley>        parent          [2] IMPLICIT INTEGER OPTIONAL
> James.Bottomley>        publicKey       [3] IMPLICIT OCTET STRING
> OPTIONAL
> James.Bottomley>        privateKey      OCTET STRING
> James.Bottomley> }
> James.Bottomley> 
> James.Bottomley> Where TPM12 keys would have a TPM12Key type and use
> no optional fields
> James.Bottomley> (meaning only privateKey) and TPM2 keys would have
> type TPM2LoadableKey
> James.Bottomley> or TPM2ImportableKey type and then make use of all
> the optional fields
> James.Bottomley> (except version).
> James.Bottomley> 
> James.Bottomley> Version is there for future expansion, but is unused
> in the initial
> James.Bottomley> incarnation.
> James.Bottomley> 
> James.Bottomley> I'm torn on where to get the OIDs from.  Since this
> is a TPM key, it
> James.Bottomley> might make sense to use the TCG OID (2.23.133) and
> just add something
> James.Bottomley> they haven't already used, like 10 for key formats,
> or we could go with
> James.Bottomley> a pkcs OID (1.2.840.113549.1)
> James.Bottomley> 
> James.Bottomley> If we can agree on this, we can update David's
> document and make it a
> James.Bottomley> formal RFC.
> James.Bottomley> 
> James.Bottomley> Thoughts?
> 
> First reaction is +1, at least for actually making a universally
> parsable description.

Thanks.  After playing more I think I'd like to make the tags explicit
rather than implicit so I can see the contents easily with asn1parse
(and we're not in any way pressed for space, which is the usual reason
for implicit tags).

> One detail that escapes me, though, is why you don't use version for,
> well, TPM versions?  So, something like this?
> 
> TCG OBJECT IDENTIFIER ::=
>         { joint-iso-itu-t(2) international-organizations(23) TCG(133)
>   }

Because what OID to use is part of the discussion.  Perhaps I wasn't
clear about what I want: the OID needs to identify what the structure
describes, so one OID for each of the three key types, so it would have
a prefix either in the TCG or pkcs space (or something else if that's
what we agree), then three OID postfixes.

> TPMKey ::= SEQUENCE {
>        type        OBJECT IDENTIFIER    -- always TCG
>        version     [0] INTEGER { v1_2(0), v2(1) } DEFAULT v1_2

Version, I'm envisaging is for expansion of the structure in a
compatible way.  For TPM2 keys, I think we're going to need additional
policy descriptors eventually when people start using a policy to
authorise instead of an authorisation value.  We'd use the version
number to indicate a future expanded structure.

So the OID identifies the object structure and version is for
versioning the actual structure.

James

>        emptyAuth   [1] IMPLICIT BOOLEAN OPTIONAL        -- v2 only
>        parent      [2] IMPLICIT INTEGER OPTIONAL        -- v2 only
>        publicKey   [3] IMPLICIT OCTET STRING OPTIONAL   -- v2 only
>        privateKey  OCTET STRING
> }
> 
> Cheers,
> Richard
> 
> -- 
> Richard Levitte         levitte-MCmKBN63+BlAfugRpC6u6w@public.gmane.org
> OpenSSL Project         http://www.openssl.org/~levitte/
> 


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
