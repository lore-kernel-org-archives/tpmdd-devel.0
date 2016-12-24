From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Proposal for the ASN.1 form of TPM1.2 and TPM2
 keys
Date: Sat, 24 Dec 2016 14:25:00 +0100
Message-ID: <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <gnutls-devel-bounces@lists.gnutls.org>
In-Reply-To: <1482516363.2501.34.camel@HansenPartnership.com>
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

On Fri, Dec 23, 2016 at 7:06 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> The reason this comes about is because we already have a standard form
> for TPM 1.2 keys here:
> http://david.woodhou.se/draft-woodhouse-cert-best-practice.html#ident-tpm
> However, since I'm working on TPM2 enabling for openssl and gnutls, I
> need to come up with a new key format because TPM2 requires some extra
> parameters and the original TSS KEY BLOB, being a single
> ASN1_OCTET_STRING isn't expandable.
[...]
> I'm torn on where to get the OIDs from.  Since this is a TPM key, it
> might make sense to use the TCG OID (2.23.133) and just add something
> they haven't already used, like 10 for key formats, or we could go with
> a pkcs OID (1.2.840.113549.1)

OIDs under some umbrella normally need to be registered within the
organization they belong to. If you cannot find a suitable
organization to get these OIDs from I'll check whether we can get
something under redhat's OIDs.

> If we can agree on this, we can update David's document and make it a
> formal RFC.

Shouldn't version be first? However, I'm not sure how expandable is
ASN.1 using version fields (I've seen no structure being able to be
re-used using a different version). An alternative approach would to
allow for future extensions, i.e., something like the PKIX Extension
field, which is an OID+data.

regards,
Nikos
