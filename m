From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [GIT PULL] tpmdd updates for 4.12
Date: Thu, 6 Apr 2017 10:31:06 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1704061030490.8642@namei.org>
References: <20170404153826.hxzphlvzqcesg7rt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170404153826.hxzphlvzqcesg7rt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 4 Apr 2017, Jarkko Sakkinen wrote:

> Hi James,
> 
> Here is the pull request for 4.12.
> 
> Major new features have been landed:
> 
> 1. TPM resource manager. There's a new device called /dev/tpmrm0. When this
> device is opened, a new session is created that is isolated from other users.
> Each user has its own set of volatile objects. There is also a new internal
> structure called struct tpm_space. This structure can be passed to tpm_transmit
> function and have own session to interact with the TPM. This could be
> potentially utilized by other kernel subsystems in the future.
> 2. ARM64 for support for tpm_crb.
> 3. Support for requesting and relinquishing locality 0 in tpm_crb. TXT uses
> locality 2 so we cannot assume that locality 0 is readily reserved when used
> in combination with TXT.
> 4. Comprehensive overhaul to tpm_tis_spi by Peter Huewe.
> 

Thanks for the summary.

Pulled.


-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
