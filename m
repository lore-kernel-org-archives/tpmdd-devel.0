From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 2/7] tpm: validate TPM 2.0 commands
Date: Mon, 20 Mar 2017 15:42:13 -0400
Message-ID: <a518f288-f084-2d11-161a-79ff884b936d@linux.vnet.ibm.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
	<20170303151912.14752-3-jarkko.sakkinen@linux.intel.com>
	<22e8fa0caf8b4386a12cd93ee7170ed5@MUCSE603.infineon.com>
	<20170317161614.GA28082@obsidianresearch.com>
	<bca2bee3c1b84100ac72238425ac4791@MUCSE612.infineon.com>
	<12e63cdba1e34cac9b82e4bff9621ae6@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <12e63cdba1e34cac9b82e4bff9621ae6-nFblLGNE8XKJSz+rYg/bSJowlv4uC7bZ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 3/20/2017 5:54 AM, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
>
> There are a few special cases that need some thought though. For
> example, it is possible to use an upgrade to switch the TPM family
> from 1.2 to 2.0 (or vice versa). In this case it seems useful to let
> the kernel reinitialize the TPM driver, so it uses the correct
> timeouts for communication, activates the correct features (resource
> manager or not?), etc., without needing to reboot the system.

In practice, would a TPM upgrade from TPM 1.2 to TPM 2.0 even occur 
without a reboot?  Is it an important use case?

1 - It would leave the SHA-256 PCRs in the reset state.

2 - It's possible that this upgrade would also require a BIOS upgrade.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
