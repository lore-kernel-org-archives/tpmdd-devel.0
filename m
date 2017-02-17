From: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Fri, 17 Feb 2017 21:14:45 +0000
Message-ID: <0FB78E3E-1E73-46EC-9ABD-FD05E1E8B0E2@gmail.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
	<CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B54395CD5@hasmsx108.ger.corp.intel.com>
	<20170217164332.GB30677@obsidianresearch.com>
	<1487356105.6424.1.camel@intel.com>
	<20170217190125.GA5984@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/mixed; boundary="===============0628125283948858872=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170217190125.GA5984-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Sakkinen, Jarkko" <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0628125283948858872==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_F4D81EEF-A59B-437C-ABE3-815F69795493"


--Apple-Mail=_F4D81EEF-A59B-437C-ABE3-815F69795493
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hey,
sorry fro the delayed reply.

Jason's patch works. I had no doubt it would, because I tried a qnd =
patch with manually cropped sizes.=20
I have cleaned it up a little bit, removing printks.

Thanks again!

D.=20



> On 17 Feb 2017, at 7:01 pm, Jason Gunthorpe =
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>=20
>> I would rather review a patch with proper commit message than just =
pick
>> from an email thread in all cases with a proper explanation what the
>> patch does and why it is the right way to fix the issue.
>=20
> Of course, but I am waiting for Davide to say the approach even works
> ..
>=20
> Jason


--Apple-Mail=_F4D81EEF-A59B-437C-ABE3-815F69795493
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_F0C25964-C11E-42CF-A0AD-4337282903E2"


--Apple-Mail=_F0C25964-C11E-42CF-A0AD-4337282903E2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">Hey,</div><div class=3D"">sorry fro the =
delayed reply.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Jason's patch works. I had no doubt it would, because I tried =
a qnd patch with manually cropped sizes.&nbsp;</div><div class=3D"">I =
have cleaned it up a little bit, removing&nbsp;<span style=3D"color: =
rgb(80, 0, 80); font-family: arial, sans-serif; font-size: =
12.800000190734863px; background-color: rgb(255, 255, 255);" =
class=3D"">printks.</span></div><div class=3D""><span style=3D"color: =
rgb(80, 0, 80); font-family: arial, sans-serif; font-size: =
12.800000190734863px; background-color: rgb(255, 255, 255);" =
class=3D""><br class=3D""></span></div><div class=3D""><span =
style=3D"color: rgb(80, 0, 80); font-family: arial, sans-serif; =
font-size: 12.800000190734863px; background-color: rgb(255, 255, 255);" =
class=3D"">Thanks again!</span></div><div class=3D""><span style=3D"color:=
 rgb(80, 0, 80); font-family: arial, sans-serif; font-size: =
12.800000190734863px; background-color: rgb(255, 255, 255);" =
class=3D""><br class=3D""></span></div><div class=3D""><span =
style=3D"color: rgb(80, 0, 80); font-family: arial, sans-serif; =
font-size: 12.800000190734863px; background-color: rgb(255, 255, 255);" =
class=3D"">D.&nbsp;</span></div><div class=3D""><br =
class=3D""></div></body></html>=

--Apple-Mail=_F0C25964-C11E-42CF-A0AD-4337282903E2
Content-Disposition: attachment;
	filename=NUC-fw-fix.patch
Content-Type: application/octet-stream; x-unix-mode=0644;
	name="NUC-fw-fix.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index a7c870a..7f5e871 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -243,6 +243,26 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 	return priv->iobase + (new_res.start - io_res->start);
 }

+/*
+ * Work around broken BIOSs that return inconsistent values from the ACPI
+ * region vs the registers. Trust the ACPI region.
+ */
+static u64 crb_clamp_cmd_size(struct device *dev, struct resource *io_res,
+			      u64 start, u64 size)
+{
+	if (io_res->start > start || io_res->end < start)
+		return size;
+
+	if (start + size - 1 <= io_res->end)
+		return size;
+
+	dev_err(dev,
+		FW_BUG "ACPI region does not cover the entire command/response buffer. %pr vs %llx %llx\n",
+		io_res, start, size);
+
+	return io_res->end - start + 1;
+}
+
 static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		      struct acpi_table_tpm2 *buf)
 {
@@ -278,14 +298,16 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,

 	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
 		  (u64) ioread32(&priv->cca->cmd_pa_low);
-	cmd_size = ioread32(&priv->cca->cmd_size);
+	cmd_size = crb_clamp_cmd_size(dev, &io_res, cmd_pa,
+				      ioread32(&priv->cca->cmd_size));
 	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
 	if (IS_ERR(priv->cmd))
 		return PTR_ERR(priv->cmd);

 	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
 	rsp_pa = le64_to_cpu(rsp_pa);
-	rsp_size = ioread32(&priv->cca->rsp_size);
+	rsp_size = crb_clamp_cmd_size(dev, &io_res, rsp_pa,
+				      ioread32(&priv->cca->rsp_size));

 	if (cmd_pa != rsp_pa) {
 		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);

--Apple-Mail=_F0C25964-C11E-42CF-A0AD-4337282903E2
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""><br class=""><div><blockquote type="cite" class=""><div class="">On 17 Feb 2017, at 7:01 pm, Jason Gunthorpe &lt;<a href="mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" class="">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt; wrote:</div><br class="Apple-interchange-newline"><div class=""><div class=""><blockquote type="cite" class="">I would rather review a patch with proper commit message than just pick<br class="">from an email thread in all cases with a proper explanation what the<br class="">patch does and why it is the right way to fix the issue.<br class=""></blockquote><br class="">Of co
 urse, but I am waiting for Davide to say the approach even works<br class="">..<br class=""><br class="">Jason<br class=""></div></div></blockquote></div><br class=""></div></body></html>
--Apple-Mail=_F0C25964-C11E-42CF-A0AD-4337282903E2--

--Apple-Mail=_F4D81EEF-A59B-437C-ABE3-815F69795493--


--===============0628125283948858872==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============0628125283948858872==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0628125283948858872==--
