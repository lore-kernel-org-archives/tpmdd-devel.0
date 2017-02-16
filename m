From: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Thu, 16 Feb 2017 18:10:43 +0000
Message-ID: <CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5781084691962915996=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170216180116.GA7145-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============5781084691962915996==
Content-Type: multipart/alternative; boundary=001a114258782cde660548a9b791

--001a114258782cde660548a9b791
Content-Type: text/plain; charset=UTF-8

Hey thanks for the prompt reply.

I think you are interested in this:

  fed40000-fed4087f : MSFT0101:00


Thanks!

On 16 February 2017 at 18:01, Jason Gunthorpe <
jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Feb 16, 2017 at 11:15:41AM +0000, Davide Guerri wrote:
> >    Hello guys,
> >    I am trying to get the fTPM on an Intel NUC working bit I get this
> >    error
> >
> >    [ 3.191376] tpm_crb MSFT0101:00: can't request region for resource
> >    [mem 0xfed40080-0xfed40fff]
>
> What does /proc/iomem say?
>
> Jason
>



-- 


[image: Davide Guerri on about.me]

Davide Guerri
about.me/davide_guerri
  <http://about.me/davide_guerri>

--001a114258782cde660548a9b791
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:12.800000190734863px">Hey thanks =
for the prompt reply.</span><div style=3D"font-size:12.800000190734863px"><=
br></div><div style=3D"font-size:12.800000190734863px">I think you are inte=
rested in this:</div><div style=3D"font-size:12.800000190734863px"><br></di=
v><div style=3D"font-size:12.800000190734863px">=C2=A0=C2=A0<span style=3D"=
color:rgb(77,47,45);font-family:hack;font-size:12px;background-color:rgb(22=
3,219,195)">fed40000-fed4087f : MSFT0101:00</span></div><div style=3D"font-=
size:12.800000190734863px"><span style=3D"color:rgb(77,47,45);font-family:h=
ack;font-size:12px;background-color:rgb(223,219,195)"><br></span></div><div=
 style=3D"font-size:12.800000190734863px"><br></div><div style=3D"font-size=
:12.800000190734863px">Thanks!</div></div><div class=3D"gmail_extra"><br><d=
iv class=3D"gmail_quote">On 16 February 2017 at 18:01, Jason Gunthorpe <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" target=
=3D"_blank">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex"><span class=3D"">On Thu, Feb 16, 2017 at 11:15:41A=
M +0000, Davide Guerri wrote:<br>
&gt;=C2=A0 =C2=A0 Hello guys,<br>
&gt;=C2=A0 =C2=A0 I am trying to get the fTPM on an Intel NUC working bit I=
 get this<br>
&gt;=C2=A0 =C2=A0 error<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 [ 3.191376] tpm_crb MSFT0101:00: can&#39;t request region=
 for resource<br>
&gt;=C2=A0 =C2=A0 [mem 0xfed40080-0xfed40fff]<br>
<br>
</span>What does /proc/iomem say?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Jason<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div di=
r=3D"ltr">
			=09
	<a href=3D"http://about.me/davide_guerri" style=3D"text-decoration:none" t=
arget=3D"_blank">
		<table border=3D"0" cellpadding=3D"0" cellspacing=3D"0">
			<tbody>
				<tr><td colspan=3D"3" style=3D"height:30px;font-size:0px">=C2=A0</td></=
tr>
				<tr>
					<td style=3D"line-height:1;vertical-align:top" align=3D"left" valign=
=3D"top">
						<div><img src=3D"http://d3mod6n032mdiz.cloudfront.net/thumb2/d/a/v/da=
vide_guerri/davide_guerri-105x70.jpg" alt=3D"Davide Guerri on about.me" sty=
le=3D"margin:0;padding:0;display:block;border:1px solid #eeeeee" height=3D"=
70" width=3D"105"></div>
					</td>
					<td style=3D"width:10px;font-size:0px">=C2=A0</td>
					<td style=3D"line-height:1;padding:0px;padding-bottom:3px;vertical-ali=
gn:bottom" align=3D"left" valign=3D"bottom">
						<div style=3D"margin:0;font-size:18px;line-height:1;font-weight:bold;=
color:#333333;font-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-=
Serif">Davide Guerri</div>
						<div style=3D"margin:0;margin-top:1px;font-size:12px;color:#2b82ad;fo=
nt-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-Serif">about.me/=
davide_guerri</div>
					</td>
				</tr>
				<tr><td colspan=3D"3" style=3D"height:20px;font-size:0px">=C2=A0</td></=
tr>
			</tbody>
		</table>
	</a>

			</div></div>
</div>

--001a114258782cde660548a9b791--


--===============5781084691962915996==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============5781084691962915996==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5781084691962915996==--
