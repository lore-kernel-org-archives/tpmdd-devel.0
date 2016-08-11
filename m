From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM2 Driver Support in distros (part 1)
Date: Thu, 11 Aug 2016 11:13:13 -0700
Message-ID: <20160811181313.ytcseswfrf7syzko@rhwork>
References: <nn1ajt$rpd$1@ger.gmane.org>
	<trinity-282fc7ab-b87b-4c45-8f1d-7ce1535c1a86-1470893731471@3capp-gmx-bs55>
Reply-To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <trinity-282fc7ab-b87b-4c45-8f1d-7ce1535c1a86-1470893731471@3capp-gmx-bs55>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu Aug 11 16, Peter Huewe wrote:
>
>Hi Ken,
>
>I just checked and it seems that RHEL7.2 has backported some parts of the =
TPM2.0 support to their 3.10 kernel.=A0
>For the tpm_tis part it is still lacking the acpi detection,
> but loading the tpm_tis driver with force=3D1 should result in a working =
driver.
>(either modprobe tpm_tis force=3D1  or at the boot commandline tpm_tis.for=
ce=3D1
>
>Thanks,
>
>Peter
>
>--------------------------------------------------------------------------=
----
>What NetFlow Analyzer can do for you? Monitors network bandwidth and traff=
ic
>patterns at an interface-level. Reveals which users, apps, and protocols a=
re
>consuming the most bandwidth. Provides multi-vendor support for NetFlow,
>J-Flow, sFlow and other flows. Make informed decisions using capacity
>planning reports. http://sdm.link/zohodev2dev
>_______________________________________________
>tpmdd-devel mailing list
>tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

The acpi detection fix is in our RHEL7 kernel currently being worked
on. The RHEL6.8 kernel also has some TPM2.0 support, including the
acpi detection fix, but doesn't have most of the commits that have hit
upstream since late last year. While there is kernel support for
TPM2.0 drivers in RHEL7 and RHEL6, there currently aren't any packages
providing userspace support like tpm-tools and trousers do for TPM1.2.

---------------------------------------------------------------------------=
---
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols ar=
e =

consuming the most bandwidth. Provides multi-vendor support for NetFlow, =

J-Flow, sFlow and other flows. Make informed decisions using capacity =

planning reports. http://sdm.link/zohodev2dev
