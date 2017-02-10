From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 10 Feb 2017 18:13:51 -0500
Message-ID: <OF42F99452.D694823A-ON852580C3.007EDF64-852580C3.007F9C69@notes.na.collabserv.com>
References: <jarkko.sakkinen@linux.intel.com>
	<201702090906.v1996c6a015552@wind.enjellic.com>
	<20170209151922.cqo32h4io5dqyvvw@intel.com>
	<20170209190426.GA1104@obsidianresearch.com>
	<20170210084837.lq3mofgfwvjx623m@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9220249205725640816=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170210084837.lq3mofgfwvjx623m-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============9220249205725640816==
Content-type: multipart/alternative;
	Boundary="0__=0ABB0A50DFED59F48f9e8a93df938690918c0ABB0A50DFED59F4"
Content-Disposition: inline


--0__=0ABB0A50DFED59F48f9e8a93df938690918c0ABB0A50DFED59F4
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=US-ASCII

On Thu, Feb 09, 2017 at 12:04:26PM -0700, Jason Gunthorpe wrote:
Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/10/2017
03:48:37 AM:

> > This series should focus on allowing a user space RM to co-exist with
> > the in-kernel services - lets try and tackle the idea of a
> > policy-restricted or unpriv-safe cdev when someone comes up with a
> > comprehensive proposal..

First, does "coexist" mean in series (two layers of RM) or in parallel
(both
have simultaneous access).

Or does "in-kernel services" not include an RM?

Assuming in series, it will complicate the lower RM.  The main issue,
as always, is session context.  If you permit the upper RM to save context,
the lower RM has to track the mapping, because the lower layer can
alter the saved session context (regapping).

--0__=0ABB0A50DFED59F48f9e8a93df938690918c0ABB0A50DFED59F4
Content-Transfer-Encoding: quoted-printable
Content-type: text/html; charset=US-ASCII
Content-Disposition: inline

<html><body><p><tt>On Thu, Feb 09, 2017 at 12:04:26PM -0700, Jason Gunthorp=
e wrote:</tt><br><tt>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt=
; wrote on 02/10/2017 03:48:37 AM:<br><br>&gt; &gt; This series should focu=
s on allowing a user space RM to co-exist with<br>&gt; &gt; the in-kernel s=
ervices - lets try and tackle the idea of a<br>&gt; &gt; policy-restricted =
or unpriv-safe cdev when someone comes up with a<br>&gt; &gt; comprehensive=
 proposal..<br></tt><br><tt>First, does &quot;coexist&quot; mean in series =
(two layers of RM) or in parallel (both</tt><br><tt>have simultaneous acces=
s).</tt><br><br><tt>Or does &quot;in-kernel services&quot; not include an R=
M?</tt><br><br><tt>Assuming in series, it will complicate the lower RM. &nb=
sp;The main issue,</tt><br><tt>as always, is session context. &nbsp;If you =
permit the upper RM to save context,</tt><br><tt>the lower RM has to track =
the mapping, because the lower layer can</tt><br><tt>alter the saved sessio=
n context (regapping).</tt><BR>
</body></html>

--0__=0ABB0A50DFED59F48f9e8a93df938690918c0ABB0A50DFED59F4--



--===============9220249205725640816==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============9220249205725640816==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============9220249205725640816==--
