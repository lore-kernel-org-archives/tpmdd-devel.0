From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Wed, 20 Jan 2016 10:40:24 -0500
Message-ID: <n7o9p6$bb3$1@ger.gmane.org>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
	<201601191753.u0JHrku2031608@d01av01.pok.ibm.com>
	<20160119180802.GA8038@obsidianresearch.com>
	<201601191818.u0JIIExQ010843@d03av04.boulder.ibm.com>
	<20160119230456.GB31745@obsidianresearch.com>
	<201601192315.u0JNFFG6030371@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201601192315.u0JNFFG6030371-Rn83F4s8Lwc+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/19/2016 6:15 PM, Stefan Berger wrote:
>
> If someone takes ownership of the TPM 1.2 a password is associated with
> the ownership and the SRK. How do you virtualize commands that need the
> SRK password when a user wants to create a key where the SRK is the
> parent? [snip]

An even easier example is PCRs.  The TPM has only one set of PCRs.

A hardware TPM does not support virtualization (meaning multiple virtual 
machines).

Many TPM documents refer to "virtualizing handles".  The meaning is 
closer to "virtual memory", but has nothing to do with virtual machines.



------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
