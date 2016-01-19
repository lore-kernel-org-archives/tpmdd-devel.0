From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Tue, 19 Jan 2016 16:42:51 -0700
Message-ID: <20160119234251.GA3652@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
	<201601191753.u0JHrku2031608@d01av01.pok.ibm.com>
	<20160119180802.GA8038@obsidianresearch.com>
	<201601191818.u0JIIExQ010843@d03av04.boulder.ibm.com>
	<20160119230456.GB31745@obsidianresearch.com>
	<201601192315.u0JNFGkm029862@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601192315.u0JNFGkm029862-YREtIfBy6dDImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 19, 2016 at 06:15:09PM -0500, Stefan Berger wrote:

>    > Ie per-ns virtualizing of the SRK with would be trivial.
>    If someone takes ownership of the TPM 1.2 a password is associated with
>    the ownership and the SRK. How do you virtualize commands that need the
>    SRK password when a user wants to create a key where the SRK is the
>    parent? Does the resource manager now have to know the SRK password and
>    inject it into commands where the SRK password seems necessary ?

When the TPM namespace is created the creator is responsible for
loading the virtual SRK into the TPM, so that agent would need the
physical owner password.

The kernel resource manager would deny access to the real SRK and swap
the well known SRK key handle for the key handle from above.

IIRC in alot of cases the virtual owner password can be become the
virtual SRK password and in the reamining cases the kernel can just
enforce a virtual owner password.

>    > Access control would already be done out of the box as a consequence
>    > of the process-to-process isolation the resource manager would need to
>    > perform.

>    Would that be a single hardware TPM for possibly hundreds of containers
>    on a system? How well does that scale?

I am just talking about how to extend the resource manager to provide
namespace semantics.

The resource manager would run over any existing kernel supported TPM,
so there is conceptually no problem with plugging in a software TPM
(or many) and then exporting that to the namespace - if that is what
the application requires.

>    Besides that a namespaced IMA will want to maintain an isolated list of
>    measurements per IMA namespace and ideally wants to extend measurements
>    into PCR 10 of a vTPM that is associated with that namespace.

Can a PCR be virtualized? I can't recall if an unlocked one can be
loaded to a known value. That would be best, just swap PCR 10 in and
out depending on the ns making the request.

IMA is supposed to protect against changes in boot, so the ideal world
would have a container use a PCR set that was HW measured from boot
and includes the software stack running out side the container and
then the stack inside the container.

I can't think of an obvious way to do that if the entire TPM is
software.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
