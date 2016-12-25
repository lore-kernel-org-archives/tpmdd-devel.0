From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [gnutls-devel] Proposal for the ASN.1 form of
 TPM1.2 and TPM2 keys
Date: Sun, 25 Dec 2016 15:47:32 -0800
Message-ID: <1482709652.3394.15.camel@HansenPartnership.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
 <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
 <1482596030.2316.4.camel@HansenPartnership.com>
 <CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
 <1482691491.3394.8.camel@HansenPartnership.com>
 <CAJU7zaL2WGnBgCnx_EQ7wNnaYpaUK8BfbX40Gm85zamnFYfhgA@mail.gmail.com>
Reply-To: openssl-dev@openssl.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <openssl-dev-bounces@openssl.org>
In-Reply-To: <CAJU7zaL2WGnBgCnx_EQ7wNnaYpaUK8BfbX40Gm85zamnFYfhgA@mail.gmail.com>
List-Unsubscribe: <https://mta.openssl.org/mailman/options/openssl-dev>,
 <mailto:openssl-dev-request@openssl.org?subject=unsubscribe>
List-Archive: <http://mta.openssl.org/pipermail/openssl-dev/>
List-Post: <mailto:openssl-dev@openssl.org>
List-Help: <mailto:openssl-dev-request@openssl.org?subject=help>
List-Subscribe: <https://mta.openssl.org/mailman/listinfo/openssl-dev>,
 <mailto:openssl-dev-request@openssl.org?subject=subscribe>
Errors-To: openssl-dev-bounces@openssl.org
Sender: "openssl-dev" <openssl-dev-bounces@openssl.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>, openssl-dev@openssl.org, GnuTLS development list <gnutls-devel@lists.gnutls.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, 2016-12-25 at 22:08 +0100, Nikos Mavrogiannopoulos wrote:
> On Sun, Dec 25, 2016 at 7:44 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > > TPMKey ::= SEQUENCE {
> > >         type            OBJECT IDENTIFIER
> > >         version         [0] IMPLICIT INTEGER OPTIONAL
> > >         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
> > >         parent          [2] IMPLICIT INTEGER OPTIONAL
> > >         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
> > >         privateKey      OCTET STRING
> > >          extensions      [4]  EXPLICIT Extensions OPTIONAL
> > > }
> > 
> > Actually, that's the utility of ASN.1, once you use tagging, you 
> > don't have to do this.  The structure above is identical to:
> > 
> > TPMKey ::= SEQUENCE {
> >         type            OBJECT IDENTIFIER
> >         version         [0] IMPLICIT INTEGER OPTIONAL
> >         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
> >         parent          [2] IMPLICIT INTEGER OPTIONAL
> >         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
> >         privateKey      OCTET STRING
> >  }
> > 
> > If tag 4 isn't present because optional tags are not coded when not
> > present, so you can expand any ASN.1 structure as long as you have 
> > a clue from the version number that you should be looking for the
> > optional extras.  The point being I don't have to specify the 
> > expansion now, I can wait until we need it.
> 
> How would that work for example if you want to add an additional 
> field with information on the type of the key for example (key 
> usage)? You would add the tag 4 as you say, and then all the previous 
> parsers written with the initial description will fail parsing the 
> new structure. X.509 (==PKIX) is only expandable via the extensions 
> field which is already defined. If you add a field to it, no parser 
> would be able to read the certificate.

Um, well, you only want backwards compatibility, you don't really want
forward compatibility.  Assuming something extends the structure and
adds version v2, why would it matter that an old v1 application can't
read a v2 structure because it doesn't understand the tag 4?  Even if
it could it can't make use of the extra fields and something nasty will
happen.  What you want is that the new v2 application can parse both
the v2 structure and the old v1 one, but it's advantageous that a v1
application fails with a v2 structure because it prevents cockups.

James

-- 
openssl-dev mailing list
To unsubscribe: https://mta.openssl.org/mailman/listinfo/openssl-dev
