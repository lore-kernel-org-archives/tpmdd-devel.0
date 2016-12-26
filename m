From: Nikos Mavrogianopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: Proposal for the ASN.1 form of TPM1.2 and TPM2
 keys
Date: Mon, 26 Dec 2016 21:13:03 +0100
Message-ID: <671CBF50-E114-4FD1-995A-523C7B63F8D5@gmail.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
 <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
 <1482596030.2316.4.camel@HansenPartnership.com>
 <CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
 <1482691491.3394.8.camel@HansenPartnership.com>
 <CAJU7zaL2WGnBgCnx_EQ7wNnaYpaUK8BfbX40Gm85zamnFYfhgA@mail.gmail.com>
 <1482709652.3394.15.camel@HansenPartnership.com>
 <F37418F5-0ECC-4F8B-981A-2ED74FAADA51@gmail.com>
 <1482776020.2430.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1180162925698381974=="
Return-path: <gnutls-devel-bounces@lists.gnutls.org>
In-Reply-To: <1482776020.2430.19.camel@HansenPartnership.com>
List-Unsubscribe: <http://lists.gnupg.org/mailman/options/gnutls-devel>,
 <mailto:gnutls-devel-request@lists.gnutls.org?subject=unsubscribe>
List-Archive: </pipermail/>
List-Post: <mailto:gnutls-devel@lists.gnutls.org>
List-Help: <mailto:gnutls-devel-request@lists.gnutls.org?subject=help>
List-Subscribe: <http://lists.gnupg.org/mailman/listinfo/gnutls-devel>,
 <mailto:gnutls-devel-request@lists.gnutls.org?subject=subscribe>
Errors-To: gnutls-devel-bounces@lists.gnutls.org
Sender: "Gnutls-devel" <gnutls-devel-bounces@lists.gnutls.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>, openssl-dev@openssl.org, GnuTLS development list <gnutls-devel@lists.gnutls.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============1180162925698381974==
Content-Type: multipart/alternative; boundary="----VOE3CSR9S2016T79HU9700BJIEBCRN"
Content-Transfer-Encoding: 8bit

------VOE3CSR9S2016T79HU9700BJIEBCRN
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8

My comment was on the claim of extendability of the format which as I explained it is simply not true. As for example I already gave the key usage extension. I am fine however with a non extendable format as you proposed. 

On December 26, 2016 7:13:40 PM GMT+01:00, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>On Mon, 2016-12-26 at 08:18 +0100, Nikos Mavrogianopoulos wrote:
>> I'd like both backwards and forward compatibility actually, exactly
>> like x509. If an informational field is added like the key usage that
>> I mentioned, I doubt you'd like all the previous consumers
>> incompatible.
>
>OK, so there's a fundamental difference between a v3 X509 certificate
>and a TPM key: An X509 certificate is a signature over a set of v1 TBS
>data, a public key and a bundle of attributes.  To verify the
>certificate or extract the key, you don't need to know what the
>attributes are, so you can still "use" the certificate in that form. 
> However, you can't get the v1 tool to obey the v3 constraints on the
>certificate because it doesn't understand them.
>
>The ASN.1 description of a TPM key contains the actual binary
>representation of the key plus a set of information which explains to
>the consuming code how to use the key.  Since I can't think of a way of
>making use of the key without understanding all of the information
>about how to use it, I think it is beneficial that v1 consumers don't
>try to use v2 key information because the resulting failure will excite
>the TPM's dictionary attack protection.
>
>I gave an example of one such extension: policy authorisations, but
>they're definitely of the "if you don't understand these, you can't use
>the key" variety.  Perhaps if you can give an example of a potentially
>compatible extensions it would help me to see your point and give us a
>means of moving forwards.
>
>Thanks,
>
>James
>
>>  For other extensions which make the structure totally incompatible
>> you can use the critical flag. Anyway even the original struct is OK,
>> it is exactly like any other key structs we have.

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
------VOE3CSR9S2016T79HU9700BJIEBCRN
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head></head><body>My comment was on the claim of extendability of the format which as I explained it is simply not true. As for example I already gave the key usage extension. I am fine however with a non extendable format as you proposed. <br><br><div class="gmail_quote">On December 26, 2016 7:13:40 PM GMT+01:00, James Bottomley &lt;James.Bottomley@HansenPartnership.com&gt; wrote:<blockquote class="gmail_quote" style="margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class="k9mail">On Mon, 2016-12-26 at 08:18 +0100, Nikos Mavrogianopoulos wrote:<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> I'd like both backwards and forward compatibility actually, exactly<br /> like x509. If an informational field is added like the key usage that<br /> I mentioned, I doubt you'd like all the previous consumers<br /> incompatible.<br /></blockquote><br />OK, so there's a fundamental difference between a v3 X509 certificate<br />and a TPM key: An X509 certificate is a signature over a set of v1 TBS<br />data, a public key and a bundle of attributes.  To verify the<br />certificate or extract the key, you don't need to know what the<br />attributes are, so you can still "use" the certific
 ate in that form. <br /> However, you can't get the v1 tool to obey the v3 constraints on the<br />certificate because it doesn't understand them.<br /><br />The ASN.1 description of a TPM key
contains the actual binary<br />representation of the key plus a set of information which explains to<br />the consuming code how to use the key.  Since I can't think of a way of<br />making use of the key without understanding all of the information<br />about how to use it, I think it is beneficial that v1 consumers don't<br />try to use v2 key information because the resulting failure will excite<br />the TPM's dictionary attack protection.<br /><br />I gave an example of one such extension: policy authorisations, but<br />they're definitely of the "if you don't understand these, you can't use<br />the key" variety.  Perhaps if you can give an example of a potentially<br />compatible extensions it would help me to see your point and give us a<br />means of moving forwards.<br /><br />Th
 anks,<br /><br />James<br /><br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;">  For other extensions which make the
structure totally incompatible<br /> you can use the critical flag. Anyway even the original struct is OK,<br /> it is exactly like any other key structs we have.<br /></blockquote><br /></pre></blockquote></div><br>
-- <br>
Sent from my Android device with K-9 Mail. Please excuse my brevity.</body></html>
------VOE3CSR9S2016T79HU9700BJIEBCRN--



--===============1180162925698381974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Gnutls-devel mailing list
Gnutls-devel@lists.gnutls.org
http://lists.gnupg.org/mailman/listinfo/gnutls-devel
--===============1180162925698381974==--
