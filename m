From: "Attak, Hamza" <hamza.attak-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH] msleep() delays - replace with usleep_range()
 in TPM 1.2/2.0 generic drivers
Date: Tue, 30 May 2017 17:50:21 +0000
Message-ID: <DF4PR84MB00286E6F6F1E51633C8D65C4F2F00@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_"
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: "Jacquin, Ludovic" <ludo-ZPxbGqLxI0U@public.gmane.org>, "Edwards, Nigel" <nigel.edwards-ZPxbGqLxI0U@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--_004_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_
Content-Type: multipart/alternative;
	boundary="_000_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_"

--_000_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Following the recent Nuvoton patch submitted by Mimi Zohar:
https://sourceforge.net/p/tpmdd/mailman/message/35685260/

Based on this work, I decided to apply a similar modification to the generi=
c TPM drivers in the kernel.
The patch simply replaces all msleep function calls with usleep_range calls=
 in the generic drivers. As a former patch already exists for the Nuvoton T=
PM, it is therefore not included in this new patch.

Tested with an Infineon TPM 1.2, using the generic tpm-tis module, for a th=
ousand PCR extends, we see results going from 1m57s unpatched to 40s with t=
he new patch. We obtain similar results when using the original and patched=
 tpm_infineon driver, which is also part of the patch.
Similarly with a STM TPM 2.0, using the CRB driver, it takes about 20ms per=
 extend unpatched and around 7ms with the new patch.

Note that the PCR consistency is untouched with this patch, each TPM has be=
en tested with 10 million extends and the aggregated PCR value is continuou=
sly verified to be correct.

As an extension of this work, this could potentially and easily be applied =
to other vendor's drivers. Still, these changes are not included in the pro=
posed patch as they are untested.

Thanks,
Hamza ATTAK.


--_000_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Following the recent Nuvoton patch submitted by Mimi=
 Zohar:<o:p></o:p></p>
<p class=3D"MsoNormal">https://sourceforge.net/p/tpmdd/mailman/message/3568=
5260/<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Based on this work, I decided to apply a similar mod=
ification to the generic TPM drivers in the kernel.<o:p></o:p></p>
<p class=3D"MsoNormal">The patch simply replaces all msleep function calls =
with usleep_range calls in the generic drivers. As a former patch already e=
xists for the Nuvoton TPM, it is therefore not included in this new patch.<=
o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Tested with an Infineon TPM 1.2, using the generic t=
pm-tis module, for a thousand PCR extends, we see results going from 1m57s =
unpatched to 40s with the new patch. We obtain similar results when using t=
he original and patched tpm_infineon
 driver, which is also part of the patch.<o:p></o:p></p>
<p class=3D"MsoNormal">Similarly with a STM TPM 2.0, using the CRB driver, =
it takes about 20ms per extend unpatched and around 7ms with the new patch.=
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Note that the PCR consistency is untouched with this=
 patch, each TPM has been tested with 10 million extends and the aggregated=
 PCR value is continuously verified to be correct.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">As an extension of this work, this could potentially=
 and easily be applied to other vendor's drivers. Still, these changes are =
not included in the proposed patch as they are untested.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Hamza ATTAK.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_--

--_004_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_
Content-Type: application/octet-stream; name="tpm_usleep_range_tested.patch"
Content-Description: tpm_usleep_range_tested.patch
Content-Disposition: attachment; filename="tpm_usleep_range_tested.patch";
	size=4432; creation-date="Tue, 30 May 2017 16:53:22 GMT";
	modification-date="Tue, 30 May 2017 15:32:34 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci90cG0vdHBtLWludGVyZmFjZS5jIGIvZHJpdmVycy9j
aGFyL3RwbS90cG0taW50ZXJmYWNlLmMKaW5kZXggYmQyMTI4ZS4uZjAzZGFmNSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9jaGFyL3RwbS90cG0taW50ZXJmYWNlLmMKKysrIGIvZHJpdmVycy9jaGFyL3Rw
bS90cG0taW50ZXJmYWNlLmMKQEAgLTM5NSw3ICszOTUsNyBAQCBzc2l6ZV90IHRwbV90cmFuc21p
dChzdHJ1Y3QgdHBtX2NoaXAgKmNoaXAsIGNvbnN0IHU4ICpidWYsIHNpemVfdCBidWZzaXosCiAJ
CQlnb3RvIG91dDsKIAkJfQogCi0JCW1zbGVlcChUUE1fVElNRU9VVCk7CS8qIENIRUNLICovCisJ
CXVzbGVlcF9yYW5nZShUUE1fVElNRU9VVCAqIDEwMDAsIChUUE1fVElNRU9VVCAqIDEwMDApICsg
MzAwKTsKIAkJcm1iKCk7CiAJfSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywgc3RvcCkpOwog
CkBAIC04NjIsNyArODYyLDcgQEAgaW50IHRwbV9kb19zZWxmdGVzdChzdHJ1Y3QgdHBtX2NoaXAg
KmNoaXApCiAJCQlkZXZfaW5mbygKIAkJCSAgICAmY2hpcC0+ZGV2LCBIV19FUlIKIAkJCSAgICAi
VFBNIGNvbW1hbmQgdGltZWQgb3V0IGR1cmluZyBjb250aW51ZSBzZWxmIHRlc3QiKTsKLQkJCW1z
bGVlcChkZWxheV9tc2VjKTsKKwkJCXVzbGVlcF9yYW5nZShkZWxheV9tc2VjICogMTAwMCwgKGRl
bGF5X21zZWMgKiAxMDAwKSArIDMwMCk7CiAJCQljb250aW51ZTsKIAkJfQogCkBAIC04NzcsNyAr
ODc3LDcgQEAgaW50IHRwbV9kb19zZWxmdGVzdChzdHJ1Y3QgdHBtX2NoaXAgKmNoaXApCiAJCX0K
IAkJaWYgKHJjICE9IFRQTV9XQVJOX0RPSU5HX1NFTEZURVNUKQogCQkJcmV0dXJuIHJjOwotCQlt
c2xlZXAoZGVsYXlfbXNlYyk7CisJCXVzbGVlcF9yYW5nZShkZWxheV9tc2VjICogMTAwMCwgKGRl
bGF5X21zZWMgKiAxMDAwKSArIDMwMCk7CiAJfSB3aGlsZSAoLS1sb29wcyA+IDApOwogCiAJcmV0
dXJuIHJjOwpAQCAtOTc3LDcgKzk3Nyw3IEBAIGludCB3YWl0X2Zvcl90cG1fc3RhdChzdHJ1Y3Qg
dHBtX2NoaXAgKmNoaXAsIHU4IG1hc2ssIHVuc2lnbmVkIGxvbmcgdGltZW91dCwKIAkJfQogCX0g
ZWxzZSB7CiAJCWRvIHsKLQkJCW1zbGVlcChUUE1fVElNRU9VVCk7CisJCQl1c2xlZXBfcmFuZ2Uo
VFBNX1RJTUVPVVQgKiAxMDAwLCAoVFBNX1RJTUVPVVQgKiAxMDAwKSArIDMwMCk7CiAJCQlzdGF0
dXMgPSBjaGlwLT5vcHMtPnN0YXR1cyhjaGlwKTsKIAkJCWlmICgoc3RhdHVzICYgbWFzaykgPT0g
bWFzaykKIAkJCQlyZXR1cm4gMDsKQEAgLTEwNDUsNyArMTA0NSw3IEBAIGludCB0cG1fcG1fc3Vz
cGVuZChzdHJ1Y3QgZGV2aWNlICpkZXYpCiAJCSAqLwogCQlpZiAocmMgIT0gVFBNX1dBUk5fUkVU
UlkpCiAJCQlicmVhazsKLQkJbXNsZWVwKFRQTV9USU1FT1VUX1JFVFJZKTsKKwkJdXNsZWVwX3Jh
bmdlKFRQTV9USU1FT1VUX1JFVFJZICogMTAwMCwgKFRQTV9USU1FT1VUX1JFVFJZICogMTAwMCkg
KyAzMDApOwogCX0KIAogCWlmIChyYykKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci90cG0vdHBt
Mi1jbWQuYyBiL2RyaXZlcnMvY2hhci90cG0vdHBtMi1jbWQuYwppbmRleCA4ODFhZWE5Li5iZGFl
MjA1IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NoYXIvdHBtL3RwbTItY21kLmMKKysrIGIvZHJpdmVy
cy9jaGFyL3RwbS90cG0yLWNtZC5jCkBAIC05NjEsNyArOTYxLDcgQEAgc3RhdGljIGludCB0cG0y
X2RvX3NlbGZ0ZXN0KHN0cnVjdCB0cG1fY2hpcCAqY2hpcCkKIAkJaWYgKHJjICE9IFRQTTJfUkNf
VEVTVElORykKIAkJCWJyZWFrOwogCi0JCW1zbGVlcChkZWxheV9tc2VjKTsKKwkJdXNsZWVwX3Jh
bmdlKGRlbGF5X21zZWMgKiAxMDAwLCAoZGVsYXlfbXNlYyAqIDEwMDApICsgMzAwKTsKIAl9CiAK
IAlyZXR1cm4gcmM7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvdHBtL3RwbV9pbmZpbmVvbi5j
IGIvZHJpdmVycy9jaGFyL3RwbS90cG1faW5maW5lb24uYwppbmRleCBlM2NmOWYzLi44NmYwZjNl
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NoYXIvdHBtL3RwbV9pbmZpbmVvbi5jCisrKyBiL2RyaXZl
cnMvY2hhci90cG0vdHBtX2luZmluZW9uLmMKQEAgLTE5MSw3ICsxOTEsNyBAQCBzdGF0aWMgaW50
IHdhaXQoc3RydWN0IHRwbV9jaGlwICpjaGlwLCBpbnQgd2FpdF9mb3JfYml0KQogCQkvKiBjaGVj
ayB0aGUgc3RhdHVzLXJlZ2lzdGVyIGlmIHdhaXRfZm9yX2JpdCBpcyBzZXQgKi8KIAkJaWYgKHN0
YXR1cyAmIDEgPDwgd2FpdF9mb3JfYml0KQogCQkJYnJlYWs7Ci0JCW1zbGVlcChUUE1fTVNMRUVQ
X1RJTUUpOworCQl1c2xlZXBfcmFuZ2UoVFBNX01TTEVFUF9USU1FICogMTAwMCwgKFRQTV9NU0xF
RVBfVElNRSAqIDEwMDApICsgMzAwKTsKIAl9CiAJaWYgKGkgPT0gVFBNX01BWF9UUklFUykgewkv
KiB0aW1lb3V0IG9jY3VycyAqLwogCQlpZiAod2FpdF9mb3JfYml0ID09IFNUQVRfWEZFKQpAQCAt
MjI2LDcgKzIyNiw3IEBAIHN0YXRpYyB2b2lkIHRwbV93dHgoc3RydWN0IHRwbV9jaGlwICpjaGlw
KQogCXdhaXRfYW5kX3NlbmQoY2hpcCwgVFBNX0NUUkxfV1RYKTsKIAl3YWl0X2FuZF9zZW5kKGNo
aXAsIDB4MDApOwogCXdhaXRfYW5kX3NlbmQoY2hpcCwgMHgwMCk7Ci0JbXNsZWVwKFRQTV9XVFhf
TVNMRUVQX1RJTUUpOworCXVzbGVlcF9yYW5nZShUUE1fV1RYX01TTEVFUF9USU1FICogMTAwMCwg
KFRQTV9XVFhfTVNMRUVQX1RJTUUgKiAxMDAwKSArIDMwMCk7CiB9CiAKIHN0YXRpYyB2b2lkIHRw
bV93dHhfYWJvcnQoc3RydWN0IHRwbV9jaGlwICpjaGlwKQpAQCAtMjM3LDcgKzIzNyw3IEBAIHN0
YXRpYyB2b2lkIHRwbV93dHhfYWJvcnQoc3RydWN0IHRwbV9jaGlwICpjaGlwKQogCXdhaXRfYW5k
X3NlbmQoY2hpcCwgMHgwMCk7CiAJd2FpdF9hbmRfc2VuZChjaGlwLCAweDAwKTsKIAludW1iZXJf
b2Zfd3R4ID0gMDsKLQltc2xlZXAoVFBNX1dUWF9NU0xFRVBfVElNRSk7CisJdXNsZWVwX3Jhbmdl
KFRQTV9XVFhfTVNMRUVQX1RJTUUgKiAxMDAwLCAoVFBNX1dUWF9NU0xFRVBfVElNRSAqIDEwMDAp
ICsgMzAwKTsKIH0KIAogc3RhdGljIGludCB0cG1faW5mX3JlY3Yoc3RydWN0IHRwbV9jaGlwICpj
aGlwLCB1OCAqIGJ1Ziwgc2l6ZV90IGNvdW50KQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL3Rw
bS90cG1fdGlzX2NvcmUuYyBiL2RyaXZlcnMvY2hhci90cG0vdHBtX3Rpc19jb3JlLmMKaW5kZXgg
YzBmMjk2Yi4uZTdkMzA0NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9jaGFyL3RwbS90cG1fdGlzX2Nv
cmUuYworKysgYi9kcml2ZXJzL2NoYXIvdHBtL3RwbV90aXNfY29yZS5jCkBAIC01MSw3ICs1MSw3
IEBAIHN0YXRpYyBpbnQgd2FpdF9zdGFydHVwKHN0cnVjdCB0cG1fY2hpcCAqY2hpcCwgaW50IGwp
CiAKIAkJaWYgKGFjY2VzcyAmIFRQTV9BQ0NFU1NfVkFMSUQpCiAJCQlyZXR1cm4gMDsKLQkJbXNs
ZWVwKFRQTV9USU1FT1VUKTsKKwkJdXNsZWVwX3JhbmdlKFRQTV9USU1FT1VUICogMTAwMCwgKFRQ
TV9USU1FT1VUICogMTAwMCkgKyAzMDApOwogCX0gd2hpbGUgKHRpbWVfYmVmb3JlKGppZmZpZXMs
IHN0b3ApKTsKIAlyZXR1cm4gLTE7CiB9CkBAIC0xMjUsNyArMTI1LDcgQEAgc3RhdGljIGludCBy
ZXF1ZXN0X2xvY2FsaXR5KHN0cnVjdCB0cG1fY2hpcCAqY2hpcCwgaW50IGwpCiAJCWRvIHsKIAkJ
CWlmIChjaGVja19sb2NhbGl0eShjaGlwLCBsKSA+PSAwKQogCQkJCXJldHVybiBsOwotCQkJbXNs
ZWVwKFRQTV9USU1FT1VUKTsKKwkJCXVzbGVlcF9yYW5nZShUUE1fVElNRU9VVCAqIDEwMDAsIChU
UE1fVElNRU9VVCAqIDEwMDApICsgMzAwKTsKIAkJfSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmll
cywgc3RvcCkpOwogCX0KIAlyZXR1cm4gLTE7CkBAIC0xNzAsNyArMTcwLDcgQEAgc3RhdGljIGlu
dCBnZXRfYnVyc3Rjb3VudChzdHJ1Y3QgdHBtX2NoaXAgKmNoaXApCiAJCWJ1cnN0Y250ID0gKHZh
bHVlID4+IDgpICYgMHhGRkZGOwogCQlpZiAoYnVyc3RjbnQpCiAJCQlyZXR1cm4gYnVyc3RjbnQ7
Ci0JCW1zbGVlcChUUE1fVElNRU9VVCk7CisJCXVzbGVlcF9yYW5nZShUUE1fVElNRU9VVCAqIDEw
MDAsIChUUE1fVElNRU9VVCAqIDEwMDApICsgMzAwKTsKIAl9IHdoaWxlICh0aW1lX2JlZm9yZShq
aWZmaWVzLCBzdG9wKSk7CiAJcmV0dXJuIC1FQlVTWTsKIH0KQEAgLTQwOCw3ICs0MDgsNyBAQCBz
dGF0aWMgaW50IHRwbV90aXNfc2VuZChzdHJ1Y3QgdHBtX2NoaXAgKmNoaXAsIHU4ICpidWYsIHNp
emVfdCBsZW4pCiAJcHJpdi0+aXJxID0gaXJxOwogCWNoaXAtPmZsYWdzIHw9IFRQTV9DSElQX0ZM
QUdfSVJROwogCWlmICghcHJpdi0+aXJxX3Rlc3RlZCkKLQkJbXNsZWVwKDEpOworCQl1c2xlZXBf
cmFuZ2UoMTAwMCwgMTMwMCk7CiAJaWYgKCFwcml2LT5pcnFfdGVzdGVkKQogCQlkaXNhYmxlX2lu
dGVycnVwdHMoY2hpcCk7CiAJcHJpdi0+aXJxX3Rlc3RlZCA9IHRydWU7Cg==

--_004_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--_004_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--_004_DF4PR84MB00286E6F6F1E51633C8D65C4F2F00DF4PR84MB0028NAMP_--
