From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 0/7] Rework of tpm_tis to share common
 logic across phy's (lpc/spi/-i2c-)
Date: Thu, 26 May 2016 18:05:08 +0200
Message-ID: <27012471-3e60-f0fd-5e45-2b0e7ece880d@gmail.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
	<20160526122635.GA31557@intel.com>
	<20160526131932.C95EDC6047@b03ledav006.gho.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3398741607996186202=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160526131932.C95EDC6047-YTr1IC4v7wD031Vs2vNS4j5RcGG8+4aCqyM6JfAXOaQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--===============3398741607996186202==
Content-Type: multipart/alternative;
	boundary="------------0FD181B831F971E5BFBF27D6"

This is a multi-part message in MIME format.
--------------0FD181B831F971E5BFBF27D6
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Thanks  a lot Stefan !

Le 26/05/2016 à 15:19, Stefan Berger a écrit :
> Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 05/26/2016 
> 08:26:35 AM:
>
> >
> > Stefan, Peter,
> >
> > Would it be possible for you to smoke test this patch set?
>
> I tested ACPI S3 suspend/resume, running a test suite on /dev/tpm0 
> (TPM_TIS), and running the vTPM test suite. These tests were done on 
> today's master of your tree on infradead. All tests passed.
>
> Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
>    Stefan
>


--------------0FD181B831F971E5BFBF27D6
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <div class="moz-cite-prefix">Thanks  a lot Stefan !<br>
      <br>
      Le 26/05/2016 à 15:19, Stefan Berger a écrit :<br>
    </div>
    <blockquote
      cite="mid:20160526131932.C95EDC6047-YTr1IC4v7wD031Vs2vNS4j5RcGG8+4aCqyM6JfAXOaQ@public.gmane.org"
      type="cite"><tt><font size="2">Jarkko Sakkinen
          <a class="moz-txt-link-rfc2396E" href="mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org">&lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</a>
          wrote on 05/26/2016 08:26:35 AM:<br>
          <br>
          &gt; <br>
          &gt; Stefan, Peter,<br>
          &gt; <br>
          &gt; Would it be possible for you to smoke test this patch
          set?</font></tt><br>
      <br>
      <tt><font size="2">I tested ACPI S3 suspend/resume, running a test
          suite
          on /dev/tpm0 (TPM_TIS), and running the vTPM test suite. These
          tests were
          done on today's master of your tree on infradead. All tests
          passed.</font></tt><br>
      <br>
      <tt><font size="2">Tested-by: Stefan Berger
          <a class="moz-txt-link-rfc2396E" href="mailto:stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org">&lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</a></font></tt><br>
      <br>
      <tt><font size="2">   Stefan</font></tt><br>
      <br>
    </blockquote>
    <p><br>
    </p>
  </body>
</html>

--------------0FD181B831F971E5BFBF27D6--


--===============3398741607996186202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
--===============3398741607996186202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3398741607996186202==--
