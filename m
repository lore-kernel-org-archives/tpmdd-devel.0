From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 10 Jan 2017 13:57:18 -0500
Message-ID: <o53aq8$jl6$2@blaine.gmane.org>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483639595.2515.52.camel@linux.vnet.ibm.com>
	<410e3045-58dc-5415-30c1-c86eb916b6c8@sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <410e3045-58dc-5415-30c1-c86eb916b6c8-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
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

On 1/6/2017 3:43 AM, Andreas Fuchs wrote:
> Am 05.01.2017 um 19:06 schrieb James Bottomley:
>
> Then how about blocking
> TPM2_GetCapabilities(TPM_CAP_HANDLES, 0x80000000) ?

Even just for debugging, this is a really useful command.

Won't the RM have a mapping from TPM to RM handle for
transient objects anyway?




------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
