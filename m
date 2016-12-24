From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [gnutls-devel] Proposal for the ASN.1 form of
 TPM1.2 and TPM2 keys
Date: Sat, 24 Dec 2016 08:13:50 -0800
Message-ID: <1482596030.2316.4.camel@HansenPartnership.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
	<CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nikos Mavrogiannopoulos <nmav-c5N7Ur/I1ocdnm+yROfE0A@public.gmane.org>
Cc: trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, openssl-dev-MCmKBN63+BlAfugRpC6u6w@public.gmane.org, GnuTLS development list <gnutls-devel-f8S/fY/i+OXSWulAQ3bEYg@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, 2016-12-24 at 14:25 +0100, Nikos Mavrogiannopoulos wrote:
> On Fri, Dec 23, 2016 at 7:06 PM, James Bottomley
> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > The reason this comes about is because we already have a standard 
> > form for TPM 1.2 keys here:
> > http://david.woodhou.se/draft-woodhouse-cert-best-practice.html#ide
> > nt-tpm
> > However, since I'm working on TPM2 enabling for openssl and gnutls, 
> > I need to come up with a new key format because TPM2 requires some
> > extra parameters and the original TSS KEY BLOB, being a single
> > ASN1_OCTET_STRING isn't expandable.
> [...]
> > I'm torn on where to get the OIDs from.  Since this is a TPM key, 
> > it might make sense to use the TCG OID (2.23.133) and just add
> > something they haven't already used, like 10 for key formats, or we 
> > could go with a pkcs OID (1.2.840.113549.1)
> 
> OIDs under some umbrella normally need to be registered within the
> organization they belong to. If you cannot find a suitable
> organization to get these OIDs from I'll check whether we can get
> something under redhat's OIDs.

I think, since it's a key format, the two above are the potential ones.
 It would be TCG if they want to take it into their standard, otherwise
PKCS is RSA Inc.

> > If we can agree on this, we can update David's document and make it 
> > a formal RFC.
> 
> Shouldn't version be first?

I put OID first because that's what makes the structure self
describing.  You simply need to look for the SEQUENCE OBJECT OID
prefix.  We can easily register our own, of course as well.  If version
goes first, you have a variable prefix.

>  However, I'm not sure how expandable is ASN.1 using version fields 
> (I've seen no structure being able to be re-used using a different 
> version). An alternative approach would to allow for future 
> extensions, i.e., something like the PKIX Extension field, which is
> an OID+data.

As long as the expansion fields are optional, it works nicely.  X509
and X509v3 are examples of version expanded ASN.1

James


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
