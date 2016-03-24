From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/12] tpm: Add tpm_set_vendordata and
	tpm_get_vendordata
Date: Fri, 25 Mar 2016 00:04:10 +0100
Message-ID: <56F4726A.7030104@gmail.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-6-git-send-email-christophe-h.ricard@st.com>
	<20160322062001.GB4058@intel.com>
	<CALD+uuxj2NHd0-LpDZpnfkfMHwY6ke0FPPqmR0FKzrC4BJmFNQ@mail.gmail.com>
	<20160324132732.GF8452@intel.com>
	<CALD+uuwVG_84dY4rCOjecZXxS4LZoE+Kh=CyhmVwyT2U0bAMrg@mail.gmail.com>
	<20160324161819.GA5263@obsidianresearch.com>
	<CALD+uux0-nbwJfsHFHqPrZwWt=vEy73oi_djNrrY5QeiWwCq9A@mail.gmail.com>
	<20160324171032.GA27978@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0504072000459994863=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160324171032.GA27978-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--===============0504072000459994863==
Content-Type: multipart/alternative;
	boundary="------------080603060906020507030000"

This is a multi-part message in MIME format.
--------------080603060906020507030000
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 24/03/2016 18:10, Jason Gunthorpe wrote:
> On Thu, Mar 24, 2016 at 05:31:21PM +0100, Christophe Ricard wrote:
>>     I got confused like you are but when looking a little bit better at the
>>     code i think we have 2 differents "struct device" available on a tpm
>>     driver.
>>     One is coming from the physical layer driver (aka: client->dev,
>>     spi->dev, pdev->dev) and the other one from chip->dev which is
>>     initialized in tpm_chip_alloc.
> Yes, client->dev's drvdata (aka chip->dev.parent) should point to the
> chip. In an ideal world the TPM core will never touch this, but we are
> not quite there yet, sysfs in particular is broken.
>
> chip->dev's drvdata could/should point to the driver's priv, that
> would make sense. With Jarkko's tree today that is OK.
>
> But Stefan's vtpm driver adds a use:
>
>   https://github.com/stefanberger/linux/commit/3ab4e3aabf50137068e2807910e5f867668b4e23
>
> Which is an ugly hacky thing..
I ran through the changes using client->dev's drvdata pointing to the 
chip and
&chip->dev's drvdata pointing to the driver's priv.
I have looked to stefanberger githubs and i am really sceptical about 
the purpose
of doing dev_set_drvdata(&chip->dev, chip); in tpm_sysfs_add_device.
I haven't seen any dev_get_drvdata(&chip->dev) in the tree even on top 
of the history. Did i overlooked at it ?
Shouldn't dev_set_drvdata(&chip->dev, chip);  in tpm_sysfs_add_device be 
removed ?

I plan to release the next serie about tpm_vendor_specific cleanup by 
tomorrow at least for further discussion :).
> So, if you are planning a tpm_get_drvdata or whatever then we should
> probably patch vtpm to put priv back in or patch vtpm to not need that
> hack.
>
> Jason
Best Regards
Christophe

--------------080603060906020507030000
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <br>
    <br>
    <div class="moz-cite-prefix">On 24/03/2016 18:10, Jason Gunthorpe
      wrote:<br>
    </div>
    <blockquote cite="mid:20160324171032.GA27978-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org"
      type="cite">
      <pre wrap="">On Thu, Mar 24, 2016 at 05:31:21PM +0100, Christophe Ricard wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">   I got confused like you are but when looking a little bit better at the
   code i think we have 2 differents "struct device" available on a tpm
   driver.
   One is coming from the physical layer driver (aka: client-&gt;dev,
   spi-&gt;dev, pdev-&gt;dev) and the other one from chip-&gt;dev which is
   initialized in tpm_chip_alloc.
</pre>
      </blockquote>
      <pre wrap="">
Yes, client-&gt;dev's drvdata (aka chip-&gt;dev.parent) should point to the
chip. In an ideal world the TPM core will never touch this, but we are
not quite there yet, sysfs in particular is broken.

chip-&gt;dev's drvdata could/should point to the driver's priv, that
would make sense. With Jarkko's tree today that is OK.

But Stefan's vtpm driver adds a use:

 <a class="moz-txt-link-freetext" href="https://github.com/stefanberger/linux/commit/3ab4e3aabf50137068e2807910e5f867668b4e23">https://github.com/stefanberger/linux/commit/3ab4e3aabf50137068e2807910e5f867668b4e23</a>

Which is an ugly hacky thing..
</pre>
    </blockquote>
    I ran through the changes using client-&gt;dev's drvdata pointing to
    the chip and<br>
    &amp;chip-&gt;dev's drvdata pointing to the driver's priv.<br>
    I have looked to stefanberger githubs and i am really sceptical
    about the purpose<br>
    of doing dev_set_drvdata(&amp;chip-&gt;dev, chip); in
    tpm_sysfs_add_device.<br>
    I haven't seen any dev_get_drvdata(&amp;chip-&gt;dev) in the tree
    even on top of the history. Did i overlooked at it ?<br>
    Shouldn't dev_set_drvdata(&amp;chip-&gt;dev, chip);  in
    tpm_sysfs_add_device be removed ?<br>
    <br>
    I plan to release the next serie about tpm_vendor_specific cleanup
    by tomorrow at least for further discussion :).<span style="color: rgb(51, 51, 51); font-family: Consolas, 'Liberation Mono', Menlo, Courier, monospace; font-size: 12px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: 16.8px; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; white-space: pre; widows: 1; word-spacing: 0px; -webkit-text-stroke-width: 0px; display: inline !important; float: none; background-color: rgb(234, 255, 234);">

</span>
    <blockquote cite="mid:20160324171032.GA27978-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org"
      type="cite">
      <pre wrap="">
So, if you are planning a tpm_get_drvdata or whatever then we should
probably patch vtpm to put priv back in or patch vtpm to not need that
hack.

Jason
</pre>
    </blockquote>
    Best Regards<br>
    Christophe<br>
  </body>
</html>

--------------080603060906020507030000--


--===============0504072000459994863==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
--===============0504072000459994863==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0504072000459994863==--
