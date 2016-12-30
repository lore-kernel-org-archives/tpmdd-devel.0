From: Ken Goldman <kgoldman@us.ibm.com>
Subject: Re: [gnutls-devel] Proposal for the ASN.1 form of
 TPM1.2 and TPM2 keys
Date: Fri, 30 Dec 2016 10:40:24 -0500
Message-ID: <o45v4u$60d$1@blaine.gmane.org>
References: <1482516363.2501.34.camel@HansenPartnership.com>
	<CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
	<1482596030.2316.4.camel@HansenPartnership.com>
	<CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
	<1482691491.3394.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
In-Reply-To: <1482691491.3394.8.camel@HansenPartnership.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: trousers-tech@lists.sourceforge.net
Cc: tpmdd-devel@lists.sourceforge.net, openssl-dev@openssl.org, gnutls-devel@lists.gnutls.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 12/25/2016 1:44 PM, James Bottomley wrote:
> On Sun, 2016-12-25 at 10:18 +0100, Nikos Mavrogiannopoulos wrote:
>> On Sat, Dec 24, 2016 at 5:13 PM, James Bottomley
>>
>> I wouldn't expect RSA inc to be involved into this as part of PKCS.
>> They are dead long time ago and have moved to IETF.
>
> I think I should give TCG first crack at wanting to own the OID.  The
> IETF ones are easy: once you codify it in an RFC, the oid registry auto
> extracts it.

Does this help at all?  From the TCG Credential Profile EK specL

TCG has registered an object identifier (OID) namespace as an =

=93international body=94 in the ISO registration hierarchy. This leads to =

shorter OIDs and gives TCG the ability to manage its own namespace. The =

OID namespace is inherited from TCPA. These definitions are intended to =

be used within the context of an X.509 v3 certificate specifically =

leveraging the profile described in RFC 5280[11].

-- TCG specific OIDs
tcg OBJECT IDENTIFIER ::=3D {
     joint-iso-itu-t(2) international-organizations(23) tcg(133) }




---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most =

engaging tech sites, SlashDot.org! http://sdm.link/slashdot
