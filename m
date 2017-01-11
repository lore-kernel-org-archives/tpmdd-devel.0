From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 10:59:24 -0500
Message-ID: <o55kol$ae2$1@blaine.gmane.org>
References: <kgoldman@us.ibm.com>
	<201701041612.v04GCfPK031525@wind.enjellic.com>
	<20170109231635.6wh25qoy7svcnys6@intel.com>
	<20170110200558.GA5102@obsidianresearch.com>
	<ee6c1e48-e21f-d05e-0939-473001224aba@sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <ee6c1e48-e21f-d05e-0939-473001224aba-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/11/2017 5:00 AM, Andreas Fuchs wrote:
>
> You need to do virtualization inside bodies, because TPM2_FlushContext
> carries it's handles inside the parameter body.
> Yep, huge blunder in the TPM spec, but hey, time for quirks... ;-)

It's not huge, not even a blunder.  The TPM spec Part 3 has a note 
explaining why the TPM side does it that way.

For the TSS and resource manager, simply treat flushHandle as a handle 
(in the handle area rather than in the parameter/body area).  It all 
just works.  I modified the TSS as a test, and there's no issue at all.



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
