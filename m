From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [gnutls-devel] Proposal for the ASN.1 form of
 TPM1.2 and TPM2 keys
Date: Mon, 26 Dec 2016 10:13:40 -0800
Message-ID: <1482776020.2430.19.camel@HansenPartnership.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
	<CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
	<1482596030.2316.4.camel@HansenPartnership.com>
	<CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
	<1482691491.3394.8.camel@HansenPartnership.com>
	<CAJU7zaL2WGnBgCnx_EQ7wNnaYpaUK8BfbX40Gm85zamnFYfhgA@mail.gmail.com>
	<1482709652.3394.15.camel@HansenPartnership.com>
	<F37418F5-0ECC-4F8B-981A-2ED74FAADA51@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <F37418F5-0ECC-4F8B-981A-2ED74FAADA51-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nikos Mavrogianopoulos <n.mavrogiannopoulos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nikos Mavrogiannopoulos <nmav-c5N7Ur/I1ocdnm+yROfE0A@public.gmane.org>
Cc: trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, openssl-dev-MCmKBN63+BlAfugRpC6u6w@public.gmane.org, GnuTLS development list <gnutls-devel-f8S/fY/i+OXSWulAQ3bEYg@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2016-12-26 at 08:18 +0100, Nikos Mavrogianopoulos wrote:
> I'd like both backwards and forward compatibility actually, exactly
> like x509. If an informational field is added like the key usage that
> I mentioned, I doubt you'd like all the previous consumers
> incompatible.

OK, so there's a fundamental difference between a v3 X509 certificate
and a TPM key: An X509 certificate is a signature over a set of v1 TBS
data, a public key and a bundle of attributes.  To verify the
certificate or extract the key, you don't need to know what the
attributes are, so you can still "use" the certificate in that form. 
 However, you can't get the v1 tool to obey the v3 constraints on the
certificate because it doesn't understand them.

The ASN.1 description of a TPM key contains the actual binary
representation of the key plus a set of information which explains to
the consuming code how to use the key.  Since I can't think of a way of
making use of the key without understanding all of the information
about how to use it, I think it is beneficial that v1 consumers don't
try to use v2 key information because the resulting failure will excite
the TPM's dictionary attack protection.

I gave an example of one such extension: policy authorisations, but
they're definitely of the "if you don't understand these, you can't use
the key" variety.  Perhaps if you can give an example of a potentially
compatible extensions it would help me to see your point and give us a
means of moving forwards.

Thanks,

James

>  For other extensions which make the structure totally incompatible
> you can use the critical flag. Anyway even the original struct is OK,
> it is exactly like any other key structs we have.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
