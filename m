From: Nikos Mavrogianopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: Proposal for the ASN.1 form of TPM1.2 and TPM2
 keys
Date: Mon, 26 Dec 2016 08:18:02 +0100
Message-ID: <F37418F5-0ECC-4F8B-981A-2ED74FAADA51@gmail.com>
References: <1482516363.2501.34.camel@HansenPartnership.com>
 <CAJU7zaKjXhKJ-3PJD6XrLW2hTixEqL0B56epbqG3trw3jmXjVg@mail.gmail.com>
 <1482596030.2316.4.camel@HansenPartnership.com>
 <CAJU7za+PdjfKqtrEoJMhUK6Mm9Hsa98G8RGNRx-qMFwenMG9yg@mail.gmail.com>
 <1482691491.3394.8.camel@HansenPartnership.com>
 <CAJU7zaL2WGnBgCnx_EQ7wNnaYpaUK8BfbX40Gm85zamnFYfhgA@mail.gmail.com>
 <1482709652.3394.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7781656521763754658=="
Return-path: <gnutls-devel-bounces@lists.gnutls.org>
In-Reply-To: <1482709652.3394.15.camel@HansenPartnership.com>
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

--===============7781656521763754658==
Content-Type: multipart/alternative; boundary="----FK1BSHHOV3AT47L0BUAOW7DQL5VL0L"
Content-Transfer-Encoding: 8bit

------FK1BSHHOV3AT47L0BUAOW7DQL5VL0L
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8

I'd like both backwards and forward compatibility actually, exactly like x509. If an informational field is added like the key usage that I mentioned, I doubt you'd like all the previous consumers incompatible. For other extensions which make the structure totally incompatible you can use the critical flag. Anyway even the original struct is OK, it is exactly like any other key structs we have.

On December 26, 2016 12:47:32 AM GMT+01:00, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>On Sun, 2016-12-25 at 22:08 +0100, Nikos Mavrogiannopoulos wrote:
>> On Sun, Dec 25, 2016 at 7:44 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > > TPMKey ::= SEQUENCE {
>> > >         type            OBJECT IDENTIFIER
>> > >         version         [0] IMPLICIT INTEGER OPTIONAL
>> > >         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
>> > >         parent          [2] IMPLICIT INTEGER OPTIONAL
>> > >         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
>> > >         privateKey      OCTET STRING
>> > >          extensions      [4]  EXPLICIT Extensions OPTIONAL
>> > > }
>> > 
>> > Actually, that's the utility of ASN.1, once you use tagging, you 
>> > don't have to do this.  The structure above is identical to:
>> > 
>> > TPMKey ::= SEQUENCE {
>> >         type            OBJECT IDENTIFIER
>> >         version         [0] IMPLICIT INTEGER OPTIONAL
>> >         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL
>> >         parent          [2] IMPLICIT INTEGER OPTIONAL
>> >         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL
>> >         privateKey      OCTET STRING
>> >  }
>> > 
>> > If tag 4 isn't present because optional tags are not coded when not
>> > present, so you can expand any ASN.1 structure as long as you have 
>> > a clue from the version number that you should be looking for the
>> > optional extras.  The point being I don't have to specify the 
>> > expansion now, I can wait until we need it.
>> 
>> How would that work for example if you want to add an additional 
>> field with information on the type of the key for example (key 
>> usage)? You would add the tag 4 as you say, and then all the previous
>
>> parsers written with the initial description will fail parsing the 
>> new structure. X.509 (==PKIX) is only expandable via the extensions 
>> field which is already defined. If you add a field to it, no parser 
>> would be able to read the certificate.
>
>Um, well, you only want backwards compatibility, you don't really want
>forward compatibility.  Assuming something extends the structure and
>adds version v2, why would it matter that an old v1 application can't
>read a v2 structure because it doesn't understand the tag 4?  Even if
>it could it can't make use of the extra fields and something nasty will
>happen.  What you want is that the new v2 application can parse both
>the v2 structure and the old v1 one, but it's advantageous that a v1
>application fails with a v2 structure because it prevents cockups.
>
>James

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
------FK1BSHHOV3AT47L0BUAOW7DQL5VL0L
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head></head><body>I&#39;d like both backwards and forward compatibility actually, exactly like x509. If an informational field is added like the key usage that I mentioned, I doubt you&#39;d like all the previous consumers incompatible. For other extensions which make the structure totally incompatible you can use the critical flag. Anyway even the original struct is OK, it is exactly like any other key structs we have.<br><br><div class="gmail_quote">On December 26, 2016 12:47:32 AM GMT+01:00, James Bottomley &lt;James.Bottomley@HansenPartnership.com&gt; wrote:<blockquote class="gmail_quote" style="margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class="k9mail">On Sun, 2016-12-25 at 22:08 +0100, Nikos Mavrogiannopoulos wrote:<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> On Sun, Dec 25, 2016 at 7:44 PM, James Bottomley<br /> &lt;James.Bottomley@hansenpartnership.com&gt; wrote:<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #ad7fa8; padding-left: 1ex;"><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #8ae234; padding-left: 1ex;"> TPMKey ::= SEQUENCE {<br />         type            OBJECT IDENTIFIER<br />         version         [0] IMPLICIT INTEGER OPTIONAL<br />         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL<br />         parent          [2] IMPLICIT INTEGER
  OPTIONAL<br />         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL<br />         privateKey      OCTET STRING<br />          extensions      [4]  EXPLICIT Extensions OPTIONAL<br /> }<br
/></blockquote> <br /> Actually, that's the utility of ASN.1, once you use tagging, you <br /> don't have to do this.  The structure above is identical to:<br /> <br /> TPMKey ::= SEQUENCE {<br />         type            OBJECT IDENTIFIER<br />         version         [0] IMPLICIT INTEGER OPTIONAL<br />         emptyAuth       [1] IMPLICIT BOOLEAN OPTIONAL<br />         parent          [2] IMPLICIT INTEGER OPTIONAL<br />         publicKey       [3] IMPLICIT OCTET STRING OPTIONAL<br />         privateKey      OCTET STRING<br />  }<br /> <br /> If tag 4 isn't present because optional tags are not coded when not<br /> present, so you can expand any ASN.1 structure as long as you have <br /> a clue from the version number that you should be looking for the<br /> optional extras.  The point bei
 ng I don't have to specify the <br /> expansion now, I can wait until we need it.<br /></blockquote> <br /> How would that work for example if you want to add an additional <br /> field with
information on the type of the key for example (key <br /> usage)? You would add the tag 4 as you say, and then all the previous <br /> parsers written with the initial description will fail parsing the <br /> new structure. X.509 (==PKIX) is only expandable via the extensions <br /> field which is already defined. If you add a field to it, no parser <br /> would be able to read the certificate.<br /></blockquote><br />Um, well, you only want backwards compatibility, you don't really want<br />forward compatibility.  Assuming something extends the structure and<br />adds version v2, why would it matter that an old v1 application can't<br />read a v2 structure because it doesn't understand the tag 4?  Even if<br />it could it can't make use of the extra fields and something nasty will<br />
 happen.  What you want is that the new v2 application can parse both<br />the v2 structure and the old v1 one, but it's advantageous that a v1<br />application fails with a v2 structure because it
prevents cockups.<br /><br />James<br /><br /></pre></blockquote></div><br>
-- <br>
Sent from my Android device with K-9 Mail. Please excuse my brevity.</body></html>
------FK1BSHHOV3AT47L0BUAOW7DQL5VL0L--



--===============7781656521763754658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Gnutls-devel mailing list
Gnutls-devel@lists.gnutls.org
http://lists.gnupg.org/mailman/listinfo/gnutls-devel
--===============7781656521763754658==--
