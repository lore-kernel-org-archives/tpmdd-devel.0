From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Proposal for the ASN.1 form of TPM1.2 and TPM2
 keys
Date: Sun, 25 Dec 2016 10:18:29 +0100
Message-ID: <CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
 <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
 <1482596030.2316.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <gnutls-devel-bounces@lists.gnutls.org>
In-Reply-To: <1482596030.2316.4.camel@HansenPartnership.com>
List-Unsubscribe: <http://lists.gnupg.org/mailman/options/gnutls-devel>,
 <mailto:gnutls-devel-request@lists.gnutls.org?subject=unsubscribe>
List-Archive: </pipermail/>
List-Post: <mailto:gnutls-devel@lists.gnutls.org>
List-Help: <mailto:gnutls-devel-request@lists.gnutls.org?subject=help>
List-Subscribe: <http://lists.gnupg.org/mailman/listinfo/gnutls-devel>,
 <mailto:gnutls-devel-request@lists.gnutls.org?subject=subscribe>
Errors-To: gnutls-devel-bounces@lists.gnutls.org
Sender: "Gnutls-devel" <gnutls-devel-bounces@lists.gnutls.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>, openssl-dev@openssl.org, GnuTLS development list <gnutls-devel@lists.gnutls.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Dec 24, 2016 at 5:13 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> I think, since it's a key format, the two above are the potential ones.
>  It would be TCG if they want to take it into their standard, otherwise
> PKCS is RSA Inc.

I wouldn't expect RSA inc to be involved into this as part of PKCS.
They are dead long time ago and have moved to IETF.

>>  However, I'm not sure how expandable is ASN.1 using version fields
>> (I've seen no structure being able to be re-used using a different
>> version). An alternative approach would to allow for future
>> extensions, i.e., something like the PKIX Extension field, which is
>> an OID+data.
>
> As long as the expansion fields are optional, it works nicely.  X509
> and X509v3 are examples of version expanded ASN.1

Only if they are defined in the structure early. Otherwise the early
versions of the implementations wouldn't cope with extensions. To make
it early extendable you'd have to use something lilke
TPMKey ::= SEQUENCE {
        type            OBJECT IDENTIFIER
        version         [0] IMPLICIT INTEGER OPTIONAL
        emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
        parent          [2] IMPLICIT INTEGER OPTIONAL
        publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
        privateKey      OCTET STRING
         extensions      [4]  EXPLICIT Extensions OPTIONAL
}

regards,
Nikos
