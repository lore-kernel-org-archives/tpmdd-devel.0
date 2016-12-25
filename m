From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [gnutls-devel] Proposal for the ASN.1 form of
 TPM1.2 and TPM2 keys
Date: Sun, 25 Dec 2016 10:44:51 -0800
Message-ID: <1482691491.3394.8.camel@HansenPartnership.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
	<CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
	<1482596030.2316.4.camel@HansenPartnership.com>
	<CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
In-Reply-To: <CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, openssl-dev@openssl.org, GnuTLS development list <gnutls-devel@lists.gnutls.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, 2016-12-25 at 10:18 +0100, Nikos Mavrogiannopoulos wrote:
> On Sat, Dec 24, 2016 at 5:13 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> 
> > I think, since it's a key format, the two above are the potential 
> > ones.  It would be TCG if they want to take it into their standard,
> > otherwise PKCS is RSA Inc.
> 
> I wouldn't expect RSA inc to be involved into this as part of PKCS.
> They are dead long time ago and have moved to IETF.

I think I should give TCG first crack at wanting to own the OID.  The
IETF ones are easy: once you codify it in an RFC, the oid registry auto
extracts it.

> > >  However, I'm not sure how expandable is ASN.1 using version
> > > fields (I've seen no structure being able to be re-used using a
> > > different version). An alternative approach would to allow for 
> > > future extensions, i.e., something like the PKIX Extension field, 
> > > which is an OID+data.
> > 
> > As long as the expansion fields are optional, it works nicely. 
> >  X509 and X509v3 are examples of version expanded ASN.1
> 
> Only if they are defined in the structure early. Otherwise the early
> versions of the implementations wouldn't cope with extensions. To 
> make it early extendable you'd have to use something lilke
>  
> TPMKey ::= SEQUENCE {
>         type            OBJECT IDENTIFIER
>         version         [0] IMPLICIT INTEGER OPTIONAL
>         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
>         parent          [2] IMPLICIT INTEGER OPTIONAL
>         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
>         privateKey      OCTET STRING
>          extensions      [4]  EXPLICIT Extensions OPTIONAL
> }

Actually, that's the utility of ASN.1, once you use tagging, you don't
have to do this.  The structure above is identical to:

TPMKey ::= SEQUENCE {
        type            OBJECT IDENTIFIER
        version         [0] IMPLICIT INTEGER OPTIONAL
        emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
        parent          [2] IMPLICIT INTEGER OPTIONAL
        publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
        privateKey      OCTET STRING
 }

If tag 4 isn't present because optional tags are not coded when not
present, so you can expand any ASN.1 structure as long as you have a
clue from the version number that you should be looking for the
optional extras.  The point being I don't have to specify the expansion
now, I can wait until we need it.

I'm pretty certain the next expansion is actually SEQUENCE OF
TPM2Policy but I'm still playing with the format.

James


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
