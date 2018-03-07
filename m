From: Thiebaud Weksteen via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: Regression from efi: call get_event_log before
 ExitBootServices
Date: Wed, 07 Mar 2018 08:41:42 +0000
Message-ID: <CA+zpnLdSyuyKjJEH3Oowmha2mF0B-j5b4A7CLuXXY7RH47SiFQ@mail.gmail.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
Reply-To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jeremy-+d1b7ckTlFUdnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi,

Thanks for testing and sending this report! This patch relies heavily on
the functions exposed by the firmware. My first guess would be that some of
these may not be implemented correctly by the manufacturer.

Could you share more information on this specific device?
Do you have any link to the manufacturer website (I found [1] but it is
based on an ARM CPU)?
Do you have the option to update your firmware? Is a copy of the firmware
available from the manufacturer?

On your side, I assume no error message got displayed on the screen when
booting. Would you be able to try to boot in an UEFI shell [2] and execute
the command "dh -v"?

Thanks,
Thiebaud

[1] https://www.gp-electronic.nl/product/7inchtablet
[2]
https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface#UEFI_Shell

On Tue, Mar 6, 2018 at 5:00 PM Jeremy Cline <jeremy-+d1b7ckTlFUdnm+yROfE0A@public.gmane.org> wrote:

> Hi folks,

> Commit 33b6d03469b2 ("efi: call get_event_log before ExitBootServices")
> causes my GP-electronic T701 tablet to hang when booting. Reverting the
> patch series or hiding the TPM in the BIOS fixes the problem.

> I've never fiddled with TPMs before so I'm not sure what what debugging
> information to provide. It's got an Atom Z3735G and the UEFI firmware is
> InsydeH20 version BYT70A.YNCHENG.WIN.007.


> Regards,
> Jeremy

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
