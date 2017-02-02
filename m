From: Vicky <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Wed, 1 Feb 2017 23:24:59 -0500
Message-ID: <DB6ECC32-23B4-4955-9B0E-7D658F7A5707@linux.vnet.ibm.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
	<20170126220536.GB31937@obsidianresearch.com>
	<024dadba-a75c-ab59-9d12-a9bea81f9bda@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/mixed; boundary="===============0704040871455890523=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <024dadba-a75c-ab59-9d12-a9bea81f9bda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ashley Lai <ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Michal Such??nek <msuchanek-l3A5Bk7waGM@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============0704040871455890523==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=windows-1252

<html><head></head><body dir=3D"auto" style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;"><br><blockquote type=3D"cite">On Jan 26, 2017, at =
5:58 PM, Ashley Lai &lt;ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt; wrote:<br><br>Adding =
Vicky from IBM.<br><br><br>On 01/26/2017 04:05 PM, Jason Gunthorpe =
wrote:<br><blockquote type=3D"cite">On Thu, Jan 26, 2017 at 09:22:48PM =
+0100, Michal Such??nek wrote:<br><br><blockquote type=3D"cite">This is =
repeated a few times in the driver so I added memset to quiet<br>gcc and =
make behavior deterministic in case the unused fields get =
some<br>meaning in the future.<br></blockquote>Yep, reserved certainly =
needs to be zeroed.. Can you send a patch?<br>memset is =
overkill...<br><br><blockquote type=3D"cite">However, in =
tpm_ibmvtpm_send the structure is initialized as<br><br><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
ibmvtpm_crq crq;<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__be64 =
*word =3D (__be64 *)&amp;crq;<br>...<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;crq.valid =3D =
(u8)IBMVTPM_VALID_CMD;<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;crq.msg =3D =
(u8)VTPM_TPM_COMMAND;<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;crq.len =3D =
cpu_to_be16(count);<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;crq.data =3D =
cpu_to_be32(ibmvtpm-&gt;rtce_dma_handle);<br><br>and submitted =
with<br><br><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rc =3D ibmvtpm_send_crq(ibmvtpm-&gt;vdev, =
be64_to_cpu(word[0]),<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;be64_to_cpu(word[1]));<br>meaning it is =
swapped twice.<br></blockquote>No idea, Nayna may know.<br><br>My guess =
is that '__be64 *word' should be 'u64 =
*word'...<br><br>Jason<br></blockquote><br></blockquote><br><br>Please =
refer to commit =
62dfd912ab3b5405b6fe72d0135c37e9648071f1<br><br><br>Vicky<br></body></html=
>=



--===============0704040871455890523==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============0704040871455890523==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0704040871455890523==--
