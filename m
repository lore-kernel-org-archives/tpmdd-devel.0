From: <Peter.Huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: TPM2 Driver Support in distros (part 1)
Date: Mon, 25 Jul 2016 19:40:24 +0000
Message-ID: <af95149e773f4a40b20f75f4de19c06c@MUCSE612.infineon.com>
References: <nn1ajt$rpd$1@ger.gmane.org>
	<40c30de1f491455c93a79dd6f5420fc4@MUCSE612.infineon.com>
	<nn5ova$1j3$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <nn5ova$1j3$1@ger.gmane.org>
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

Hi,

>1 - How does a user know whether the TPM will use CRB or FIFO - whether to specify tpm_tis.force=1 or not?
Depends on his hardware -- most "physical" TPMs are FIFO, firmware based are CRB.

However, tpm_tis != tpm_crb, these are separate drivers. (tpm_crb might even be backport-able to previous versions, as a module)
so if no /dev/tpm0 appears, try tpm_tis.force=1

> Or can that be specified any time, and it becomes a noop for CRB?
Yes, if no /dev/tpm0 appears, try tpm_tis.force=1

>2 - module parameter?  Does that mean whatever distro dependent file is used for the boot parameters - grub.conf or some EFI file like grub.cfg.
Yes, exactly.

Thanks,
Peter

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
