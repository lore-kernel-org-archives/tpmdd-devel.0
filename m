From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Proposal for the ASN.1 form of TPM1.2 and TPM2
 keys
Date: Sun, 25 Dec 2016 22:08:44 +0100
Message-ID: <CAJU7zaL2WGnBgCnx_EQ7wNnaYpaUK8BfbX40Gm85zamnFYfhgA@mail.gmail.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
 <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
 <1482596030.2316.4.camel@HansenPartnership.com>
 <CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
 <1482691491.3394.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <gnutls-devel-bounces@lists.gnutls.org>
In-Reply-To: <1482691491.3394.8.camel@HansenPartnership.com>
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

On Sun, Dec 25, 2016 at 7:44 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> TPMKey ::= SEQUENCE {
>>         type            OBJECT IDENTIFIER
>>         version         [0] IMPLICIT INTEGER OPTIONAL
>>         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
>>         parent          [2] IMPLICIT INTEGER OPTIONAL
>>         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
>>         privateKey      OCTET STRING
>>          extensions      [4]  EXPLICIT Extensions OPTIONAL
>> }
>
> Actually, that's the utility of ASN.1, once you use tagging, you don't
> have to do this.  The structure above is identical to:
>
> TPMKey ::= SEQUENCE {
>         type            OBJECT IDENTIFIER
>         version         [0] IMPLICIT INTEGER OPTIONAL
>         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
>         parent          [2] IMPLICIT INTEGER OPTIONAL
>         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
>         privateKey      OCTET STRING
>  }
>
> If tag 4 isn't present because optional tags are not coded when not
> present, so you can expand any ASN.1 structure as long as you have a
> clue from the version number that you should be looking for the
> optional extras.  The point being I don't have to specify the expansion
> now, I can wait until we need it.

How would that work for example if you want to add an additional field
with information on the type of the key for example (key usage)? You
would add the tag 4 as you say, and then all the previous parsers
written with the initial description will fail parsing the new
structure. X.509 (==PKIX) is only expandable via the extensions field
which is already defined. If you add a field to it, no parser would be
able to read the certificate.

regards,
Nikos
