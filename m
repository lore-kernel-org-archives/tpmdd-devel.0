From: <Peter.Huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: TPM2 Driver Support in distros (part 2)
Date: Mon, 25 Jul 2016 16:55:23 +0000
Message-ID: <2e37d315b5a444ec80cd1199f2fa56c8@MUCSE612.infineon.com>
References: <nn1at3$vbq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <nn1at3$vbq$1@ger.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Ken,

> For distros or kernels that do not include a TPM 2.0 device driver:
> 1 - Is it possible to build and install a driver without rebuilding the kernel?
> 2 - If so, are there definitive instructions on how to do it?

The problem is more or less, that the TPM2.0 device driver is an _enhancement_ of the tpm_tis (1.2) driver.
In a perfect world the driver would not care at all whether it is 1.2 or 2.0, but (un)fortunately the driver has also some family specific functionality (e.g. get_timeouts, get random...)

If your current kernel has the tpm_tis driver as a module (or not at all) you could of course backport the latest driver and load this as a module.
However, (un)fortunately a lot of distros (e.g. Ubuntu) have IMA enabled, which requires TPM support to be built-in.
-> you cannot unload the tpm_tis driver -> so you would have to recompile the kernel.

> I've heard snippets that say a kernel that has a built-in TPM 1.2 driver cannot delete it and install a TPM 2.0 driver, but that sounds odd.  The kernel doesn't know the the platform hardware in advance, right?
And that's the reason for this.
If the distros were using tpm_tis as a module you could exchange it by rebuilding the module, but since a lot of them use it built-in, you have to recompile the kernel.


So the options are:
- upgrade to a later kernel
- or backport and rebuild yourself

Thanks
Peter 

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
