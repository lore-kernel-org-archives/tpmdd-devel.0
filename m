From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 10 Feb 2017 09:22:06 -0800
Message-ID: <OF46A12741.2A8AB0A8-ON852580C3.005E91DA-882580C3.005F6896@notes.na.collabserv.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
	<1485554699.3229.20.camel@HansenPartnership.com>
	<o6m2nv$g6n$1@blaine.gmane.org>
	<1485792295.2518.23.camel@HansenPartnership.com>
	<20170130215815.4lr42ob7e4cycwgi@intel.com>
	<1485814388.2518.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7041555037395083477=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485814388.2518.28.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7041555037395083477==
Content-type: multipart/alternative;
	Boundary="0__=0ABB0A50DFCD174A8f9e8a93df938690918c0ABB0A50DFCD174A"
Content-Disposition: inline


--0__=0ABB0A50DFCD174A8f9e8a93df938690918c0ABB0A50DFCD174A
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=US-ASCII

> > It does. My trusted keys implementation actually uses sessions.
>
> But as I read the code, I can't find where the kernel creates a
> session.  It looks like the session and hmac are passed in as option
> arguments, aren't they?

A bit of background.

In TPM 1.2, any authorization needed a session and an HMAC.

In TPM 2.0, authorization can be done using a plaintext password
(optionally) rather than an HMAC.  To me, kernel authorization
is a good use case for a plaintext password, since there is a
trusted path to the TPM.

When using a plaintext password, the caller does not require
startauthsession.  There is a special handle number that means
"plaintext password, no HMAC".  It's always available, and does
not occupy a session slot.

However, for the future ...

TPM 2.0 also has policy sessions.  E.g., use of the EK requires
a policy.

If the kernel ever wants to use policy, it needs startauthsession.

That's why I'm thinking that perhaps the space code should just
reserve ~2 sessions for it's own use, so it never blocks
because user space has occupied all the session slots.

--0__=0ABB0A50DFCD174A8f9e8a93df938690918c0ABB0A50DFCD174A
Content-Transfer-Encoding: quoted-printable
Content-type: text/html; charset=US-ASCII
Content-Disposition: inline

<html><body><p><tt>&gt; &gt; It does. My trusted keys implementation actual=
ly uses sessions.<br>&gt; <br>&gt; But as I read the code, I can't find whe=
re the kernel creates a<br>&gt; session. &nbsp;It looks like the session an=
d hmac are passed in as option<br>&gt; arguments, aren't they?<br></tt><br>=
<tt>A bit of background. &nbsp;</tt><br><br><tt>In TPM 1.2, any authorizati=
on needed a session and an HMAC.</tt><br><br><tt>In TPM 2.0, authorization =
can be done using a plaintext password</tt><br><tt>(optionally) rather than=
 an HMAC. &nbsp;To me, kernel authorization</tt><br><tt>is a good use case =
for a plaintext password, since there is a</tt><br><tt>trusted path to the =
TPM.</tt><br><br><tt>When using a plaintext password, the caller does not r=
equire</tt><br><tt>startauthsession. &nbsp;There is a special handle number=
 that means</tt><br><tt>&quot;plaintext password, no HMAC&quot;. &nbsp;It's=
 always available, and does</tt><br><tt>not occupy a session slot.</tt><br>=
<br><tt>However, for the future ...</tt><br><br><tt>TPM 2.0 also has policy=
 sessions. &nbsp;E.g., use of the EK requires</tt><br><tt>a policy.</tt><br=
><br><tt>If the kernel ever wants to use policy, it needs startauthsession.=
</tt><br><br><tt>That's why I'm thinking that perhaps the space code should=
 just</tt><br><tt>reserve ~2 sessions for it's own use, so it never blocks<=
/tt><br><tt>because user space has occupied all the session slots.</tt><BR>
</body></html>

--0__=0ABB0A50DFCD174A8f9e8a93df938690918c0ABB0A50DFCD174A--



--===============7041555037395083477==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============7041555037395083477==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7041555037395083477==--
